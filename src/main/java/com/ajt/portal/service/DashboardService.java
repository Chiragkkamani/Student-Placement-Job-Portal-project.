package com.ajt.portal.service;

import com.ajt.portal.dao.ApplicationDAO;
import com.ajt.portal.dao.CompanyDAO;
import com.ajt.portal.dao.JobDAO;
import com.ajt.portal.dao.StudentDAO;
import com.ajt.portal.model.DashboardStats;
import com.ajt.portal.model.Student;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;

public class DashboardService {

    private static final Logger logger = LoggerFactory.getLogger(DashboardService.class);

    private final StudentDAO studentDAO;
    private final CompanyDAO companyDAO;
    private final JobDAO jobDAO;
    private final ApplicationDAO applicationDAO;

    public DashboardService() {
        this.studentDAO = new StudentDAO();
        this.companyDAO = new CompanyDAO();
        this.jobDAO = new JobDAO();
        this.applicationDAO = new ApplicationDAO();
    }

    public DashboardService(StudentDAO studentDAO, CompanyDAO companyDAO, JobDAO jobDAO, ApplicationDAO applicationDAO) {
        this.studentDAO = studentDAO;
        this.companyDAO = companyDAO;
        this.jobDAO = jobDAO;
        this.applicationDAO = applicationDAO;
    }

    public DashboardStats getAdminDashboardStats() {
        DashboardStats stats = new DashboardStats();
        try {
            stats.setTotalStudents(studentDAO.getTotalStudentCount());
            stats.setTotalCompanies(companyDAO.getTotalCompanyCount());
            stats.setActiveJobs(jobDAO.getActiveJobsCount());

            DashboardStats appStats = applicationDAO.getAdminApplicationStats();
            stats.setTotalApplications(appStats.getTotalApplications());
            stats.setAppliedCount(appStats.getAppliedCount());
            stats.setShortlistedCount(appStats.getShortlistedCount());
            stats.setRejectedCount(appStats.getRejectedCount());
            stats.setSelectedCount(appStats.getSelectedCount());
        } catch (SQLException e) {
            logger.error("Error gathering admin dashboard stats: {}", e.getMessage());
        }
        return stats;
    }

    public DashboardStats getStudentDashboardStats(Student student) {
        DashboardStats stats = new DashboardStats();
        if (student == null) {
            return stats;
        }

        try {
            DashboardStats appStats = applicationDAO.getStudentApplicationStats(student.getStudentId());
            stats.setStudentTotalApplications(appStats.getStudentTotalApplications());
            stats.setStudentAppliedCount(appStats.getStudentAppliedCount());
            stats.setStudentShortlistedCount(appStats.getStudentShortlistedCount());
            stats.setStudentSelectedCount(appStats.getStudentSelectedCount());
            stats.setStudentRejectedCount(appStats.getStudentRejectedCount());
        } catch (SQLException e) {
            logger.error("Error gathering student dashboard stats: {}", e.getMessage());
        }
        return stats;
    }
}

