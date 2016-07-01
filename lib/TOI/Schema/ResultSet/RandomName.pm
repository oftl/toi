package TOI::Schema::ResultSet::RandomName;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use feature qw/say/;
use List::Util 'shuffle';

my $mapping;
my $names;

sub init {
    my $self = shift;

    $mapping = {};
    @$names = shuffle ( map { $_->name() } $self->all() );
}

sub randomise {
    my ($self, $name) = @_;
    # $name will usually be the twitter_id

    unless ($mapping->{$name}) {
        $mapping->{$name} = pop @$names;
    }

    return $mapping->{$name};
}

"bring the noise!";
