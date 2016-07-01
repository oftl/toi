all: toi-schema toi-data schema

toi-schema: toi-schema.sql
	sqlite3 toi.db < toi-schema.sql
	sqlite3 toi.db < toi-schema-up-002.sql
	sqlite3 toi.db < toi-schema-up-003.sql
	sqlite3 toi.db < toi-schema-up-004.sql
	sqlite3 toi.db < toi-schema-up-005.sql

toi-data: toi-data.sql
	sqlite3 toi.db < toi-data.sql

toi-data-random_names: toi-data-random_names.sql
	sqlite3 toi.db < toi-data-random_names.sql

schema:
	perl -MDBIx::Class::Schema::Loader=make_schema_at,dump_to_dir:../lib -e 'make_schema_at("TOI::Schema", { db_schema => 'toi', components => ["InflateColumn::DateTime","TimeStamp","PassphraseColumn"] }, [ "dbi:SQLite:toi.db" ])'

hasher:
	DBIC_TRACE=1 perl -I../lib pw_hasher.pl

clean:
	rm -f toi.db

db-clean:
	sqlite3 toi.db < toi-clean.sql
