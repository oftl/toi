-- create an initial user
--
insert into user (login, name, password, email) values ( .. );

insert into role (role) values ('admin');

-- make yourself admin
--
insert into user_role (user_id, role_id) values ( .. );

-- add twitter credentials
--
insert into toi (owner, consumer_key, consumer_secret, access_token, access_token_secret) values ( .. );
