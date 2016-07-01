use utf8;
package TOI::Schema::Result::TopNHistory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TOI::Schema::Result::TopNHistory

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<top_n_history>

=cut

__PACKAGE__->table("top_n_history");

=head1 ACCESSORS

=head2 period

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 created

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "period",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "created",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</period>

=back

=cut

__PACKAGE__->set_primary_key("period");


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2015-07-31 09:18:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1CUHSV7yE6WR7XN5HsDFQQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
