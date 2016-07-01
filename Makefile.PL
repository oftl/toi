use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'TOI',
    AUTHOR              => q{oftl <github@rockandroll.at>},
    VERSION_FROM        => 'lib/TOI.pm',
    ABSTRACT            => 'TOI Tweets Of Interest',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.311,
        'JSON'       => 0,
        'JSON::XS'   => 0,
        'Dancer::Plugin::DBIC'  => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'TOI-*' },
);
