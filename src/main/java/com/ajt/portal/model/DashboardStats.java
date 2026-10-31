package com.ajt.portal.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class DashboardStats implements Serializable {
    private static final long serialVersionUID = 1L;

    // Admin Metrics
    private int totalStudents;
    private int totalCompanies;
    private int activeJobs;
    private int totalApplications;
    private int appliedCount;
    private int shortlistedCount;
    private int rejectedCount;
    private int selectedCount;

    // Student Metrics
    private int studentTotalApplications;
    private int studentShortlistedCount;
    private int studentSelectedCount;
    private int studentRejectedCount;
    private int studentAppliedCount;
    private int eligibleJobsCount;

    public DashboardStats() {
    }

    public int getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(int totalStudents) {
        this.totalStudents = totalStudents;
    }

    public int getTotalCompanies() {
        return totalCompanies;
    }

    public void setTotalCompanies(int totalCompanies) {
        this.totalCompanies = totalCompanies;
    }

    public int getActiveJobs() {
        return activeJobs;
    }

    public void setActiveJobs(int activeJobs) {
        this.activeJobs = activeJobs;
    }

    public int getTotalApplications() {
        return totalApplications;
    }

    public void setTotalApplications(int totalApplications) {
        this.totalApplications = totalApplications;
    }

    public int getAppliedCount() {
        return appliedCount;
    }

    public void setAppliedCount(int appliedCount) {
        this.appliedCount = appliedCount;
    }

    public int getShortlistedCount() {
        return shortlistedCount;
    }

    public void setShortlistedCount(int shortlistedCount) {
        this.shortlistedCount = shortlistedCount;
    }

    public int getRejectedCount() {
        return rejectedCount;
    }

    public void setRejectedCount(int rejectedCount) {
        this.rejectedCount = rejectedCount;
    }

    public int getSelectedCount() {
        return selectedCount;
    }

    public void setSelectedCount(int selectedCount) {
        this.selectedCount = selectedCount;
    }

    public int getStudentTotalApplications() {
        return studentTotalApplications;
    }

    public void setStudentTotalApplications(int studentTotalApplications) {
        this.studentTotalApplications = studentTotalApplications;
    }

    public int getStudentShortlistedCount() {
        return studentShortlistedCount;
    }

    public void setStudentShortlistedCount(int studentShortlistedCount) {
        this.studentShortlistedCount = studentShortlistedCount;
    }

    public int getStudentSelectedCount() {
        return studentSelectedCount;
    }

    public void setStudentSelectedCount(int studentSelectedCount) {
        this.studentSelectedCount = studentSelectedCount;
    }

    public int getStudentRejectedCount() {
        return studentRejectedCount;
    }

    public void setStudentRejectedCount(int studentRejectedCount) {
        this.studentRejectedCount = studentRejectedCount;
    }

    public int getStudentAppliedCount() {
        return studentAppliedCount;
    }

    public void setStudentAppliedCount(int studentAppliedCount) {
        this.studentAppliedCount = studentAppliedCount;
    }

    public int getEligibleJobsCount() {
        return eligibleJobsCount;
    }

    public void setEligibleJobsCount(int eligibleJobsCount) {
        this.eligibleJobsCount = eligibleJobsCount;
    }

    public Map<String, Integer> getStatusMap() {
        Map<String, Integer> map = new HashMap<>();
        map.put("Applied", appliedCount);
        map.put("Shortlisted", shortlistedCount);
        map.put("Rejected", rejectedCount);
        map.put("Selected", selectedCount);
        return map;
    }
}

