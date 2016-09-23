package com.mycompany.app;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;

import org.apache.commons.lang3.time.StopWatch;
import org.hibernate.Session;
import org.hibernate.jdbc.Work;

import com.mycompany.app.entity.Authority;
import com.mycompany.app.entity.Role;
import com.mycompany.app.entity.User;

import org.junit.*;

import oracle.jdbc.OracleTypes;

/**
 * Unit tests to test Oracle stored procedure performance vs Hibernate.
 */
public class AppTest {

    /**
     * The page size to use when fetching records.
     */
    private final int PAGE_SIZE = 20;

    /**
     * The entity manager factory used to interact with the database.
     */
    private EntityManagerFactory entityManagerFactory;

    /**
     * A string representing the time taken for stored procedure approach #1.
     */
    private static String spApproach1Time;

    /**
     * A string representing the time taken for stored procedure approach #2.
     */
    private static String spApproach2Time;

    /**
     * A string representing the time taken for the Hibernate approach.
     */
    private static String hibernateApproachTime;

    /**
     * Called before each test is run. Initializes the environment for testing.
     * @throws Exception if any error occurs
     */
    @Before
    public void setUp() throws Exception {
        entityManagerFactory = Persistence.createEntityManagerFactory("persistenceUnit");
    }

    /**
     * Called after each test is run. Cleans up the test environment.
     * @throws Exception if any error occurs
     */
    @After
    public void tearDown() throws Exception {
        entityManagerFactory.close();
    }

    /**
     * Called after all tests have run. Displays final statistics.
     * @throws Exception if any error occurs
     */
    @AfterClass
    public static void tearDownFixture() throws Exception {
        System.out.println("--------------------------T E S T  R E S U L T S--------------------------------");
        System.out.format("---- Total time for hibernate:                     %s\n", hibernateApproachTime);
        System.out.format("---- Total time for stored procedures approach #1: %s\n", spApproach1Time);
        System.out.format("---- Total time for stored procedures approach #2: %s\n", spApproach2Time);
        System.out.println("--------------------------------------------------------------------------------");
    }

    /**
     * Performs test using my_pkg.get_users_full stored procedure. This stored procedure gets the users, roles
     * and authorities all in one query. So there is only one result set to loop through and one stored procedure
     * which is called.
     */
    @Test
    public void testStoredProcedureApproach1() {
        System.out.println("starting stored procedure (approach #1) test");

        StopWatch stopWatch = new StopWatch();
        stopWatch.start();

        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Session session = entityManager.unwrap(Session.class);
        session.doWork(new Work() {

            @Override
            public void execute(Connection connection) throws SQLException {
                Statement s = null;
                try {
                    // Prepare a PL/SQL call to get users with first name starting with Bob
                    CallableStatement stmt = connection.prepareCall("{ call my_pkg.get_users_full (?,?,?,?,?)}");
                    stmt.setString(1, "Bob");
                    stmt.setString(2, null);
                    stmt.setInt(4, PAGE_SIZE);
                    stmt.registerOutParameter(5, OracleTypes.CURSOR);

                    int pageNum = 1;
                    Map<Long, User> userMap = new HashMap<Long, User>();

                    // loop over the records in the result set and add the roles and authorities for each user
                    while (true) {
                        if (pageNum % 50 == 0) {
                            System.out.format("processed page %d\n", pageNum);
                        }
                        stmt.setInt(3, pageNum);
                        stmt.execute();
                        ResultSet rs = (ResultSet) stmt.getObject(5);
                        boolean dataFound = false;
                        while (rs.next()) {
                            dataFound = true;

                            User user = userMap.get(rs.getLong("usr_id"));
                            if (user == null) {
                                user = new User();
                                user.setId(rs.getLong("usr_id"));
                                user.setFirstName(rs.getString("first_name"));
                                user.setLastName(rs.getString("last_name"));
                                userMap.put(user.getId(), user);
                            }

                            // if role isn't already in the map, then create it and add it to map
                            Role role = user.getRoleMap().get(rs.getLong("role_id"));
                            if (role == null) {
                                role = new Role();
                                role.setId(rs.getLong("role_id"));
                                role.setName(rs.getString("role_name"));
                                user.getRoleMap().put(role.getId(), role);
                            }

                            // if authority isn't already in the map, then create it and add it to map
                            Authority authority = role.getAuthorityMap().get(rs.getLong("authority_id"));
                            if (authority == null) {
                                authority = new Authority();
                                authority.setId(rs.getLong("authority_id"));
                                authority.setName(rs.getString("authority_name"));
                                role.getAuthorityMap().put(authority.getId(), authority);
                            }
                        }
                        rs.close();

                        if (!dataFound) {
                            break; // we reached the last page of records from DB, so we're done
                        }

                        ++pageNum;
                    }

                } finally {
                    if (s != null) {
                        s.close();
                    }
                }
            }

        });
        stopWatch.stop();
        spApproach1Time = stopWatch.toString();
    }

    /**
     * Performs test using my_pkg.get_users, my_pkg.get_roles and my_pkg.get_authorities stored procedures.
     * The my_pkg.get_users stored procedure gets all the users, then my_pkg_.get_roles is called to get the roles
     * for each user, and finally, my_pkg.get_authorities is called to get the authorities for each role.
     */
    @Test
    public void testStoredProcedureApproach2() {
        System.out.println("starting stored procedure (approach #2) test");

        StopWatch stopWatch = new StopWatch();
        stopWatch.start();

        EntityManager entityManager = entityManagerFactory.createEntityManager();
        Session session = entityManager.unwrap(Session.class);
        session.doWork(new Work() {

            @Override
            public void execute(Connection connection) throws SQLException {
                Statement s = null;
                try {
                    // Prepare a PL/SQL call to get users with first name starting with Bob
                    CallableStatement stmt = connection.prepareCall("{ call my_pkg.get_users (?,?,?,?,?)}");
                    stmt.setString(1, "Bob");
                    stmt.setString(2, null);
                    stmt.setInt(4, PAGE_SIZE);
                    stmt.registerOutParameter(5, OracleTypes.CURSOR);

                    // Prepare a PL/SQL call for getting roles for user
                    CallableStatement stmtRoles = connection.prepareCall("{ call my_pkg.get_roles (?,?)}");
                    stmtRoles.setLong(1, 1);
                    stmtRoles.registerOutParameter(2, OracleTypes.CURSOR);

                    // Prepare a PL/SQL call for getting authorities for role
                    CallableStatement stmtAuthorities =
                        connection.prepareCall("{ call my_pkg.get_authorities (?,?)}");
                    stmtAuthorities.setLong(1, 1);
                    stmtAuthorities.registerOutParameter(2, OracleTypes.CURSOR);

                    int pageNum = 1;
                    List<User> users = new ArrayList<User>();
                    boolean useCache = true;
                    Map<Long, Role> roleCache = new HashMap<Long, Role>();
                    while (true) {
                        if (pageNum % 50 == 0) {
                            System.out.format("processed page %d\n", pageNum);
                        }
                        stmt.setInt(3, pageNum);
                        stmt.execute();
                        ResultSet rsUsers = (ResultSet) stmt.getObject(5);
                        boolean dataFound = false;
                        while (rsUsers.next()) {
                            dataFound = true;

                            User user = new User();
                            user = new User();
                            user.setId(rsUsers.getLong("id"));
                            user.setFirstName(rsUsers.getString("first_name"));
                            user.setLastName(rsUsers.getString("last_name"));
                            users.add(user);

                            stmtRoles.setLong(1, user.getId());
                            stmtRoles.execute();
                            ResultSet rsRoles = (ResultSet) stmtRoles.getObject(2);
                            while (rsRoles.next()) {
                                if (user.getRoles() == null) {
                                    user.setRoles(new HashSet<Role>());
                                }

                                // try to get the role from cache if we can as there's no need to fetch the authorities
                                // again if we have fetched this role previously
                                if (useCache && roleCache.containsKey(rsRoles.getLong("id"))) {
                                    user.getRoles().add(roleCache.get(rsRoles.getLong("id")));
                                } else {
                                    Role role = new Role();
                                    role.setId(rsRoles.getLong("id"));
                                    role.setName(rsRoles.getString("name"));
                                    user.getRoles().add(role);

                                    stmtAuthorities.setLong(1, role.getId());
                                    stmtAuthorities.execute();
                                    ResultSet rsAuthorities = (ResultSet) stmtAuthorities.getObject(2);
                                    while (rsAuthorities.next()) {
                                        if (role.getAuthorities() == null) {
                                            role.setAuthorities(new HashSet<Authority>());
                                        }
                                        Authority authority = new Authority();
                                        authority.setId(rsAuthorities.getLong("id"));
                                        authority.setName(rsAuthorities.getString("name"));
                                        role.getAuthorities().add(authority);
                                    }
                                    rsAuthorities.close();

                                    if (useCache) {
                                        roleCache.put(role.getId(), role);
                                    }
                                }
                            }
                            rsRoles.close();

                        }
                        rsUsers.close();

                        if (!dataFound) {
                            break; // we reached the last page of records from DB, so we're done
                        }

                        ++pageNum;
                    }

                } finally {
                    if (s != null) {
                        s.close();
                    }
                }
            }

        });
        stopWatch.stop();
        spApproach2Time = stopWatch.toString();
    }

    /**
     * Performs test using Hibernate to get users along with their roles and authorities. Note that the test
     * loops over all the roles and authorities for each user to force Hibernate to fetch them from the DB.
     */
    @Test
    public void testHibernate() {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();

        EntityManager entityManager = null;
        try {

            entityManager = entityManagerFactory.createEntityManager();

            // find total number of records for users with a first name starting with Bob
            long totalRecs =
                entityManager.createQuery("select count(u) from User u where u.firstName like :fname", Long.class)
                    .setParameter("fname", "Bob%").getSingleResult();
            System.out.println("numRecs = " + totalRecs);

            // create the query to fetch the users with a first name starting with Bob
            TypedQuery<User> q = entityManager.createQuery(
                "select u from User u where u.firstName like :fname order by u.lastName, u.firstName, u.id",
                User.class).setParameter("fname", "Bob%");

            // calculate the total number of pages we need to fetch
            int totalPages = (int) Math.ceil((double) totalRecs / PAGE_SIZE);
            System.out.println("totalPages = " + totalPages);

            // fetch the users for each page
            for (int i = 0; i < totalPages; ++i) {
                if (i % 50 == 0) {
                    System.out.println("processed page " + i);
                }
                q.setFirstResult(i * PAGE_SIZE);
                q.setMaxResults(PAGE_SIZE);
                List<User> users = q.getResultList();

                // use loops to force Hibernate to fetch all roles and authorities from DB
                for (int j = 0; j < users.size(); ++j) {
                    for (Role role : users.get(j).getRoles()) {
                        role.getAuthorities().size(); // force Hiernate to fetch all the authority recs
                    }
                }
            }

        } finally {
            if (entityManager != null) {
                entityManager.close();
            }
        }

        stopWatch.stop();
        hibernateApproachTime = stopWatch.toString();
    }

}
