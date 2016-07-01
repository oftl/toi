package TOI::Schema::ResultSet::Tut;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub tweets_of_interest {
    my ($self, $args) = @_;
    my ($oth, $from, $to, $tlists, $obfuscate_names) =
        ($args->{oth}, $args->{from}, $args->{to}, $args->{tlists}, $args->{obfuscate_names});

    my @data;
    my $rn = $self->result_source->schema->resultset('RandomName');
    $rn->init(); # ensure different mapping on every call

    # get relevant tuts based on the list they appeared in
    my @tlists = map { $_->id() } $self->result_source->schema->resultset('TwitterList')->search ({ slug => { in => $tlists } });
    my $relevant_tuts = $self->search ({ seen => { '>=' => $from, '<=' => $to }, tlist => { in => \@tlists } });

    my @tags = $relevant_tuts->search (undef,
    {
        select => ['ttag', { count => 'ttag', -as => 'countT' }],
        as => ['ttag', 'countT' ],
        group_by => 'ttag',
        # sqlite needs specific information about types here
        having => \['countT >= ?', [ \"integer" => $oth ] ],
        order_by => { -desc => 'countT' },
    }
    );

    for my $t (@tags) {

        my @users = $relevant_tuts->search (
        {
            ttag => $t->ttag->id,
        },
        {
            select => ['tuser', { count => 'tuser', -as => 'countU' }],
            group_by => 'tuser',
            order_by => { -desc => 'countU' },
        })
        # consider first ten users max
        # TODO move to config
        ->slice (0, 9);

        my @user_list;

        for my $u (@users) {
            my $user = $u->tuser;

            push @user_list, {
                name => $obfuscate_names ? $rn->randomise($user->twitter_id()) : $user->full_name(),
                name_obfuscated => $obfuscate_names ? 1 : 0,
                twitter_id => $user->twitter_id,
                # another possibility would be to store countX in an already existing column
                count => $u->get_column('countU'),
            };
        }

        push @data, {
            text => $t->ttag->text(),
            count => $t->get_column('countT'),
            users => \@user_list,
        };
    }

    return \@data;
}

"we're only in it for the volume";
