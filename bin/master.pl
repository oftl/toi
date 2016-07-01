#!/usr/bin/perl

# commandline switches
# --environment=ENV

use strict;
use warnings;
use feature qw/say/;

use Data::Dumper;
use Net::Twitter;
use Date::Parse;
use Log::Log4perl;

use Dancer;
chdir config->{appdir};

use lib './lib';
use TOI::Schema;

my $NT;
my $LOGGER;
my $SCHEMA;

sub init {
    my $args = shift;
    my $toi_id = $args->{toi_id};

    my $log4perl_config = config->{appdir} . '/etc/log4perl.conf';
    my $connection_string = 'dbi:SQLite:' . config->{appdir} . '/db/toi.db';

    $SCHEMA = TOI::Schema->connect($connection_string);

    Log::Log4perl::init($log4perl_config);
    $LOGGER = Log::Log4perl->get_logger('main');

    my $toi = $SCHEMA->resultset('Toi')->find($toi_id);

    my $consumer_key = $toi->consumer_key();
    my $consumer_secret = $toi->consumer_secret();
    my $access_token = $toi->access_token();
    my $access_token_secret = $toi->access_token_secret();

    $NT = Net::Twitter->new(
        traits   => [qw/API::RESTv1_1 WrapError/],
        consumer_key        => $consumer_key,
        consumer_secret     => $consumer_secret,
        access_token        => $access_token,
        access_token_secret => $access_token_secret,

        ssl                 => 1,
    );
}

sub call_twitter {
    my $args = shift;
    my ($call, $params) = ($args->{call}, $args->{params});

    $LOGGER->info ("call_twitter(): calling $call");

    # keep trying to get an answer from the twitter api
    my $result = undef;
    my $count = 0;
    my $seconds_sleeping = 60 * 4;

    # just sleep a little. we'll be blocked otherwise anyways.
    sleep 3;

    do {
        $result = $NT->$call ($params);

        # see http://search.cpan.org/~mmims/Net-Twitter-4.00006/lib/Net/Twitter.pod#ERROR_HANDLING
        # for shortcomings of this way of error handling
        unless ($result) {
            my $error = $NT->get_error->{errors}->[0];

            if ($error->{code} == 88) {
                $LOGGER->info ('rate limit exceeded. good night. waiting ' . $seconds_sleeping / 60 . ' minutes');
                sleep $seconds_sleeping;
            }
            else {
                $LOGGER->info ("Twitter-API error $error->{code}: '$error->{message}'");
                $LOGGER->info ("Twitter-API error http_code: '$NT->{http_code}'");
                $LOGGER->info ("Twitter-API error http_message: '$NT->{http_message}'");
            }
        }
    } until $result;

    if ($count) {
        $LOGGER->info ("had to sleep for " . $count * $seconds_sleeping . " seconds");
    }

    return $result;
}

sub update_tlists {

    my $lists = call_twitter ({
        call => 'get_lists',
        params => {},
    });

    for my $list (@$lists) {

        my $l = $SCHEMA->resultset('TwitterList')->update_or_new (
            {
                list_id => $list->{id},
                slug => $list->{slug},
                screen_name => $list->{screen_name},
            },
            { key => 'list_id_unique' },
        );

        if ($l->in_storage) {
            $LOGGER->info ("got known list: $list->{slug}");
        }
        else {
            $LOGGER->info ("got new list: $list->{slug}");
            $l->insert();
        }
    }
}

sub tlists {
    update_tlists();
    return $SCHEMA->resultset('TwitterList')->all();
}

# get names for given list
# IN: list_id (db.twitter_lists.id)
sub update_tusers {

    my $list = shift;

    $LOGGER->info ("getting names for list " . $list->slug());

    # -1 indicates to the twitter api that we wan the first page
    my $cursor = -1;

    # a returned cursor of 0 means the last page was received
    while ($cursor != 0) {
        $LOGGER->info ("continuing at cursor: $cursor");

        my $members = call_twitter ({
            call => 'list_members',
            params => {
                list_id => $list->list_id(),
                slug => $list->slug(),
                owner_screen_name => $list->screen_name(),
                cursor => $cursor,
        }});

        for my $u (@{ $members->{users} }) {

            my $twitter_id = lc $u->{screen_name}; # not case sensitive usernames (!)
            my $full_name = $u->{name};

            my $tuser = $SCHEMA->resultset('Tuser')->find ({ twitter_id => $twitter_id });
            if ($tuser) {
                $LOGGER->info ("$full_name already exists");

                # this is obviously a public record. might already exists as private
                # (can happen if a couple new recoreds are added which reference amongst each other)
                # see [create_private_user] for this case to happen
                #

                # what is mentioned in @names is public anyway
                unless ($tuser->public()) {
                    $tuser->update ({ public => 1 });
                }

                # older versions didn't know about tlist. ensure it is set.
                # in theory this can be remove as soon as all existing twitter users have the list set.
                unless ($tuser->tlist()) {
                    $tuser->update ({ tlist => $list->id() });
                }
            }
            else {
                $LOGGER->info ("$full_name not on file yet, creating it ...");
                $tuser = $SCHEMA->resultset('Tuser')->create ({
                    twitter_id => $twitter_id,
                    full_name => $full_name,
                    tlist => $list->id(),
                    public => 1,
                    since_id => 1,
                });
            }
        }

        $cursor = $members->{next_cursor};
    }

    $LOGGER->info ('list ' . $list->slug() . ' done');
}

sub tusers {
    my $list = shift;

    update_tusers($list);

    my @tusers = $SCHEMA->resultset('Tuser')->search({ tlist => $list->id() });
    return \@tusers;
}

# list_id ... db:twitter_lists.id
sub work {
    my $tusers = shift;

    for my $tuser (@$tusers) {

        my $full_name = $tuser->full_name;
        my $twitter_id = lc $tuser->twitter_id;  # not case sensitive usernames (!)
        my $since_id = $tuser->since_id;

        my $result = call_twitter ({
            call => 'search',
            params => {
                q => 'from:' . $twitter_id,
                since_id => $since_id,
                count => 100,
        }});

        ### work through statuses

        for my $status ( @{$result->{statuses}} ) {
            # $status is one tweet.
            # it is used here more or less with the meaning 'the user who tweeted it'
            # it is called status in the twitter-api.

            my $created_at = $status->{created_at};

            for my $hashtag (@{ $status->{entities}->{hashtags} }) {
                my $lc_hashtag = lc $hashtag->{text};
                $LOGGER->info ("hashtag: $lc_hashtag");

                # start transaction

                my $ttag = $SCHEMA->resultset('Ttag')->find ({ text => $lc_hashtag });

                # TODO: update or create
                if ($ttag) {
                    $ttag->update({ count => $ttag->count() + 1 });
                }
                else {
                    $ttag = $SCHEMA->resultset('Ttag')->create({
                        count => 1,
                        text => $lc_hashtag,
                    });
                }

                my $tut = $SCHEMA->resultset('Tut')->create ({
                    tuser => $tuser->id,
                    ttag => $ttag->id,
                    seen => str2time ($created_at),
                    tlist => $tuser->tlist,
                });

                # end transaction
            }

            # update since_id
            if ($status->{id} > $tuser->since_id()) {
                $tuser->update ({ since_id => $status->{id} });
            }
        }
    }
}

#
### main ###
#

init ({ toi_id => 1 });
$LOGGER->info ("master.pl start");

while (1) {
    $LOGGER->info ("master.pl starting new round");

    my @tlists = tlists();

    for my $list (@tlists) {
        my $tusers = tusers ($list);
        work ($tusers);
    }
}

$LOGGER->info ("master.pl done [this can actually not happen]");
