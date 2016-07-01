package TOI::Schema::ResultSet::TopN;

use strict;
use warnings;
use base 'DBIx::Class::ResultSet';

sub get_top_ten {
    my ($self, $args) = @_;

    my $period = $args->{period} // 86400;
    my $n      = 3;

    return $self->get_top_n ({
        period => $period,
        n      => $n,
    })
}

sub get_top_n {
    my ($self, $args) = @_;

    my $period = $args->{period};
    my $n      = $args->{n};

    $period or die "mandatory parameter <period> missing";
    $n      or die "mandatory parameter <n> missing";

    # per list and a total derived from that result
    #
    my ($data, $total);
    my @tops = $self->search ({
        tlist  => { '!=', undef },
        period => $period,
        position => { '<=', $n },
    })->search (undef, {
        order_by => { -desc => [qw/tlist position/] },
    });

    for my $top (@tops) {
        my $ttag = $top->ttag->text;
        my $count = $top->count;

        $data->{$top->tlist->slug}->{$top->position} = {
            count    => $count,
            ttag     => $ttag,
        };

        $total->{$ttag} = $total->{$ttag}
            ? $total->{$ttag} + $count
            : $count
        ;
    }

    my @keys = sort { $total->{$b} <=> $total->{$a} } keys (%$total);
    my @tot;

    for my $k (@keys) {
        push @tot, {
            ttag  => $k,
            count => $total->{$k},
        }
    }

    # in differnt lists very differnt hashtags can be in the top-n range
    # but we only want the top $n in the result
    splice @tot, $n;

    # totals summed up directly
    #
    my @total_tops = $self
        ->search ({
            tlist  => { '=', undef },
            period => $period,
            position => { '<=', $n },
        })
        ->search (undef, {
            order_by => { -desc => 'position' },
        })
    ;
    my @total_base;

    for my $top (@total_tops) {
        unshift @total_base, {
            ttag =>  $top->ttag->text,
            count => $top->count,
        }
    }

    my $created = $self->result_source->schema->resultset('TopNHistory')->single ({ period => $period })->created;

    return ({
        created          => $created,
        top_n            => $data,
        top_n_total      => \@tot,
        top_n_total_base => \@total_base,       # make these refs
    });
}

#
# list: [n.m,]
# periode: 24h
#
sub do_top_n {
    my ($self, $args) = @_;
    my ($period, $top_n) = ($args->{period}, $args->{top_n});

    $period or die "mandatory parameter <period> missing";
    $top_n  or die "mandatory parameter <top_n> missing";

    my $start = time();
    my $to    = $start;
    my $from  = $to - $period;

    # $tlists ISA string
    my @tlists = map {
        { id   => $_->id,
          slug => $_->slug,
        }
    } $self->result_source->schema->resultset('TwitterList')->all();

    ### total ###
    #
    my @total;

    my $total_relevant_tuts = $self->result_source->schema->resultset('Tut')->search ({
        seen => { '>=' => $from, '<=' => $to },
    });

    my @total_ret = $total_relevant_tuts->search (undef, {
        select   => ['ttag', { count => 'ttag', -as => 'countN' }],
        as       => ['ttag', 'countN' ],
        group_by => 'ttag',
        order_by => { -desc => 'countN' },
        # that's sql's limit
        rows     => $top_n,
    });

    my $total_position = 1;


    for my $total_r (@total_ret) {
        ### must delete because update_or_create seems to have a problem with null values in the key
        $self->search ({
            tlist    => undef,
            position => $total_position,
            period   => $period,
        })->delete();

        $self->update_or_create ({
            # pkey
            tlist    => undef,
            position => $total_position,
            period   => $period,
            # data
            count    => $total_r->get_column('countN'),
            ttag     => $total_r->ttag->id,
            created  => time(),
        });

        $total_position++;
    }

    ### per list ###
    #
    my @data;

    for my $tlist (@tlists) {
        #### my $relevant_tuts = $self->search ({
        my $relevant_tuts = $self->result_source->schema->resultset('Tut')->search ({
            seen     => { '>=' => $from, '<=' => $to },
            tlist    => { in => [ $tlist->{id} ] },
        });

        my @ret = $relevant_tuts->search (undef, {
            select   => ['ttag', { count => 'ttag', -as => 'countN' }],
            as       => ['ttag', 'countN' ],
            group_by => 'ttag',
            order_by => { -desc => 'countN' },
            # that's sql's limit
            rows     => $top_n,
        });

        my $position = 1;
        my @marcel;

        for my $r (@ret) {
            push @marcel, {
                position => $position,
                count    => $r->get_column('countN'),
                text     => $r->ttag->text,
            };

            $self->update_or_create ({
                # pkey
                tlist    => $tlist->{id},
                position => $position,
                period   => $period,
                # data
                count    => $r->get_column('countN'),
                ttag     => $r->ttag->id,
                created  => time(),
            });

            $position++;
        }

        push @data, {
            id    => $tlist->{id},
            slug  => $tlist->{slug},
            top_n => \@marcel,
        }

    }

    # write history
    $self->result_source->schema->resultset('TopNHistory')->update_or_create ({
        period  => $period,
        created => $start,
    });

    return \@data;
}

"Let me enlighten you. This is the way i pray."
