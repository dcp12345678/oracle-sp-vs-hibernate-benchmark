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

@Entity
@Table(name = "ROLE")
public class Role {

    public Role() {
        authorityMap = new HashMap<Long, Authority>();
    }

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "id_seq")
    @SequenceGenerator(name = "id_seq", sequenceName = "id_seq")
    private Long id;

    @Column(name = "name")
    private String name;

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

    @Transient
    private Map<Long, Authority> authorityMap;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public Set<Authority> getAuthorities() {
        return authorities;
    }

    public void setAuthorities(Set<Authority> authorities) {
        this.authorities = authorities;
    }

    public Map<Long, Authority> getAuthorityMap() {
        return authorityMap;
    }

}
