#!/usr/bin/perl

# commandline switches
# --environment=ENV

use strict;
use warnings;
use feature qw/say/;
use Data::Dumper;

use lib './lib';
use TOI::Schema;
use Cwd;
my $pwd = cwd();
my $connection_string = 'dbi:SQLite:' . $pwd . '/db/toi.db';

my $schema = TOI::Schema->connect($connection_string);
# my $tlists = $schema->resultset('TwitterList')->all();

$schema->resultset('TopN')->do_top_n ({
    period => 3_600 * 24,
    top_n  => 10,
});

$schema->resultset('TopN')->do_top_n ({
    period => 3_600 * 48,
    top_n  => 10,
});

$schema->resultset('TopN')->do_top_n ({
    period => 3_600 * 72,
    top_n  => 10,
});
