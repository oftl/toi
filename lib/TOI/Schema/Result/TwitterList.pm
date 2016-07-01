use utf8;
package TOI::Schema::Result::TwitterList;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TOI::Schema::Result::TwitterList

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

=head1 TABLE: C<twitter_lists>

=cut

__PACKAGE__->table("twitter_lists");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 list_id

  data_type: 'text'
  is_nullable: 0

=head2 slug

  data_type: 'text'
  is_nullable: 0

=head2 screen_name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "list_id",
  { data_type => "text", is_nullable => 0 },
  "slug",
  { data_type => "text", is_nullable => 0 },
  "screen_name",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<list_id_unique>

=over 4

=item * L</list_id>

=back

=cut

__PACKAGE__->add_unique_constraint("list_id_unique", ["list_id"]);

=head1 RELATIONS

=head2 top_ns

Type: has_many

Related object: L<TOI::Schema::Result::TopN>

=cut

__PACKAGE__->has_many(
  "top_ns",
  "TOI::Schema::Result::TopN",
  { "foreign.tlist" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tusers

Type: has_many

Related object: L<TOI::Schema::Result::Tuser>

=cut

__PACKAGE__->has_many(
  "tusers",
  "TOI::Schema::Result::Tuser",
  { "foreign.tlist" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tut_integers

Type: has_many

Related object: L<TOI::Schema::Result::Tut>

=cut

__PACKAGE__->has_many(
  "tut_integers",
  "TOI::Schema::Result::Tut",
  { "foreign.integer" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tut_tlists

Type: has_many

Related object: L<TOI::Schema::Result::Tut>

=cut

__PACKAGE__->has_many(
  "tut_tlists",
  "TOI::Schema::Result::Tut",
  { "foreign.tlist" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2015-07-29 17:48:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dmM7WOLfQN/j53DW4IONCQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
