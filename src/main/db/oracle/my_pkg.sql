create or replace package my_pkg is

   PROCEDURE get_users
   (
      p_first_name  IN  usr.first_name%type
    , p_last_name   IN  usr.last_name%type
    , p_users       OUT SYS_REFCURSOR
    , p_roles       OUT SYS_REFCURSOR
    , p_authorities OUT SYS_REFCURSOR
   );

end my_pkg;
/

create or replace package body my_pkg is

   PROCEDURE get_users
   (
      p_first_name  IN  usr.first_name%type
    , p_last_name   IN  usr.last_name%type
    , p_users       OUT SYS_REFCURSOR
    , p_roles       OUT SYS_REFCURSOR
    , p_authorities OUT SYS_REFCURSOR
   )
   AS
      l_condition varchar2(4000);
      
      l_users_query varchar2(4000) default
         'SELECT u.id
               , u.first_name
               , u.last_name
            FROM usr u
           WHERE 1=1 ';
           
      l_roles_query varchar2(4000) default
         'SELECT r.id role_id
               , u.id usr_id
               , r.name
            FROM role r
               , usr u
               , usr_role x
           WHERE x.role_id = r.id
             AND x.usr_id  = u.id ';
             
      l_authorities_query varchar2(4000) default
         'SELECT a.id authority_id
               , r.id role_id
               , u.id usr_id
               , a.name
            FROM authority a
               , usr u
               , role r
               , usr_role x
               , role_authority y
           WHERE x.usr_id       = u.id
             AND x.role_id      = r.id
             AND y.authority_id = a.id
             AND y.role_id      = r.id  ';          
   BEGIN     
      IF (p_first_name IS NOT NULL )
      THEN
         dbms_session.set_context('MY_CTX', 'FIRST_NAME', upper(p_first_name) || '%');
         l_condition := ' and upper(u.first_name) like sys_context( ''MY_CTX'', ''FIRST_NAME'' ) ';
         l_users_query := l_users_query || l_condition;
         l_roles_query := l_roles_query || l_condition;
         l_authorities_query := l_authorities_query || l_condition;         
      END IF;

      IF (p_last_name IS NOT NULL )
      THEN
         dbms_session.set_context('MY_CTX', 'LAST_NAME', upper(p_last_name) || '%');
         l_condition := ' and upper(u.last_name) like sys_context( ''MY_CTX'', ''LAST_NAME'' ) ';
         l_users_query := l_users_query || l_condition;
         l_roles_query := l_roles_query || l_condition;
         l_authorities_query := l_authorities_query || l_condition;         
      END IF;

      l_users_query := l_users_query || ' order by u.last_name, u.first_name, u.id ';
      l_roles_query := l_roles_query || ' order by u.id, r.id, r.name ';
      l_authorities_query := l_authorities_query || ' order by u.id, r.id, a.id ';
      
      OPEN p_users FOR l_users_query;
      OPEN p_roles FOR l_roles_query;
      OPEN p_authorities FOR l_authorities_query;
      
   END;

end my_pkg;
/
