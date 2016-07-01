use utf8;
package TOI::Schema::Result::Tut;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TOI::Schema::Result::Tut

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

=head1 TABLE: C<tut>

=cut

__PACKAGE__->table("tut");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 tuser

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 ttag

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 seen

  data_type: 'integer'
  is_nullable: 0

=head2 integer

  data_type: (empty string)
  is_foreign_key: 1
  is_nullable: 1

=head2 tlist

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "tuser",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "ttag",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "seen",
  { data_type => "integer", is_nullable => 0 },
  "integer",
  { data_type => "", is_foreign_key => 1, is_nullable => 1 },
  "tlist",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 integer

Type: belongs_to

Related object: L<TOI::Schema::Result::TwitterList>

=cut

__PACKAGE__->belongs_to(
  "integer",
  "TOI::Schema::Result::TwitterList",
  { id => "integer" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

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

=head2 ttag

Type: belongs_to

Related object: L<TOI::Schema::Result::Ttag>

=cut

__PACKAGE__->belongs_to(
  "ttag",
  "TOI::Schema::Result::Ttag",
  { id => "ttag" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 tuser

Type: belongs_to

Related object: L<TOI::Schema::Result::Tuser>

=cut

__PACKAGE__->belongs_to(
  "tuser",
  "TOI::Schema::Result::Tuser",
  { id => "tuser" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-09-28 20:49:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wVc2DBY4ALEbuEcgD5rffQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
