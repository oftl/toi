package TOI;
use Dancer ':syntax';
use Dancer::Plugin::Ajax;
use Dancer::Plugin::DBIC qw(schema resultset rset);

our $VERSION = '0.3';

use JSON::XS;
use List::Util 'shuffle';

get '/' => sub {
    my $tlists;

    for my $tl (schema->resultset('TwitterList')->all()) {
        push @$tlists, { slug => $tl->slug(), id => $tl->id() };
    }

    template 'main', {
        tlists => $tlists,
        top_n  => get_top_n ({
            n       => 10,
            periods => [ 24, 48, 72, ],
        })
    };
};

# keep old links working
get '/data/cloud2' => sub {
    redirect '/', 301;
};

get '/top_n' => sub {

    template 'main/top_n', {
        top_n => get_top_n ({
            n       => 10,
            periods => [ 24, 48, 72, ],
        })
    };
};

ajax '/data/load' => sub {

    my @tlists;
    defined (params->{tlists}) and
        @tlists = split (',', params->{tlists});

    my $data = schema->resultset('Tut')->tweets_of_interest({
        oth => params->{oth},
        from => params->{from},
        to => params->{to},
        tlists => \@tlists,
        obfuscate_names => (params->{obfuscate_names} eq 'no') ? 0 : 1,
    });

    my $coder = JSON::XS->new;

    return {
        version => time(),
        data => $coder->encode ($data),
    };
};

sub datetime_string {
    my $secs = shift;
    $secs or die "USAGE: datetime_string (<seconds>)";

    my @t     = localtime ($secs);
    my $year  = $t[5] + 1900;
    my $month = sprintf("%02d", $t[4] + 1);
    my $day   = sprintf("%02d", $t[3]);
    my $hour  = sprintf("%02d", $t[2]);
    my $min   = sprintf("%02d", $t[1]);
    my $sec   = sprintf("%02d", $t[0]);

    return "$year-$month-$day $hour:$min:$sec";
};

sub get_top_n {
    my $args    = shift;
    my $n       = $args->{n};
    my $periods = $args->{periods};

    my @top_n;

    for (@$periods) {
        my $period = $_ * 3600;

        my ($created, $top_n, $top_n_total, $top_n_total_base) =
            @{ schema->resultset('TopN')->get_top_n ({
                period => $period,
                n      => $n,
            }) }
            {qw/created top_n top_n_total top_n_total_base/}
        ;

        push @top_n, {
            n                => $n,
            created          => datetime_string ($created),
            period           => "$_ hours",
            top_n            => $top_n,
            top_n_total      => $top_n_total,
            top_n_total_base => $top_n_total_base,
        }
    }

    return \@top_n;
}

"I got your name here written in a rose tattoo";
