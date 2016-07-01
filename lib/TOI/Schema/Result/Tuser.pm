use utf8;
package TOI::Schema::Result::Tuser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TOI::Schema::Result::Tuser

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

=head1 TABLE: C<tusers>

=cut

__PACKAGE__->table("tusers");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 twitter_id

  data_type: 'text'
  is_nullable: 0

=head2 full_name

  data_type: 'text'
  is_nullable: 1

=head2 public

  data_type: 'text'
  default_value: 0
  is_nullable: 1

=head2 since_id

  data_type: 'text'
  default_value: 1
  is_nullable: 1

=head2 tlist

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "twitter_id",
  { data_type => "text", is_nullable => 0 },
  "full_name",
  { data_type => "text", is_nullable => 1 },
  "public",
  { data_type => "text", default_value => 0, is_nullable => 1 },
  "since_id",
  { data_type => "text", default_value => 1, is_nullable => 1 },
  "tlist",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<twitter_id_unique>

=over 4

=item * L</twitter_id>

=back

=cut

__PACKAGE__->add_unique_constraint("twitter_id_unique", ["twitter_id"]);

=head1 RELATIONS

=head2 tlist

Type: belongs_to

Related object: L<TOI::Schema::Result::TwitterList>

=cut

__PACKAGE__->belongs_to(
  "tlist",
  "TOI::Schema::Result::TwitterList",
  { id => "tlist" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 tuts

Type: has_many

Related object: L<TOI::Schema::Result::Tut>

=cut

__PACKAGE__->has_many(
  "tuts",
  "TOI::Schema::Result::Tut",
  { "foreign.tuser" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-07-28 12:20:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BOlMPQI4GHWajUwq6uzKQQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
