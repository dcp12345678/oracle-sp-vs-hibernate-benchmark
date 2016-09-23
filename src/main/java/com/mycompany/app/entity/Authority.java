package com.mycompany.app.entity;

import java.util.HashMap;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

/**
 * This class represents an authority entity.
 */
@Entity
@Table(name = "AUTHORITY")
public class Authority {

    /**
     * Default constructor, creates a new instance of this class.
     */
    public Authority() {
    }

    /**
     * The id of the authority.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "id_seq")
    @SequenceGenerator(name = "id_seq", sequenceName = "id_seq")
    private Long id;

    /**
     * The name of the authority.
     */
    @Column(name = "name")
    private String name;

    /**
     * Gets the id for the authority
     * @return the id for the authority
     */
    public Long getId() {
        return id;
    }

    /**
     * Sets the id for the authority
     * @param id the id for the authority
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Gets the name for the authority
     * @return the name for the authority
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the name for the authority
     * @param name the name for the authority
     */
    public void setName(String name) {
        this.name = name;
    }

}
