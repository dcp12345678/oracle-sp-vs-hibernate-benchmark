##Hibernate vs Oracle Stored Procedure performance comparison

This project compares the performance when fetching data using native PL/SQL Oracle procedures against fetching that
same data using Hibernate.

This is a maven project and it uses the Oracle JDBC drivers from the maven repository.

###Prerequisites
* Oracle instance (any recent version 10g or later should be fine) - You can use [Oracle Express Edition](http://www.oracle.com/technetwork/database/database-technologies/express-edition/overview/index.html), which runs on Windows and Linux and is free.
* Maven 3.2.5 or higher

###Installation instructions
* Maven uses the Oracle JDBC drivers, and you will need to follow the instructions on settign up a settings.xml and settings-security.xml. These instructions are located [here](https://blogs.oracle.com/dev2dev/entry/how_to_get_oracle_jdbc#settings).
* Create a new Oracle user for the tests. You can use the following commands (change testuser to whatever you want):
    * `create user testuser identified by testuser`
    * `grant dba to testuser`
* Login to Oracle using the user you just created and then run the following scripts (these scripts are in src/main/db/oracle)
    * ddl.sql
    * my_pkg.sql
    * load_test_data.sql (note: this script will typically 10-15 minutes to run)
* Modify src/main/resources/META-INF/persistence.xml and change the following values:
    * hibernate.connection.url - put in the proper url for your Oracle DB
    * hibernate.connection.username - username for the Oracle user you created
    * hibernate.connection.password - password for the Oracle user you created
* mvn install