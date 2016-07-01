use utf8;
package TOI::Schema::Result::TopN;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

TOI::Schema::Result::TopN

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

=head1 TABLE: C<top_n>

=cut

__PACKAGE__->table("top_n");

=head1 ACCESSORS

=head2 tlist

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 position

  data_type: 'integer'
  is_nullable: 0

=head2 period

  data_type: 'integer'
  is_nullable: 0

=head2 count

  data_type: 'integer'
  is_nullable: 1

=head2 created

  data_type: 'integer'
  is_nullable: 1

=head2 ttag

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "tlist",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "position",
  { data_type => "integer", is_nullable => 0 },
  "period",
  { data_type => "integer", is_nullable => 0 },
  "count",
  { data_type => "integer", is_nullable => 1 },
  "created",
  { data_type => "integer", is_nullable => 1 },
  "ttag",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</tlist>

=item * L</position>

=item * L</period>

=back

=cut

__PACKAGE__->set_primary_key("tlist", "position", "period");

=head1 RELATIONS

=head2 tlist

Type: belongs_to

Related object: L<TOI::Schema::Result::TwitterList>

=cut

__PACKAGE__->belongs_to(
  "tlist",
  "TOI::Schema::Result::TwitterList",
  { id => "tlist" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
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


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2015-07-29 17:48:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TZtmhdOUr9v/uLG5Qq4oUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
