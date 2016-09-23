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

@Entity
@Table(name = "USR")
public class User {

    public User() {
        roleMap = new HashMap<Long, Role>();
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "id_seq")
    @SequenceGenerator(name = "id_seq", sequenceName = "id_seq")
    private Long id;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

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

    @Transient
    private Map<Long, Role> roleMap;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public Set<Role> getRoles() {
        return roles;
    }

    public void setRoles(Set<Role> roles) {
        this.roles = roles;
    }

    public Map<Long, Role> getRoleMap() {
        return roleMap;
    }

}