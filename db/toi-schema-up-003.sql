alter table tut add column tlist integer references twitter_lists(id) on delete cascade on update cascade;

-- update existing tuts
update tut set tlist = (select tlist from tusers where tut.tuser=tusers.id);
