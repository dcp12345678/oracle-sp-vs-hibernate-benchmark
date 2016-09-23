create or replace package my_pkg is

   /* =================================================================================== */
   /* get_users_full - Gets users for given criteria, and also gets roles and authorities */
   /*                  for each user. It uses paging to fetch the given subset of records */
   /*                  for the given criteria.                                            */
   /*                                                                                     */
   /* Parameters:                                                                         */
   /* p_first_name - The first name to use when searching for users. The search will use  */
   /*                this parameter in a LIKE condition with a trailing percent, so if    */
   /*                you pass in 'Bob', then it will search for first names like 'Bob%'.  */
   /* p_last_name - The last name to use when searching for users. See notes on           */
   /*               p_first_name as this parameter works the same way.                    */
   /* p_page_num - The page number to retrieve.                                           */
   /* p_page_size - The page size. If page size is 10 and page number is 3, then records  */
   /*               30-40 will be returned in p_result_cursor.                            */
   /* p_result_cursor - An output ref cursor which will contain the search results.       */
   /* =================================================================================== */
   PROCEDURE get_users_full
   (
      p_first_name    IN  usr.first_name%type
    , p_last_name     IN  usr.last_name%type
    , p_page_num      IN  integer
    , p_page_size     IN  integer
    , p_result_cursor OUT SYS_REFCURSOR
   );

   /* =================================================================================== */
   /* get_users - Gets users for given criteria. It uses paging to fetch the given subset */
   /*             of records for the given criteria.                                      */
   /*                                                                                     */
   /* Parameters:                                                                         */
   /* p_first_name - The first name to use when searching for users. The search will use  */
   /*                this parameter in a LIKE condition with a trailing percent, so if    */
   /*                you pass in 'Bob', then it will search for first names like 'Bob%'.  */
   /* p_last_name - The last name to use when searching for users. See notes on           */
   /*               p_first_name as this parameter works the same way.                    */
   /* p_page_num - The page number to retrieve.                                           */
   /* p_page_size - The page size. If page size is 10 and page number is 3, then records  */
   /*               30-40 will be returned in p_result_cursor.                            */
   /* p_result_cursor - An output ref cursor which will contain the search results.       */
   /* =================================================================================== */
   PROCEDURE get_users
   (
      p_first_name    IN  usr.first_name%type
    , p_last_name     IN  usr.last_name%type
    , p_page_num      IN  integer
    , p_page_size     IN  integer
    , p_result_cursor OUT SYS_REFCURSOR
   );

   /* =================================================================================== */
   /* get_roles - Gets roles for given user id.                                           */
   /*                                                                                     */
   /* Parameters:                                                                         */
   /* p_user_id - The user id.                                                            */
   /* p_result_cursor - An output ref cursor which will contain the results.              */
   /* =================================================================================== */
   PROCEDURE get_roles
   (
      p_user_id    IN  usr.id%TYPE
    , p_result_cursor OUT SYS_REFCURSOR
   );
   
   /* =================================================================================== */
   /* get_authorities - Gets authorities for given role id.                               */
   /*                                                                                     */
   /* Parameters:                                                                         */
   /* p_role_id - The role id.                                                            */
   /* p_result_cursor - An output ref cursor which will contain the results.              */
   /* =================================================================================== */
   PROCEDURE get_authorities
   (
      p_role_id       IN  role.id%TYPE
    , p_result_cursor OUT SYS_REFCURSOR
   );
   
end my_pkg;
/

create or replace package body my_pkg is

   /* =================================================================================== */
   /* get_users_full - Gets users for given criteria, and also gets roles and authorities */
   /*                  for each user. It uses paging to fetch the given subset of records */
   /*                  for the given criteria.                                            */
   /*                                                                                     */
   /* Parameters:                                                                         */
   /* p_first_name - The first name to use when searching for users. The search will use  */
   /*                this parameter in a LIKE condition with a trailing percent, so if    */
   /*                you pass in 'Bob', then it will search for first names like 'Bob%'.  */
   /* p_last_name - The last name to use when searching for users. See notes on           */
   /*               p_first_name as this parameter works the same way.                    */
   /* p_page_num - The page number to retrieve.                                           */
   /* p_page_size - The page size. If page size is 10 and page number is 3, then records  */
   /*               30-40 will be returned in p_result_cursor.                            */
   /* p_result_cursor - An output ref cursor which will contain the search results.       */
   /* =================================================================================== */
   PROCEDURE get_users_full
   (
      p_first_name    IN  usr.first_name%type
    , p_last_name     IN  usr.last_name%type
    , p_page_num      IN  integer
    , p_page_size     IN  integer
    , p_result_cursor OUT SYS_REFCURSOR
   )
   AS
      l_start_user_row integer;
      l_end_user_row integer;      
      l_conditions varchar2(4000) default ' ';
      l_paging_criteria varchar2(4000) default '1=1';
      
      -- Build a query to retrieve the users
      -- We use a %conditions% placeholder, which we will replace later with the search criteria
      l_users_query varchar2(4000) default
         'SELECT u.id
               , u.first_name
               , u.last_name
               , row_number() over (order by u.last_name, u.first_name, u.id) row_num
            FROM usr u
           WHERE 1=1
                 %conditions%
        ORDER BY
                 u.last_name
               , u.first_name
               , u.id ';

      -- this is the full query which will be used to retrieve the users, roles and authorities               
      l_full_query varchar2(4000) default
         'SELECT u.id          usr_id
               , u.first_name
               , u.last_name     
               , r.id          role_id
               , r.name        role_name
               , a.id          authority_id
               , a.name        authority_name
               , u.row_num
            FROM ( %users_query% ) u
                 , role r
                 , authority a
                 , usr_role x
                 , role_authority y
             WHERE x.role_id      = r.id
               AND x.usr_id       = u.id
               AND y.role_id      = r.id
               AND y.authority_id = a.id
               AND %paging_criteria%    
          ORDER BY u.last_name
                 , u.first_name
                 , u.id
                 , r.id
                 , a.id       
         ';           
   BEGIN
      -- build conditions clause based on parameters the user passed     
      IF (p_first_name IS NOT NULL )
      THEN
         dbms_session.set_context('MY_CTX', 'FIRST_NAME', upper(p_first_name) || '%');
         l_conditions := l_conditions || ' and upper(u.first_name) like sys_context( ''MY_CTX'', ''FIRST_NAME'' ) ';
      END IF;

      IF (p_last_name IS NOT NULL )
      THEN
         dbms_session.set_context('MY_CTX', 'LAST_NAME', upper(p_last_name) || '%');
         l_conditions := l_conditions || ' and upper(u.last_name) like sys_context( ''MY_CTX'', ''LAST_NAME'' ) ';
      END IF;

      l_users_query := replace(l_users_query, '%conditions%', l_conditions);
      l_full_query := replace(l_full_query, '%users_query%', l_users_query);
      
      -- if page_size is 0, then no paging is used, otherwise, we calculate which user rows to retrieve
      IF p_page_size > 0
      THEN
         l_start_user_row := p_page_size * (p_page_num - 1) + 1;
         l_end_user_row := l_start_user_row + p_page_size - 1;
         l_paging_criteria := ' u.row_num BETWEEN ' || to_char(l_start_user_row) || ' and ' || to_char(l_end_user_row) || ' ';      
      END IF;
      l_full_query := replace(l_full_query, '%paging_criteria%', l_paging_criteria);
      
      --dbms_output.put_line(l_full_query);
      
      OPEN p_result_cursor FOR l_full_query;
      
   END;

   /* =================================================================================== */
   /* get_users - Gets users for given criteria. It uses paging to fetch the given subset */
   /*             of records for the given criteria.                                      */
   /*                                                                                     */
   /* Parameters:                                                                         */
   /* p_first_name - The first name to use when searching for users. The search will use  */
   /*                this parameter in a LIKE condition with a trailing percent, so if    */
   /*                you pass in 'Bob', then it will search for first names like 'Bob%'.  */
   /* p_last_name - The last name to use when searching for users. See notes on           */
   /*               p_first_name as this parameter works the same way.                    */
   /* p_page_num - The page number to retrieve.                                           */
   /* p_page_size - The page size. If page size is 10 and page number is 3, then records  */
   /*               30-40 will be returned in p_result_cursor.                            */
   /* p_result_cursor - An output ref cursor which will contain the search results.       */
   /* =================================================================================== */
   PROCEDURE get_users
   (
      p_first_name    IN  usr.first_name%type
    , p_last_name     IN  usr.last_name%type
    , p_page_num      IN  integer
    , p_page_size     IN  integer
    , p_result_cursor OUT SYS_REFCURSOR
   )
   AS
      l_start_user_row integer default 1;
      l_end_user_row integer default 2000000000;      
      l_conditions varchar2(4000) default ' ';
      
      -- Build a query to retrieve the users
      -- We use a %conditions% placeholder, which we will replace later with the search criteria
      l_users_query varchar2(4000) default
         'SELECT *
            FROM (SELECT u.*
                       , rownum row_num 
                    FROM ( SELECT u.id
                                , u.first_name
                                , u.last_name
                             FROM usr u
                            WHERE 1=1
                                  %conditions%
                         ORDER BY u.last_name
                                , u.first_name
                                , u.id
                         ) u
                   WHERE rownum <= %end_user_row% 
                 ) o                               
            WHERE row_num >= %start_user_row%                      
         ';
               
   BEGIN     
      -- build conditions clause based on parameters the user passed     
      IF (p_first_name IS NOT NULL )
      THEN
         dbms_session.set_context('MY_CTX', 'FIRST_NAME', upper(p_first_name) || '%');
         l_conditions := l_conditions || ' and upper(u.first_name) like sys_context( ''MY_CTX'', ''FIRST_NAME'' ) ';
      END IF;

      IF (p_last_name IS NOT NULL )
      THEN
         dbms_session.set_context('MY_CTX', 'LAST_NAME', upper(p_last_name) || '%');
         l_conditions := l_conditions || ' and upper(u.last_name) like sys_context( ''MY_CTX'', ''LAST_NAME'' ) ';
      END IF;

      l_users_query := replace(l_users_query, '%conditions%', l_conditions);
      
      -- if page_size is 0, then no paging is used, otherwise, we calculate which user rows to retrieve
      IF p_page_size > 0
      THEN
         l_start_user_row := p_page_size * (p_page_num - 1) + 1;
         l_end_user_row := l_start_user_row + p_page_size - 1;
      END IF;
      l_users_query := replace(l_users_query, '%start_user_row%', l_start_user_row);
      l_users_query := replace(l_users_query, '%end_user_row%', l_end_user_row);
      
      dbms_output.put_line(l_users_query);
      OPEN p_result_cursor FOR l_users_query;
      
   END;
   
   /* =================================================================================== */
   /* get_roles - Gets roles for given user id.                                           */
   /*                                                                                     */
   /* Parameters:                                                                         */
   /* p_user_id - The user id.                                                            */
   /* p_result_cursor - An output ref cursor which will contain the results.              */
   /* =================================================================================== */
   PROCEDURE get_roles
   (
      p_user_id       IN  usr.id%TYPE
    , p_result_cursor OUT SYS_REFCURSOR
   )
   AS
   BEGIN
      OPEN p_result_cursor FOR
      SELECT r.id
           , r.name
        FROM role r
           , usr_role x
       WHERE r.id      = x.role_id
         AND p_user_id = x.usr_id;
   END;
   
   /* =================================================================================== */
   /* get_authorities - Gets authorities for given role id.                               */
   /*                                                                                     */
   /* Parameters:                                                                         */
   /* p_role_id - The role id.                                                            */
   /* p_result_cursor - An output ref cursor which will contain the results.              */
   /* =================================================================================== */
   PROCEDURE get_authorities
   (
      p_role_id       IN  role.id%TYPE
    , p_result_cursor OUT SYS_REFCURSOR
   )
   AS
   BEGIN
      OPEN p_result_cursor FOR
      SELECT a.id
           , a.name
        FROM authority a
           , role_authority x
       WHERE a.id      = x.authority_id
         AND p_role_id = x.role_id;
   END;

end my_pkg;
/
