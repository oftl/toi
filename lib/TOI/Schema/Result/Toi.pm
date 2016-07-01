use utf8;
package TOI::Schema::Result::Toi;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TOI::Schema::Result::Toi

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

=head1 TABLE: C<toi>

=cut

__PACKAGE__->table("toi");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 owner

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 consumer_key

  data_type: 'text'
  is_nullable: 0

=head2 consumer_secret

  data_type: 'text'
  is_nullable: 0

=head2 access_token

  data_type: 'text'
  is_nullable: 0

=head2 access_token_secret

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "owner",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "consumer_key",
  { data_type => "text", is_nullable => 0 },
  "consumer_secret",
  { data_type => "text", is_nullable => 0 },
  "access_token",
  { data_type => "text", is_nullable => 0 },
  "access_token_secret",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 owner

Type: belongs_to

Related object: L<TOI::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "owner",
  "TOI::Schema::Result::User",
  { id => "owner" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07033 @ 2013-07-16 11:40:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dibARts1pKPGong03ZfRQQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
