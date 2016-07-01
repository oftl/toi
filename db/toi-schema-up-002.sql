-- drop table twitter_lists;

create table twitter_lists (
    id          integer primary key autoincrement,
    list_id     text unique not null,
    slug        text not null,
    screen_name text
);

-- alter table tusers drop column tlist;

alter table tusers add column
    tlist integer references twitter_lists(id) on delete cascade on update cascade;
