drop table if exists user_role;
drop table if exists role;
drop table if exists user;
drop table if exists toi;
drop table if exists tusers;
drop table if exists ttags;
drop table if exists tut;
drop table if exists random_names;

create table user (
    id       integer primary key autoincrement,
    login    varchar unique,
    name     varchar,
    password varchar,
    email    varchar
);

create table role (
    id      integer primary key autoincrement,
    role    text
);

create table user_role (
    user_id     integer references user(id) on delete cascade on update cascade,
    role_id     integer references role(id) on delete cascade on update cascade,
    primary key (user_id, role_id)
);

create table toi (
    id      integer primary key autoincrement,
    owner   integer references user(id) on delete cascade on update cascade,

    consumer_key        text not null,
    consumer_secret     text not null,
    access_token        text not null,
    access_token_secret text not null
);

create table tusers (
    id          integer primary key autoincrement,
    twitter_id  text unique not null,
    full_name   text,
    public      text default 0,
    since_id    text default 1
);

create table ttags (
    id      integer primary key autoincrement,
    count   integer default 1,    -- global_count
    text    text not null
);

create table tut (
    id     integer primary key autoincrement,
    tuser  integer references tusers(id) on delete cascade on update cascade,
    ttag   integer references ttags(id) on delete cascade on update cascade,
    seen   integer not null
);

create table random_names (
    id      integer primary key autoincrement,
    name    text not null
);
