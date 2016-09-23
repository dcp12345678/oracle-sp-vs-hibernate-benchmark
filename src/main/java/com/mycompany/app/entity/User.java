package com.mycompany.app.entity;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinTable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.BatchSize;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

/**
 * This class represents a user entity.
 */
@Entity
@Table(name = "USR")
public class User {

    /**
     * Default constructor, creates a new instance of this class.
     */
    public User() {
        roleMap = new HashMap<Long, Role>();
    }

    /**
     * The id of the user.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "id_seq")
    @SequenceGenerator(name = "id_seq", sequenceName = "id_seq")
    private Long id;

    /**
     * The first name of the user.
     */
    @Column(name = "first_name")
    private String firstName;

    /**
     * The last name of the user.
     */
    @Column(name = "last_name")
    private String lastName;

    /**
     * The roles associated with the user.
     */
    @ManyToMany
    //@Fetch(FetchMode.SELECT)
    //@BatchSize(size = 10)
    @JoinTable(
        name="USR_ROLE",
        joinColumns=
            @JoinColumn(name="USR_ID", referencedColumnName="ID"),
        inverseJoinColumns=
            @JoinColumn(name="ROLE_ID", referencedColumnName="ID")
    )
    private Set<Role> roles;

    /**
     * A transient field used to manually store the roles for the user (e.g. not using Hibernate/JPA).
     */
    @Transient
    private Map<Long, Role> roleMap;

    /**
     * Gets the id for the user
     * @return the user id
     */
    public Long getId() {
        return id;
    }

    /**
     * Sets the id for the user
     * @param id the user id
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Gets the first name for the user
     * @return first name for the user
     */
    public String getFirstName() {
        return firstName;
    }

    /**
     * Sets the first name for the user
     * @param firstName first name for the user
     */
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    /**
     * Gets the last name for the user
     * @return last name for the user
     */
    public String getLastName() {
        return lastName;
    }

    /**
     * Sets the last name for the user
     * @param lastName last name for the user
     */
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    /**
     * Gets the roles associated with the user
     * @return the roles for the user
     */
    public Set<Role> getRoles() {
        return roles;
    }

    /**
     * Sets the roles associated with the user
     * @param roles the roles for the user
     */
    public void setRoles(Set<Role> roles) {
        this.roles = roles;
    }

    /**
     * Gets the role map for the user (this map is not used by Hibernate/JPA)
     * @return the role map for the user
     */
    public Map<Long, Role> getRoleMap() {
        return roleMap;
    }

}