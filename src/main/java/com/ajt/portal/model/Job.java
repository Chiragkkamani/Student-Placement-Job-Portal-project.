package com.ajt.portal.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;

public class Job implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_CLOSED = "CLOSED";

    private int jobId;
    private int companyId;
    private String jobTitle;
    private String description;
    private String location;
    private BigDecimal minimumCgpa;
    private String eligibleBranch;
    private Date deadline;
    private String jobStatus;
    private Timestamp createdAt;

    // Joined / Computed fields
    private String companyName;
    private String companyIndustry;
    private String companyLocation;
    private String companyWebsite;
    private int applicantCount;
    private boolean appliedByCurrentUser;
    private String userApplicationStatus;

    public Job() {
        this.jobStatus = STATUS_ACTIVE;
        this.minimumCgpa = BigDecimal.ZERO;
        this.eligibleBranch = "All Branches";
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public BigDecimal getMinimumCgpa() {
        return minimumCgpa;
    }

    public void setMinimumCgpa(BigDecimal minimumCgpa) {
        this.minimumCgpa = minimumCgpa;
    }

    public String getEligibleBranch() {
        return eligibleBranch;
    }

    public void setEligibleBranch(String eligibleBranch) {
        this.eligibleBranch = eligibleBranch;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public String getJobStatus() {
        return jobStatus;
    }

    public void setJobStatus(String jobStatus) {
        this.jobStatus = jobStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyIndustry() {
        return companyIndustry;
    }

    public void setCompanyIndustry(String companyIndustry) {
        this.companyIndustry = companyIndustry;
    }

    public String getCompanyLocation() {
        return companyLocation;
    }

    public void setCompanyLocation(String companyLocation) {
        this.companyLocation = companyLocation;
    }

    public String getCompanyWebsite() {
        return companyWebsite;
    }

    public void setCompanyWebsite(String companyWebsite) {
        this.companyWebsite = companyWebsite;
    }

    public int getApplicantCount() {
        return applicantCount;
    }

    public void setApplicantCount(int applicantCount) {
        this.applicantCount = applicantCount;
    }

    public boolean isAppliedByCurrentUser() {
        return appliedByCurrentUser;
    }

    public void setAppliedByCurrentUser(boolean appliedByCurrentUser) {
        this.appliedByCurrentUser = appliedByCurrentUser;
    }

    public String getUserApplicationStatus() {
        return userApplicationStatus;
    }

    public void setUserApplicationStatus(String userApplicationStatus) {
        this.userApplicationStatus = userApplicationStatus;
    }

    public boolean isActive() {
        return STATUS_ACTIVE.equalsIgnoreCase(this.jobStatus);
    }

    public boolean isExpired() {
        if (deadline == null) return false;
        return deadline.toLocalDate().isBefore(LocalDate.now());
    }

    public boolean isEligible(Student student) {
        if (student == null) return false;
        if (student.getCgpa() != null && this.minimumCgpa != null) {
            if (student.getCgpa().compareTo(this.minimumCgpa) < 0) {
                return false;
            }
        }
        if (this.eligibleBranch != null && !this.eligibleBranch.equalsIgnoreCase("All Branches")) {
            if (student.getBranch() == null || !this.eligibleBranch.toLowerCase().contains(student.getBranch().toLowerCase())) {
                return false;
            }
        }
        return true;
    }
}

