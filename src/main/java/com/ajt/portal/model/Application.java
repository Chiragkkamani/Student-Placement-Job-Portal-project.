package com.ajt.portal.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Application implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String STATUS_APPLIED = "APPLIED";
    public static final String STATUS_SHORTLISTED = "SHORTLISTED";
    public static final String STATUS_REJECTED = "REJECTED";
    public static final String STATUS_SELECTED = "SELECTED";

    private int applicationId;
    private int jobId;
    private int studentId;
    private Timestamp applicationDate;
    private String applicationStatus;
    private String remarks;

    // Joined Job Information
    private String jobTitle;
    private String companyName;
    private String jobLocation;
    private BigDecimal jobMinCgpa;
    private String jobBranch;
    private String jobStatus;

    // Joined Student Information
    private String studentName;
    private String studentEmail;
    private String enrollmentNumber;
    private String studentBranch;
    private int studentSemester;
    private BigDecimal studentCgpa;
    private String studentPhone;
    private String studentResumePath;

    public Application() {
        this.applicationStatus = STATUS_APPLIED;
        this.remarks = "Application submitted";
    }

    public Application(int jobId, int studentId, String remarks) {
        this.jobId = jobId;
        this.studentId = studentId;
        this.applicationStatus = STATUS_APPLIED;
        this.remarks = remarks;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public Timestamp getApplicationDate() {
        return applicationDate;
    }

    public void setApplicationDate(Timestamp applicationDate) {
        this.applicationDate = applicationDate;
    }

    public String getApplicationStatus() {
        return applicationStatus;
    }

    public void setApplicationStatus(String applicationStatus) {
        this.applicationStatus = applicationStatus;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getJobLocation() {
        return jobLocation;
    }

    public void setJobLocation(String jobLocation) {
        this.jobLocation = jobLocation;
    }

    public BigDecimal getJobMinCgpa() {
        return jobMinCgpa;
    }

    public void setJobMinCgpa(BigDecimal jobMinCgpa) {
        this.jobMinCgpa = jobMinCgpa;
    }

    public String getJobBranch() {
        return jobBranch;
    }

    public void setJobBranch(String jobBranch) {
        this.jobBranch = jobBranch;
    }

    public String getJobStatus() {
        return jobStatus;
    }

    public void setJobStatus(String jobStatus) {
        this.jobStatus = jobStatus;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getStudentEmail() {
        return studentEmail;
    }

    public void setStudentEmail(String studentEmail) {
        this.studentEmail = studentEmail;
    }

    public String getEnrollmentNumber() {
        return enrollmentNumber;
    }

    public void setEnrollmentNumber(String enrollmentNumber) {
        this.enrollmentNumber = enrollmentNumber;
    }

    public String getStudentBranch() {
        return studentBranch;
    }

    public void setStudentBranch(String studentBranch) {
        this.studentBranch = studentBranch;
    }

    public int getStudentSemester() {
        return studentSemester;
    }

    public void setStudentSemester(int studentSemester) {
        this.studentSemester = studentSemester;
    }

    public BigDecimal getStudentCgpa() {
        return studentCgpa;
    }

    public void setStudentCgpa(BigDecimal studentCgpa) {
        this.studentCgpa = studentCgpa;
    }

    public String getStudentPhone() {
        return studentPhone;
    }

    public void setStudentPhone(String studentPhone) {
        this.studentPhone = studentPhone;
    }

    public String getStudentResumePath() {
        return studentResumePath;
    }

    public void setStudentResumePath(String studentResumePath) {
        this.studentResumePath = studentResumePath;
    }

    public String getStatusBadgeClass() {
        if (applicationStatus == null) return "bg-secondary";
        return switch (applicationStatus.toUpperCase()) {
            case STATUS_SHORTLISTED -> "bg-primary";
            case STATUS_SELECTED -> "bg-success";
            case STATUS_REJECTED -> "bg-danger";
            default -> "bg-warning text-dark";
        };
    }
}

