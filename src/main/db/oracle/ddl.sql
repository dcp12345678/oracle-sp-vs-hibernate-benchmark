create table usr ( id number(32) primary key
                 , first_name varchar2(100)
                 , last_name varchar2(100));
                 
create table role ( id number(32) primary key
                  , name varchar2(100)
                  , CONSTRAINT role_unique UNIQUE (name));
                  
create table usr_role ( usr_id number(32) references usr(id)
                      , role_id number(32) references role(id)
                      , primary key (usr_id, role_id));
                      
create table authority ( id number(32) primary key
                       , name varchar2(100)
                       , CONSTRAINT authority_unique UNIQUE (name));
                                   
create table role_authority ( role_id number(32) references role(id)
                            , authority_id number(32) references authority(id)
                            , primary key (role_id, authority_id));

create index usr_ndx_first_name on usr(first_name);
create index usr_ndx_last_name on usr(last_name);

create index usr_ndx_first_name_upper on usr(UPPER(first_name));
create index usr_ndx_last_name_upper on usr(UPPER(last_name));

create sequence id_seq;

create or replace context my_ctx using my_pkg;

