package com.ajt.portal.service;

import com.ajt.portal.dao.JobDAO;
import com.ajt.portal.model.Job;
import com.ajt.portal.model.Student;
import com.ajt.portal.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class JobService {

    private static final Logger logger = LoggerFactory.getLogger(JobService.class);

    private final JobDAO jobDAO;

    public JobService() {
        this.jobDAO = new JobDAO();
    }

    public JobService(JobDAO jobDAO) {
        this.jobDAO = jobDAO;
    }

    public Job getJobById(int jobId) {
        try {
            return jobDAO.findById(jobId);
        } catch (SQLException e) {
            logger.error("Error retrieving job by id {}: {}", jobId, e.getMessage());
            throw new RuntimeException("Could not retrieve job opening.", e);
        }
    }

    public Job getJobByIdForStudent(int jobId, int studentId) {
        try {
            return jobDAO.findByIdWithStudentStatus(jobId, studentId);
        } catch (SQLException e) {
            logger.error("Error retrieving job by id {} for student {}: {}", jobId, studentId, e.getMessage());
            throw new RuntimeException("Could not retrieve job opening details.", e);
        }
    }

    public int createJob(Job job) throws IllegalArgumentException {
        validateJob(job);
        try {
            return jobDAO.create(job);
        } catch (SQLException e) {
            logger.error("Error creating job opening: {}", e.getMessage());
            throw new RuntimeException("Could not create job opening.", e);
        }
    }

    public boolean updateJob(Job job) throws IllegalArgumentException {
        validateJob(job);
        try {
            return jobDAO.update(job);
        } catch (SQLException e) {
            logger.error("Error updating job opening: {}", e.getMessage());
            throw new RuntimeException("Could not update job opening.", e);
        }
    }

    public boolean updateJobStatus(int jobId, String status) {
        try {
            return jobDAO.updateStatus(jobId, status);
        } catch (SQLException e) {
            logger.error("Error updating job status for {}: {}", jobId, e.getMessage());
            throw new RuntimeException("Could not update job status.", e);
        }
    }

    public boolean deleteJob(int jobId) {
        try {
            return jobDAO.delete(jobId);
        } catch (SQLException e) {
            logger.error("Error deleting job opening {}: {}", jobId, e.getMessage());
            throw new RuntimeException("Could not delete job opening.", e);
        }
    }

    public List<Job> searchJobs(String search, String location, String branch, BigDecimal minCgpa, String status, String sortBy) {
        try {
            return jobDAO.getAllJobs(search, location, branch, minCgpa, status, sortBy);
        } catch (SQLException e) {
            logger.error("Error searching jobs: {}", e.getMessage());
            throw new RuntimeException("Could not search job listings.", e);
        }
    }

    public List<Job> getFeaturedJobs(int limit) {
        try {
            return jobDAO.getFeaturedJobs(limit);
        } catch (SQLException e) {
            logger.error("Error fetching featured jobs: {}", e.getMessage());
            throw new RuntimeException("Could not fetch featured jobs.", e);
        }
    }

    public List<Job> getRecommendedJobsForStudent(Student student, int limit) {
        try {
            return jobDAO.getEligibleJobs(student, limit);
        } catch (SQLException e) {
            logger.error("Error fetching recommended jobs: {}", e.getMessage());
            throw new RuntimeException("Could not fetch recommended jobs.", e);
        }
    }

    public int getActiveJobsCount() {
        try {
            return jobDAO.getActiveJobsCount();
        } catch (SQLException e) {
            return 0;
        }
    }

    public List<Job> getJobsByCompany(int companyId) {
        try {
            return jobDAO.getJobsByCompany(companyId);
        } catch (SQLException e) {
            logger.error("Error fetching jobs by company {}: {}", companyId, e.getMessage());
            throw new RuntimeException("Could not fetch jobs for company.", e);
        }
    }

    private void validateJob(Job job) throws IllegalArgumentException {
        if (job.getCompanyId() <= 0) {
            throw new IllegalArgumentException("Company must be selected.");
        }
        if (!ValidationUtil.isNotEmpty(job.getJobTitle())) {
            throw new IllegalArgumentException("Job title is required.");
        }
        if (!ValidationUtil.isNotEmpty(job.getDescription())) {
            throw new IllegalArgumentException("Job description is required.");
        }
        if (!ValidationUtil.isNotEmpty(job.getLocation())) {
            throw new IllegalArgumentException("Job location is required.");
        }
        if (job.getMinimumCgpa() != null && !ValidationUtil.isValidCgpa(job.getMinimumCgpa())) {
            throw new IllegalArgumentException("Minimum CGPA must be between 0.00 and 10.00.");
        }
        if (job.getDeadline() == null) {
            throw new IllegalArgumentException("Application deadline is required.");
        }
    }
}

