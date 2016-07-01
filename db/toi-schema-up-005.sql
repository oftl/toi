create table top_n_history (
    period  integer,  -- secs since epoch
    created integer,  -- creation of this entry (secs sinc epoch)

    constraint pkey PRIMARY KEY (period)
);
