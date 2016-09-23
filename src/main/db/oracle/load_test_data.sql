DECLARE
   TYPE t_names_tbl IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
   TYPE t_int_tbl IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
   i integer;
   j integer;
   k integer;
   l_first_names t_names_tbl;
   l_last_names t_names_tbl;
   l_role_names t_names_tbl;
   l_authority_names t_names_tbl;
   l_first_names_ubound integer;
   l_last_names_ubound integer;
   l_role_names_ubound integer;
   l_authority_names_ubound integer;
   l_num integer;
   l_ndx integer; 
   l_used t_int_tbl;
BEGIN
   l_first_names(0) := 'Joe';
   l_first_names(1) := 'Mary';
   l_first_names(2) := 'Sally';
   l_first_names(3) := 'Tom';
   l_first_names(4) := 'Hannah';
   l_first_names(5) := 'Rachel';
   l_first_names(6) := 'Clay';
   l_first_names(7) := 'Laura';
   l_first_names(8) := 'Melissa';
   l_first_names(9) := 'John';
   l_first_names(10) := 'Shannon';
   l_first_names(11) := 'Paula';
   l_first_names(12) := 'Lisa';
   l_first_names(13) := 'Jennifer';
   l_first_names(14) := 'Bobby';
   l_first_names(15) := 'Deb';
   l_first_names(16) := 'Jason';
   l_first_names(17) := 'Margaret';
   l_first_names(18) := 'Kim';
   l_first_names(19) := 'Jim';
   l_first_names(20) := 'Katrina';   
   l_first_names(21) := 'Dawn';
   l_first_names(22) := 'Carolyn';
   l_first_names(23) := 'Boyd';
   l_first_names(24) := 'Lee';
   l_first_names(25) := 'Amy';
   l_first_names(26) := 'Lola';
   l_first_names(27) := 'Aubrey';
   l_first_names(28) := 'Annmarie';
   l_first_names(29) := 'Neil';
   l_first_names(30) := 'Jeanne';
   l_first_names(31) := 'Irving';
   l_first_names(32) := 'Kimberly';
   l_first_names(33) := 'Warrick';
   l_first_names(34) := 'Marcia';
   l_first_names(35) := 'Trevor';
   l_first_names(36) := 'James';
   l_first_names(37) := 'Larry';
   l_first_names(38) := 'Molly';
   l_first_names(39) := 'Courtney';
   l_first_names(40) := 'Geneva';
   l_first_names(41) := 'Natasha';
   l_first_names(42) := 'Traci';
   l_first_names(43) := 'Alexander';
   l_first_names(44) := 'Bradford';
   l_first_names(45) := 'Luther';
   l_first_names(46) := 'Leona';
   l_first_names(47) := 'Spencer';
   l_first_names(48) := 'Horace';
   l_first_names(49) := 'Della';
   l_first_names(50) := 'Perry';
   l_first_names(51) := 'Lucas';
   l_first_names(52) := 'Rolando';
   l_first_names(53) := 'Clint';
   l_first_names(54) := 'Ricardo';
   l_first_names(55) := 'Erica';
   l_first_names(56) := 'Roger';
   l_first_names(57) := 'Lloyd';
   l_first_names(58) := 'Santiago';
   l_first_names(59) := 'Curtis';
   l_first_names(60) := 'Rufus';
   l_first_names(61) := 'Cassandra';
   l_first_names(62) := 'Lynette';
   l_first_names(63) := 'Mattie';
   l_first_names(64) := 'Cedric';
   l_first_names(65) := 'Elijah';
   l_first_names(66) := 'Julia';
   l_first_names(67) := 'Denise';
   l_first_names(68) := 'Sergio';
   l_first_names(69) := 'Jo Jo';
   l_first_names(70) := 'Jackie';
   l_first_names(71) := 'Arnold';
   l_first_names(72) := 'Barry';
   l_first_names(73) := 'Laurie';
   l_first_names(74) := 'Johnnie';
   l_first_names(75) := 'Jeremiah';
   l_first_names(76) := 'Cornelius';
   l_first_names(77) := 'Kerry';
   l_first_names(78) := 'Dolores';
   l_first_names(79) := 'Archie';
   l_first_names(80) := 'Harriet';
   l_first_names(81) := 'Brad';
   l_first_names(82) := 'Zachary';
   l_first_names(83) := 'Pedro';
   l_first_names(84) := 'Maria';
   l_first_names(85) := 'Marion';
   l_first_names(86) := 'Sandy';
   l_first_names(87) := 'Leon';
   l_first_names(88) := 'Blake';
   l_first_names(89) := 'Louise';
   l_first_names(90) := 'Tiffany';
   l_first_names(91) := 'Guadalupe';
   l_first_names(92) := 'Wilbert';
   l_first_names(93) := 'Jean';
   l_first_names(94) := 'Roosevelt';
   l_first_names(95) := 'Wilma';
   l_first_names(96) := 'Ramiro';
   l_first_names(97) := 'Elena';
   l_first_names(98) := 'Stephen';
   l_first_names(99) := 'Karl';
   l_first_names(100) := 'Marlene';
   l_first_names(101) := 'Darren';
   l_first_names(102) := 'Krystal';
   l_first_names(103) := 'Stewart';
   l_first_names(104) := 'Otis';
   l_first_names(105) := 'Walter';
   l_first_names(106) := 'Daisy';
   l_first_names(107) := 'Oliver';
   l_first_names(108) := 'Chester';
   l_first_names(109) := 'Alicia';
   l_first_names(110) := 'Colin';
   l_first_names(111) := 'Seth';
   l_first_names(112) := 'Erma';
   l_first_names(113) := 'Herbert';
   l_first_names(114) := 'Oscar';
   l_first_names(115) := 'Lila';
   l_first_names(116) := 'Gerardo';
   l_first_names(117) := 'Ken';
   l_first_names(118) := 'Darnell';
   l_first_names(119) := 'Jimmie';
   l_first_names(120) := 'Grace';
   l_first_names(121) := 'Kecia';
   l_first_names(122) := 'Shawanda';
   l_first_names(123) := 'Somer';
   l_first_names(124) := 'Darrel';
   l_first_names(125) := 'Jody';
   l_first_names(126) := 'Bobbie';
   l_first_names(127) := 'Madelyn';
   l_first_names(128) := 'Carson';
   l_first_names(129) := 'Alan';
   l_first_names(130) := 'Debi';
   l_first_names(131) := 'Lashon';
   l_first_names(132) := 'Staci';
   l_first_names(133) := 'Karine';
   l_first_names(134) := 'Marybelle';
   l_first_names(135) := 'Sha';
   l_first_names(136) := 'Phung';
   l_first_names(137) := 'Mitzie';
   l_first_names(138) := 'Estell';
   l_first_names(139) := 'Cassidy';
   l_first_names(140) := 'Napoleon';
   l_first_names(141) := 'Bob';
   
   l_last_names(0) := 'Smith';
   l_last_names(1) := 'Jones';
   l_last_names(2) := 'Lucas';
   l_last_names(3) := 'Macky';
   l_last_names(4) := 'Burns';
   l_last_names(5) := 'Bradford';
   l_last_names(6) := 'Daywalt';
   l_last_names(7) := 'Staley';
   l_last_names(8) := 'Harris';
   l_last_names(9) := 'Brinkley';
   l_last_names(10) := 'Mendenhall';
   l_last_names(11) := 'Davis';
   l_last_names(12) := 'Spalding';
   l_last_names(13) := 'Lily';
   l_last_names(14) := 'Black';
   l_last_names(15) := 'Melville';
   l_last_names(16) := 'Burwell';
   l_last_names(17) := 'Mcguire';
   l_last_names(18) := 'Schneider';
   l_last_names(19) := 'Johnson';
   l_last_names(20) := 'Reyes';
   l_last_names(21) := 'Robertson';
   l_last_names(22) := 'Rogers';
   l_last_names(23) := 'Higgins';
   l_last_names(24) := 'Erickson';
   l_last_names(25) := 'Fitzgerald';
   l_last_names(26) := 'Olson';
   l_last_names(27) := 'Allen';
   l_last_names(28) := 'Buchanan';
   l_last_names(29) := 'Crawford';
   l_last_names(30) := 'Arnold';
   l_last_names(31) := 'Kelley';
   l_last_names(32) := 'Barber';
   l_last_names(33) := 'Goodman';
   l_last_names(34) := 'Marsh';
   l_last_names(35) := 'Cain';
   l_last_names(36) := 'Carr';
   l_last_names(37) := 'Myers';
   l_last_names(38) := 'Waters';
   l_last_names(39) := 'Graham';
   l_last_names(40) := 'Barnett';
   l_last_names(41) := 'Salazar';
   l_last_names(42) := 'Townsend';
   l_last_names(43) := 'Moody';
   l_last_names(44) := 'Peterson';
   l_last_names(45) := 'Paul';
   l_last_names(46) := 'Mendoza';
   l_last_names(47) := 'Santiago';
   l_last_names(48) := 'Wheeler';
   l_last_names(49) := 'Wells';
   l_last_names(50) := 'Singleton';
   l_last_names(51) := 'Hodges';
   l_last_names(52) := 'Edwards';
   l_last_names(53) := 'Mcdaniel';
   l_last_names(54) := 'Greer';
   l_last_names(55) := 'Valdez';
   l_last_names(56) := 'Hogan';
   l_last_names(57) := 'Fletcher';
   l_last_names(58) := 'Bell';
   l_last_names(59) := 'Brady';
   l_last_names(60) := 'Phelps';
   l_last_names(61) := 'Lynch';
   l_last_names(62) := 'Rice';
   l_last_names(63) := 'Foster';
   l_last_names(64) := 'Pierce';
   l_last_names(65) := 'Cohen';
   l_last_names(66) := 'Roy';
   l_last_names(67) := 'Castro';
   l_last_names(68) := 'Walsh';
   l_last_names(69) := 'Ruiz';
   l_last_names(70) := 'Munoz';
   l_last_names(71) := 'Newman';
   l_last_names(72) := 'Garcia';
   l_last_names(73) := 'Cox';
   l_last_names(74) := 'Wise';
   l_last_names(75) := 'Guerrero';
   l_last_names(76) := 'Harvey';
   l_last_names(77) := 'Anderson';
   l_last_names(78) := 'Martin';
   l_last_names(79) := 'Rodriquez';
   l_last_names(80) := 'Rose';
   l_last_names(81) := 'May';
   l_last_names(82) := 'James';
   l_last_names(83) := 'Cunningham';
   l_last_names(84) := 'Garza';
   l_last_names(85) := 'Evans';
   l_last_names(86) := 'Houston';
   l_last_names(87) := 'Roberson';
   l_last_names(88) := 'Rodriguez';
   l_last_names(89) := 'Brooks';
   l_last_names(90) := 'Carlson';
   l_last_names(91) := 'Chavez';
   l_last_names(92) := 'Roberts';
   l_last_names(93) := 'Norris';
   l_last_names(94) := 'Reese';
   l_last_names(95) := 'Mills';
   l_last_names(96) := 'Poole';
   l_last_names(97) := 'Mcbride';
   l_last_names(98) := 'Carter';
   l_last_names(99) := 'Lewis';
   l_last_names(100) := 'Stanley';
   l_last_names(101) := 'Hansen';
   l_last_names(102) := 'Underwood';
   l_last_names(103) := 'George';
   l_last_names(104) := 'Maxwell';
   l_last_names(105) := 'Bowman';
   l_last_names(106) := 'Ortiz';
   l_last_names(107) := 'Young';
   l_last_names(108) := 'Nelson';
   l_last_names(109) := 'Marshall';
   l_last_names(110) := 'Murray';
   l_last_names(111) := 'Pope';
   l_last_names(112) := 'Clark';
   l_last_names(113) := 'Lopez';
   l_last_names(114) := 'Harmon';
   l_last_names(115) := 'Watkins';
   l_last_names(116) := 'Massey';
   l_last_names(117) := 'Nella';
   l_last_names(118) := 'Hamp';
   l_last_names(119) := 'Searle';
   l_last_names(120) := 'Osgood';
   l_last_names(121) := 'Delhomme';
   l_last_names(122) := 'Newton';
   l_last_names(123) := 'Newby';
   l_last_names(124) := 'Yoshimura';
   l_last_names(125) := 'Badgett';
   l_last_names(126) := 'Swann';
   l_last_names(127) := 'Dupont';
   l_last_names(128) := 'Ralph';
   l_last_names(129) := 'Cornish';
   l_last_names(130) := 'Gallant';
   l_last_names(131) := 'Cornell';
   l_last_names(132) := 'Orlando';
   l_last_names(133) := 'Dorsey';
   l_last_names(134) := 'Ridgeway';
   l_last_names(135) := 'Blevins';
   l_last_names(136) := 'Whitehurst';
   l_last_names(137) := 'Schulze';
   l_last_names(138) := 'Isom';
   l_last_names(139) := 'Mahon';
   l_last_names(140) := 'Kramer';
   
   l_role_names(0) := 'Role 0';
   l_role_names(1) := 'Role 1';
   l_role_names(2) := 'Role 2';
   l_role_names(3) := 'Role 3';
   l_role_names(4) := 'Role 4';
   l_role_names(5) := 'Role 5';
   l_role_names(6) := 'Role 6';
   l_role_names(7) := 'Role 7';
   l_role_names(8) := 'Role 8';
      
   l_authority_names(0) := 'Authority 0';
   l_authority_names(1) := 'Authority 1';
   l_authority_names(2) := 'Authority 2';
   l_authority_names(3) := 'Authority 3';
   l_authority_names(4) := 'Authority 4';
   l_authority_names(5) := 'Authority 5';
   l_authority_names(6) := 'Authority 6';
   l_authority_names(7) := 'Authority 7';
   l_authority_names(8) := 'Authority 8';
   l_authority_names(9) := 'Authority 9';
   l_authority_names(10) := 'Authority 10';
   l_authority_names(11) := 'Authority 11';
   l_authority_names(12) := 'Authority 12';
   l_authority_names(13) := 'Authority 13';
   l_authority_names(14) := 'Authority 14';
   l_authority_names(15) := 'Authority 15';
   l_authority_names(16) := 'Authority 16';
   l_authority_names(17) := 'Authority 17';
   l_authority_names(18) := 'Authority 18';
   l_authority_names(19) := 'Authority 19';
   l_authority_names(20) := 'Authority 20';
   
   l_first_names_ubound := l_first_names.count - 1;
   l_last_names_ubound := l_last_names.count - 1;
   l_role_names_ubound := l_role_names.count - 1;
   l_authority_names_ubound := l_authority_names.count - 1;
   
   -- create roles   
   dbms_output.put_line('creating roles...');
   FOR i in 0..l_role_names_ubound
   LOOP
      INSERT INTO role ( id
                       , name )
                  SELECT id_seq.nextval
                       , l_role_names(i)
                    FROM dual;     
   END LOOP;
   dbms_output.put_line('done creating roles');

   -- create authorities
   dbms_output.put_line('creating authorities...');
   FOR i in 0..l_authority_names_ubound
   LOOP
      INSERT INTO authority ( id
                            , name )
                       SELECT id_seq.nextval
                            , l_authority_names(i)
                         FROM dual;     
   END LOOP;
   dbms_output.put_line('done creating authorities');
   
   -- assign a random number of authorities to each role
   dbms_output.put_line('assigning authorities...');
   FOR i in 0..l_role_names_ubound
   LOOP
      l_num := dbms_random.value(low => 1, high => l_authority_names.count);
      -- limit each role to a max of 4 authorities
      if (l_num > 4)
      THEN
        l_num := 4;
      END IF;
      l_used.delete();
      WHILE l_num > 0
      LOOP
         -- try to find an index we haven't used yet
         l_ndx := dbms_random.value(low => 0, high => l_authority_names_ubound);
         IF l_used.exists(l_ndx)
         THEN
            -- we already used this one, so continue and try again
            CONTINUE;
         END IF;
         l_used(l_ndx) := 1;
         INSERT INTO role_authority ( role_id
                                    , authority_id )
                               SELECT r.id
                                    , a.id
                                 FROM role r
                                    , authority a
                                WHERE r.name = l_role_names(i)
                                  AND a.name = l_authority_names(l_ndx);
         l_num := l_num -1;
      END LOOP;
   END LOOP;
   dbms_output.put_line('done assigning authorities');
   
   -- create users
   dbms_output.put_line('creating users...');
   FOR i in 1..1000000
   LOOP
      j := dbms_random.value(low => 0, high => l_first_names_ubound);
      k := dbms_random.value(low => 0, high => l_last_names_ubound);     
      INSERT INTO usr ( id
                      , first_name
                      , last_name )
                 SELECT id_seq.nextval
                      , l_first_names(j)
                      , l_last_names(k)
                   FROM dual;                      
   END LOOP;
   dbms_output.put_line('done creating users');
   
   
   -- assign a random number of roles to each user
   dbms_output.put_line('assigning roles...');
   FOR rec in (SELECT id FROM usr)
   LOOP
      l_num := dbms_random.value(low => 1, high => l_role_names.count);
      -- limit each user to a max of 3 roles
      if (l_num > 3)
      THEN
        l_num := 3;
      END IF;
      l_used.delete();
      WHILE l_num > 0
      LOOP
         -- try to find an index we haven't used yet
         l_ndx := dbms_random.value(low => 0, high => l_role_names_ubound);
         IF l_used.exists(l_ndx)
         THEN
            -- we already used this one, so continue and try again
            CONTINUE;
         END IF;
         l_used(l_ndx) := 1;
         INSERT INTO usr_role ( usr_id
                              , role_id )
                         SELECT rec.id
                              , r.id
                           FROM role r
                          WHERE r.name = l_role_names(l_ndx);
         l_num := l_num -1;
      END LOOP;      
   END LOOP;   
   dbms_output.put_line('done assigning roles');
   
END;
/
commit;
