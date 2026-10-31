package com.ajt.portal.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private int studentId;
    private int userId;
    private String enrollmentNumber;
    private String branch;
    private int semester;
    private BigDecimal cgpa;
    private String phone;
    private String resumePath;

    // Joined fields from users table for easy display
    private String fullName;
    private String email;
    private String accountStatus;
    private Timestamp createdAt;

    public Student() {
    }

    public Student(int userId, String enrollmentNumber, String branch, int semester, BigDecimal cgpa, String phone) {
        this.userId = userId;
        this.enrollmentNumber = enrollmentNumber;
        this.branch = branch;
        this.semester = semester;
        this.cgpa = cgpa;
        this.phone = phone;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEnrollmentNumber() {
        return enrollmentNumber;
    }

    public void setEnrollmentNumber(String enrollmentNumber) {
        this.enrollmentNumber = enrollmentNumber;
    }

    public String getBranch() {
        return branch;
    }

    public void setBranch(String branch) {
        this.branch = branch;
    }

    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }

    public BigDecimal getCgpa() {
        return cgpa;
    }

    public void setCgpa(BigDecimal cgpa) {
        this.cgpa = cgpa;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getResumePath() {
        return resumePath;
    }

    public void setResumePath(String resumePath) {
        this.resumePath = resumePath;
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

    public boolean hasResume() {
        return resumePath != null && !resumePath.trim().isEmpty();
    }
}

