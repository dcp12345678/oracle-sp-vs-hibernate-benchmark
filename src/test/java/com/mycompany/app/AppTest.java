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

public class AppTest {

    private final int PAGE_SIZE = 20;

    private EntityManagerFactory entityManagerFactory;

    private static String spApproach1Time;

    private static String spApproach2Time;

    private static String hibernateTime;

    @Before
    public void setUp() throws Exception {
        entityManagerFactory = Persistence.createEntityManagerFactory("persistenceUnit");
    }

    @After
    public void tearDown() throws Exception {
        entityManagerFactory.close();
    }

    @AfterClass
    public static void tearDownFixture() throws Exception {
        System.out.println("***********************************************************************");
        System.out.format("**** Total time for hibernate:                     %s\n", hibernateTime);
        System.out.format("**** Total time for stored procedures approach #1: %s\n", spApproach1Time);
        System.out.format("**** Total time for stored procedures approach #2: %s\n", spApproach2Time);
        System.out.println("***********************************************************************");
    }

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
                    // Prepare a PL/SQL call
                    CallableStatement stmt = connection.prepareCall("{ call my_pkg.get_users_full (?,?,?,?,?)}");
                    stmt.setString(1, "Bob");
                    stmt.setString(2, null);
                    stmt.setInt(4, PAGE_SIZE);
                    stmt.registerOutParameter(5, OracleTypes.CURSOR);

                    int pageNum = 1;
                    Map<Long, User> userMap = new HashMap<Long, User>();
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

                            Role role = user.getRoleMap().get(rs.getLong("role_id"));
                            if (role == null) {
                                role = new Role();
                                role.setId(rs.getLong("role_id"));
                                role.setName(rs.getString("role_name"));
                                user.getRoleMap().put(role.getId(), role);
                            }

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
                    // Prepare a PL/SQL call for getting users
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

                                // try to get the role from cache if we can
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

    @Test
    public void testHibernate() {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();

        EntityManager entityManager = null;
        try {

            entityManager = entityManagerFactory.createEntityManager();
            long totalRecs =
                entityManager.createQuery("select count(u) from User u where u.firstName like :fname", Long.class)
                    .setParameter("fname", "Bob%").getSingleResult();
            System.out.println("numRecs = " + totalRecs);

            TypedQuery<User> q = entityManager.createQuery(
                "select u from User u where u.firstName like :fname order by u.lastName, u.firstName, u.id",
                User.class).setParameter("fname", "Bob%");

            int totalPages = (int) Math.ceil((double) totalRecs / PAGE_SIZE);
            System.out.println("totalPages = " + totalPages);

            for (int i = 0; i < totalPages; ++i) {
                if (i % 50 == 0) {
                    System.out.println("processed page " + i);
                }
                q.setFirstResult(i * PAGE_SIZE);
                q.setMaxResults(PAGE_SIZE);
                List<User> users = q.getResultList();
                for (int j = 0; j < users.size(); ++j) {
                    for (Role role : users.get(j).getRoles()) {
                        role.getAuthorities().size(); // force hibernate to fetch all the authority recs
                    }
                }
            }

        } finally {
            if (entityManager != null) {
                entityManager.close();
            }
        }

        stopWatch.stop();
        hibernateTime = stopWatch.toString();
    }

}
