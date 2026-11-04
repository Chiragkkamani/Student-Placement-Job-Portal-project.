package com.ajt.portal.service;

import com.ajt.portal.config.DatabaseConfig;
import com.ajt.portal.dao.ApplicationDAO;
import com.ajt.portal.dao.ApplicationStatusHistoryDAO;
import com.ajt.portal.dao.JobDAO;
import com.ajt.portal.dao.StudentDAO;
import com.ajt.portal.model.Application;
import com.ajt.portal.model.ApplicationStatusHistory;
import com.ajt.portal.model.Job;
import com.ajt.portal.model.Student;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

public class ApplicationService {

    private static final Logger logger = LoggerFactory.getLogger(ApplicationService.class);

    private static final List<String> VALID_STATUSES = Arrays.asList(
        Application.STATUS_APPLIED,
        Application.STATUS_SHORTLISTED,
        Application.STATUS_REJECTED,
        Application.STATUS_SELECTED
    );

    private final ApplicationDAO applicationDAO;
    private final ApplicationStatusHistoryDAO historyDAO;
    private final JobDAO jobDAO;
    private final StudentDAO studentDAO;

    public ApplicationService() {
        this.applicationDAO = new ApplicationDAO();
        this.historyDAO = new ApplicationStatusHistoryDAO();
        this.jobDAO = new JobDAO();
        this.studentDAO = new StudentDAO();
    }

    public ApplicationService(ApplicationDAO applicationDAO, ApplicationStatusHistoryDAO historyDAO,
                              JobDAO jobDAO, StudentDAO studentDAO) {
        this.applicationDAO = applicationDAO;
        this.historyDAO = historyDAO;
        this.jobDAO = jobDAO;
        this.studentDAO = studentDAO;
    }

    /**
     * Applies for a job on behalf of a student.
     * Enforces eligibility: CGPA, branch, active status, expiration, and non-duplication.
     */
    public Application applyForJob(int studentId, int jobId, String remarks) throws IllegalArgumentException, IllegalStateException {
        try {
            Student student = studentDAO.findById(studentId);
            if (student == null) {
                throw new IllegalArgumentException("Student profile not found.");
            }

            Job job = jobDAO.findById(jobId);
            if (job == null) {
                throw new IllegalArgumentException("Job opening not found.");
            }

            // 1. Check if job is active
            if (!job.isActive()) {
                throw new IllegalStateException("This job opening is closed and no longer accepting applications.");
            }

            // 2. Check if job deadline is expired
            if (job.isExpired()) {
                throw new IllegalStateException("The application deadline for this job has expired.");
            }

            // 3. Check duplicate application
            Application existing = applicationDAO.findByStudentAndJob(studentId, jobId);
            if (existing != null) {
                throw new IllegalStateException("You have already applied for this position on " + existing.getApplicationDate() + ".");
            }

            // 4. Check CGPA eligibility
            if (job.getMinimumCgpa() != null && student.getCgpa() != null) {
                if (student.getCgpa().compareTo(job.getMinimumCgpa()) < 0) {
                    throw new IllegalStateException(String.format(
                        "Your CGPA (%s) does not meet the minimum requirement (%s) for this position.",
                        student.getCgpa(), job.getMinimumCgpa()
                    ));
                }
            }

            // 5. Check Branch eligibility
            if (job.getEligibleBranch() != null && !job.getEligibleBranch().equalsIgnoreCase("All Branches")) {
                if (student.getBranch() == null || !job.getEligibleBranch().toLowerCase().contains(student.getBranch().toLowerCase())) {
                    throw new IllegalStateException(String.format(
                        "Your branch (%s) is not eligible for this position. Eligible branches: %s.",
                        student.getBranch(), job.getEligibleBranch()
                    ));
                }
            }

            // Save Application and Record initial Status History in a transaction
            Application app = new Application(jobId, studentId, remarks != null ? remarks.trim() : "Application submitted");
            app.setApplicationStatus(Application.STATUS_APPLIED);

            Connection conn = null;
            try {
                conn = DatabaseConfig.getConnection();
                conn.setAutoCommit(false);

                int appId = applicationDAO.create(app, conn);
                if (appId <= 0) {
                    throw new SQLException("Failed to create application record.");
                }

                ApplicationStatusHistory history = new ApplicationStatusHistory(appId, null, Application.STATUS_APPLIED, null);
                historyDAO.create(history, conn);

                conn.commit();
                logger.info("Student {} successfully applied for job {}", studentId, jobId);
                return app;
            } catch (SQLException e) {
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ex) {
                        logger.error("Rollback failed: {}", ex.getMessage());
                    }
                }
                logger.error("Transaction failed during job application: {}", e.getMessage());
                throw new RuntimeException("Could not submit application due to a database error.", e);
            } finally {
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true);
                        conn.close();
                    } catch (SQLException ignored) {
                    }
                }
            }

        } catch (SQLException e) {
            logger.error("Error during application submission: {}", e.getMessage());
            throw new RuntimeException("Could not submit application.", e);
        }
    }

    /**
     * Updates an application status and logs transition history in a transaction.
     */
    public boolean updateApplicationStatus(int applicationId, String newStatus, String remarks, int adminUserId)
            throws IllegalArgumentException {
        if (!VALID_STATUSES.contains(newStatus.toUpperCase())) {
            throw new IllegalArgumentException("Invalid status: " + newStatus + ". Allowed: " + VALID_STATUSES);
        }

        Connection conn = null;
        try {
            Application current = applicationDAO.findById(applicationId);
            if (current == null) {
                throw new IllegalArgumentException("Application not found.");
            }

            String previousStatus = current.getApplicationStatus();

            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false);

            boolean updated = applicationDAO.updateStatus(applicationId, newStatus.toUpperCase(), remarks, conn);
            if (!updated) {
                conn.rollback();
                return false;
            }

            ApplicationStatusHistory history = new ApplicationStatusHistory(
                applicationId,
                previousStatus,
                newStatus.toUpperCase(),
                adminUserId
            );
            historyDAO.create(history, conn);

            conn.commit();
            logger.info("Application {} status updated to {} by admin {}", applicationId, newStatus, adminUserId);
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    logger.error("Rollback failed: {}", ex.getMessage());
                }
            }
            logger.error("Error updating application status: {}", e.getMessage());
            throw new RuntimeException("Could not update application status.", e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    public List<Application> getStudentApplications(int studentId) {
        try {
            return applicationDAO.getApplicationsByStudent(studentId);
        } catch (SQLException e) {
            logger.error("Error fetching applications for student {}: {}", studentId, e.getMessage());
            throw new RuntimeException("Could not fetch applications.", e);
        }
    }

    public List<Application> getAllApplications(String search, String status, Integer jobId) {
        try {
            return applicationDAO.getAllApplications(search, status, jobId);
        } catch (SQLException e) {
            logger.error("Error fetching all applications: {}", e.getMessage());
            throw new RuntimeException("Could not fetch applications list.", e);
        }
    }

    public Application getApplicationById(int applicationId) {
        try {
            return applicationDAO.findById(applicationId);
        } catch (SQLException e) {
            logger.error("Error fetching application by id {}: {}", applicationId, e.getMessage());
            throw new RuntimeException("Could not fetch application.", e);
        }
    }

    public List<ApplicationStatusHistory> getApplicationHistory(int applicationId) {
        try {
            return historyDAO.findByApplicationId(applicationId);
        } catch (SQLException e) {
            logger.error("Error fetching history for app {}: {}", applicationId, e.getMessage());
            throw new RuntimeException("Could not fetch application history.", e);
        }
    }

    public List<Application> getRecentApplications(int limit) {
        try {
            return applicationDAO.getRecentApplications(limit);
        } catch (SQLException e) {
            logger.error("Error fetching recent applications: {}", e.getMessage());
            throw new RuntimeException("Could not fetch recent applications.", e);
        }
    }

    public List<Application> getCompanyApplications(int companyId, String search, String status, Integer jobId) {
        try {
            return applicationDAO.getApplicationsByCompany(companyId, search, status, jobId);
        } catch (SQLException e) {
            logger.error("Error fetching applications for company {}: {}", companyId, e.getMessage());
            throw new RuntimeException("Could not fetch company applications.", e);
        }
    }

    public Application getApplicationByIdAndCompany(int applicationId, int companyId) {
        try {
            return applicationDAO.findByIdAndCompany(applicationId, companyId);
        } catch (SQLException e) {
            logger.error("Error fetching application {} for company {}: {}", applicationId, companyId, e.getMessage());
            throw new RuntimeException("Could not fetch application.", e);
        }
    }

    public com.ajt.portal.model.DashboardStats getCompanyApplicationStats(int companyId) {
        try {
            return applicationDAO.getCompanyApplicationStats(companyId);
        } catch (SQLException e) {
            logger.error("Error fetching stats for company {}: {}", companyId, e.getMessage());
            return new com.ajt.portal.model.DashboardStats();
        }
    }

    public List<Application> getRecentApplicationsForCompany(int companyId, int limit) {
        try {
            return applicationDAO.getRecentApplicationsForCompany(companyId, limit);
        } catch (SQLException e) {
            logger.error("Error fetching recent applications for company {}: {}", companyId, e.getMessage());
            throw new RuntimeException("Could not fetch recent applications.", e);
        }
    }

    public boolean hasStudentAppliedToCompany(int studentId, int companyId) {
        try {
            return applicationDAO.hasStudentAppliedToCompany(studentId, companyId);
        } catch (SQLException e) {
            logger.error("Error checking student application for student {} and company {}: {}", studentId, companyId, e.getMessage());
            return false;
        }
    }

    public boolean updateApplicationStatusForCompany(int applicationId, int companyId, String newStatus, String remarks, int hrUserId)
            throws IllegalArgumentException {
        if (!VALID_STATUSES.contains(newStatus.toUpperCase())) {
            throw new IllegalArgumentException("Invalid status: " + newStatus + ". Allowed: " + VALID_STATUSES);
        }

        Connection conn = null;
        try {
            Application current = applicationDAO.findByIdAndCompany(applicationId, companyId);
            if (current == null) {
                throw new IllegalArgumentException("Application not found or unauthorized to manage another company's applicant.");
            }

            String previousStatus = current.getApplicationStatus();

            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false);

            boolean updated = applicationDAO.updateStatus(applicationId, newStatus.toUpperCase(), remarks, conn);
            if (!updated) {
                conn.rollback();
                return false;
            }

            ApplicationStatusHistory history = new ApplicationStatusHistory(
                applicationId,
                previousStatus,
                newStatus.toUpperCase(),
                hrUserId
            );
            historyDAO.create(history, conn);

            conn.commit();
            logger.info("Application {} status updated to {} by company HR {}", applicationId, newStatus, hrUserId);
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    logger.error("Rollback failed: {}", ex.getMessage());
                }
            }
            logger.error("Error updating application status for company HR: {}", e.getMessage());
            throw new RuntimeException("Could not update application status.", e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }
}

