create table top_n (
    tlist    integer references twitter_lists(id) on delete cascade on update cascade,
    position integer,
    period   integer,  -- secs since epoch
    count    integer,
    created  integer,  -- creation of this entry (secs sinc epoch)
    ttag     integer references ttags(id) on delete cascade on update cascade,

    constraint pkey PRIMARY KEY (tlist, position, period)
);
