package com.ajt.portal.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Company implements Serializable {
    private static final long serialVersionUID = 1L;

    private int companyId;
    private String companyName;
    private String industry;
    private String location;
    private String website;
    private String contactEmail;
    private Timestamp createdAt;

    // Computed / Joined fields
    private int jobCount;

    public Company() {
    }

    public Company(String companyName, String industry, String location, String website, String contactEmail) {
        this.companyName = companyName;
        this.industry = industry;
        this.location = location;
        this.website = website;
        this.contactEmail = contactEmail;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getIndustry() {
        return industry;
    }

    public void setIndustry(String industry) {
        this.industry = industry;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getJobCount() {
        return jobCount;
    }

    public void setJobCount(int jobCount) {
        this.jobCount = jobCount;
    }
}

