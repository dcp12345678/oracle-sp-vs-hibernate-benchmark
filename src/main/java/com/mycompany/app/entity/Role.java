package com.mycompany.app.entity;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.BatchSize;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

/**
 * This class represents a role entity.
 */
@Entity
@Table(name = "ROLE")
public class Role {

    /**
     * Default constructor, creates a new instance of this class.
     */
    public Role() {
        authorityMap = new HashMap<Long, Authority>();
    }

    /**
     * The id of the role
     */
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "id_seq")
    @SequenceGenerator(name = "id_seq", sequenceName = "id_seq")
    private Long id;

    /**
     * The name of the role
     */
    @Column(name = "name")
    private String name;

    /**
     * The authorities associated with the role
     */
    @ManyToMany
    //@Fetch(FetchMode.SELECT)
    //@BatchSize(size = 10)
    @JoinTable(
        name="ROLE_AUTHORITY",
        joinColumns=
            @JoinColumn(name="ROLE_ID", referencedColumnName="ID"),
        inverseJoinColumns=
            @JoinColumn(name="AUTHORITY_ID", referencedColumnName="ID")
    )
    private Set<Authority> authorities;

    /**
     * A transient field used to manually store the authorities for the role (e.g. not using Hibernate/JPA).
     */
    @Transient
    private Map<Long, Authority> authorityMap;

    /**
     * Gets the id for the role
     * @return the id for the role
     */
    public Long getId() {
        return id;
    }

    /**
     * Sets the id for the role
     * @param id the id for the role
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Gets the name for the role
     * @return the name for the role
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the name for the role
     * @param name the name for the role
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Gets the authorities associated with the role
     * @return the authorities associated with the role
     */
    public Set<Authority> getAuthorities() {
        return authorities;
    }

    /**
     * Sets the authorities associated with the role
     * @param authorities the authorities associated with the role
     */
    public void setAuthorities(Set<Authority> authorities) {
        this.authorities = authorities;
    }

    /**
     * Gets the authority map for the role (this map is not used by Hibernate/JPA)
     * @return the authority map for the role
     */
    public Map<Long, Authority> getAuthorityMap() {
        return authorityMap;
    }

}
