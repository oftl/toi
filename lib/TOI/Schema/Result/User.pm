use utf8;
package TOI::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TOI::Schema::Result::User

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

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 login

  data_type: 'varchar'
  is_nullable: 1

=head2 name

  data_type: 'varchar'
  is_nullable: 1

=head2 password

  data_type: 'varchar'
  is_nullable: 1

=head2 email

  data_type: 'varchar'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "login",
  { data_type => "varchar", is_nullable => 1 },
  "name",
  { data_type => "varchar", is_nullable => 1 },
  "password",
  { data_type => "varchar", is_nullable => 1 },
  "email",
  { data_type => "varchar", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<login_unique>

=over 4

=item * L</login>

=back

=cut

__PACKAGE__->add_unique_constraint("login_unique", ["login"]);

=head1 RELATIONS

=head2 tois

Type: has_many

Related object: L<TOI::Schema::Result::Toi>

=cut

__PACKAGE__->has_many(
  "tois",
  "TOI::Schema::Result::Toi",
  { "foreign.owner" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<TOI::Schema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "TOI::Schema::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "user_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-07-16 11:40:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:O8+JQqF3T1DWzR5QShR/5A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
