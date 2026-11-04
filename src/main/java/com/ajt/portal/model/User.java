package com.ajt.portal.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_STUDENT = "STUDENT";
    public static final String ROLE_COMPANY_HR = "COMPANY_HR";

    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_INACTIVE = "INACTIVE";

    private int userId;
    private Integer companyId;
    private String companyName;
    private String fullName;
    private String email;
    private String passwordHash;
    private String role;
    private String accountStatus;
    private Timestamp createdAt;

    public User() {
        this.role = ROLE_STUDENT;
        this.accountStatus = STATUS_ACTIVE;
    }

    public User(String fullName, String email, String passwordHash, String role) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role;
        this.accountStatus = STATUS_ACTIVE;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getAccountStatus() {
        return accountStatus;
    }

    public void setAccountStatus(String accountStatus) {
        this.accountStatus = accountStatus;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getCompanyId() {
        return companyId;
    }

    public void setCompanyId(Integer companyId) {
        this.companyId = companyId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public boolean isAdmin() {
        return ROLE_ADMIN.equalsIgnoreCase(this.role);
    }

    public boolean isStudent() {
        return ROLE_STUDENT.equalsIgnoreCase(this.role);
    }

    public boolean isCompanyHr() {
        return ROLE_COMPANY_HR.equalsIgnoreCase(this.role);
    }

    public boolean isActive() {
        return STATUS_ACTIVE.equalsIgnoreCase(this.accountStatus);
    }
}

