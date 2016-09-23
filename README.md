##Hibernate vs Oracle Stored Procedure performance comparison

This project compares the performance when fetching data using native PL/SQL Oracle procedures against fetching that
same data using Hibernate. The tests run against 1,000,000 user records with associated roles and authorities, and they fetch a subset of users matching given search criteria to measure performance. Note that the entire user, role and authority entities are fetched, but they are fetched a page at a time to simulate real world usage, such as an end-user viewing this data on a web page and paging through a grid, for example.

This is a maven project and it uses the Oracle JDBC drivers from the maven repository.

###Prerequisites
* Oracle instance (any recent version 10g or later should be fine) - You can use [Oracle Express Edition](http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html), which runs on Windows and Linux and is free.
* Maven 3.2.5 or higher
* JDK 1.8 or higher (may work on lower versions, but tested against 1.8)

###Installation instructions
* This project uses the Maven Oracle JDBC drivers, and you will need to follow the instructions on configuring a settings.xml and settings-security.xml. These instructions are located [here](https://blogs.oracle.com/dev2dev/entry/how_to_get_oracle_jdbc#settings).
* Create a new Oracle user for the tests. You can use the following commands (change testuser to whatever you want):
    * `create user testuser identified by testuser`
    * `grant dba to testuser`
* Login to Oracle using the user you just created and then run the following scripts:
    * src/main/db/oracle/ddl.sql
    * src/main/db/oracle/my_pkg.sql
    * src/main/db/oracle/load_test_data.sql (note: this script will typically take 10-15 minutes to run)
* Modify **src/main/resources/META-INF/persistence.xml** and change the following values:
    * hibernate.connection.url - put in the proper url for your Oracle DB
    * hibernate.connection.username - username for the Oracle user you created
    * hibernate.connection.password - password for the Oracle user you created

### Running the tests
* mvn test
* There are 3 tests: two tests use stored procedures and one test uses Hibernate.
* In stored procedure approach #1, it uses the my_pkg.get_users stored procedure to get all users, roles and authorities back in one query.
* In stored procedure approach #2, it uses the my_pkg.get_users, my_pkg.get_roles and my_pkg.get_authorities stored procedures.
     * The my_pkg.get_users stored procedure gets all the users
     * the my_pkg_.get_roles is called to get the roles for each user
     * the my_pkg.get_authorities is called to get the authorities for each role.
* For the Hibernate test, note that the test loops over all the roles and authorities for each user to force Hibernate to fetch them from the DB. This is done to be consistent with the stored procedure approach.
* After you run the tests, you can see the test results listed on how long each approach took.

### Generating new test data
* If you would like to generate new test data (test data is generated randomly), the easiest way is to just drop the schema and recreate it, then re-run the load_test_data.sql script. You can also delete the data manually, but that can take a while since it will generate a lot of rollback data. Here are the scripts to run for dropping the schema, re-creating it, and loading new test data (these scripts are in src/main
    * src/main/db/oracle/drop_objects.sql
    * src/main/db/oracle/ddl.sql
    * src/main/db/oracle/load_test_data.sql
* If you want to just delete the data without dropping any schema objects, you can use the following script:
    * src/main/db/oracle/clear_test_data.sql

### Notes on test results
* The test results on my machine were as follows:
    * `Total time for hibernate:                     00:00:37.013`
    * `Total time for stored procedures approach #1: 00:00:42.500`
    * `Total time for stored procedures approach #2: 00:00:39.704`
`
* There may be optimizations that can be added to the stored procedures to make them perform faster. I used the approach Tom Kyte recommends [here](https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:31335048149752) to ensure that bind variables are always being used in the stored procedures.
*  I also re-ran the tests modifying the PAGE_SIZE constant in com.mycompany.app.AppTest.java to 200, and found that the times were almost identical.
    * `Total time for hibernate:                     00:00:11.145`
    * `Total time for stored procedures approach #1: 00:00:11.474`
    * `Total time for stored procedures approach #2: 00:00:11.225`

### Conclusions
* This project is not meant to advocate using Hibernate over stored procedures, as there are many other considerations besides performance. Where stored procedures really excel is **keeping the data logic close to the data**, and allowing that logic to be reused **over and over again** by different applications. Applications tend to change over time, be re-written using newer technologies, be developed to mobile platforms, etc, but the data is really the cornerstone of these applications. As Tom Kyte [says](https://asktom.oracle.com/pls/asktom/f%3Fp%3D100:11:0::::P11_QUESTION_ID:2232358800346144240), "application come, applications go, data lives forever".
* Another key consideration is that if you have several operations to perform in a single transaction, you can bundle those operations into a single stored procedure, which only requires a single round trip from the client. With Hibernate, you would have to make multiple round trips to the database to perform those same operations. This is one example where performance can really be optimized with stored procedures.



