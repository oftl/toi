use utf8;
package TOI::Schema::Result::Ttag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TOI::Schema::Result::Ttag

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

=head1 TABLE: C<ttags>

=cut

__PACKAGE__->table("ttags");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 count

  data_type: 'integer'
  default_value: 1
  is_nullable: 1

=head2 text

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "count",
  { data_type => "integer", default_value => 1, is_nullable => 1 },
  "text",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 top_ns

Type: has_many

Related object: L<TOI::Schema::Result::TopN>

=cut

__PACKAGE__->has_many(
  "top_ns",
  "TOI::Schema::Result::TopN",
  { "foreign.ttag" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tuts

Type: has_many

Related object: L<TOI::Schema::Result::Tut>

=cut

__PACKAGE__->has_many(
  "tuts",
  "TOI::Schema::Result::Tut",
  { "foreign.ttag" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2015-07-29 17:48:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lHjwcKaoRLOSmmGjvT5B/A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
