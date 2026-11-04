package com.ajt.portal.dao;

import com.ajt.portal.config.DatabaseConfig;
import com.ajt.portal.model.Application;
import com.ajt.portal.model.DashboardStats;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    private static final Logger logger = LoggerFactory.getLogger(ApplicationDAO.class);

    public int create(Application app, Connection conn) throws SQLException {
        String sql = "INSERT INTO applications (job_id, student_id, application_status, remarks) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, app.getJobId());
            stmt.setInt(2, app.getStudentId());
            stmt.setString(3, app.getApplicationStatus());
            stmt.setString(4, app.getRemarks());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        app.setApplicationId(id);
                        return id;
                    }
                }
            }
            return 0;
        }
    }

    public int create(Application app) throws SQLException {
        try (Connection conn = DatabaseConfig.getConnection()) {
            return create(app, conn);
        }
    }

    public Application findById(int applicationId) throws SQLException {
        String sql = "SELECT a.application_id, a.job_id, a.student_id, a.application_date, a.application_status, a.remarks, " +
                     "j.job_title, j.location AS job_location, j.minimum_cgpa AS job_min_cgpa, j.eligible_branch AS job_branch, j.job_status, " +
                     "c.company_name, " +
                     "u.full_name AS student_name, u.email AS student_email, " +
                     "s.enrollment_number, s.branch AS student_branch, s.semester AS student_semester, s.cgpa AS student_cgpa, s.phone AS student_phone, s.resume_path " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.job_id " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE a.application_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, applicationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public Application findByStudentAndJob(int studentId, int jobId) throws SQLException {
        String sql = "SELECT a.application_id, a.job_id, a.student_id, a.application_date, a.application_status, a.remarks, " +
                     "j.job_title, j.location AS job_location, j.minimum_cgpa AS job_min_cgpa, j.eligible_branch AS job_branch, j.job_status, " +
                     "c.company_name, " +
                     "u.full_name AS student_name, u.email AS student_email, " +
                     "s.enrollment_number, s.branch AS student_branch, s.semester AS student_semester, s.cgpa AS student_cgpa, s.phone AS student_phone, s.resume_path " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.job_id " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE a.student_id = ? AND a.job_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, jobId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean updateStatus(int applicationId, String status, String remarks, Connection conn) throws SQLException {
        String sql = "UPDATE applications SET application_status = ?, remarks = ? WHERE application_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, remarks);
            stmt.setInt(3, applicationId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Application> getApplicationsByStudent(int studentId) throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.application_id, a.job_id, a.student_id, a.application_date, a.application_status, a.remarks, " +
                     "j.job_title, j.location AS job_location, j.minimum_cgpa AS job_min_cgpa, j.eligible_branch AS job_branch, j.job_status, " +
                     "c.company_name, " +
                     "u.full_name AS student_name, u.email AS student_email, " +
                     "s.enrollment_number, s.branch AS student_branch, s.semester AS student_semester, s.cgpa AS student_cgpa, s.phone AS student_phone, s.resume_path " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.job_id " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE a.student_id = ? ORDER BY a.application_date DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public List<Application> getAllApplications(String search, String status, Integer jobId) throws SQLException {
        List<Application> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.application_id, a.job_id, a.student_id, a.application_date, a.application_status, a.remarks, " +
            "j.job_title, j.location AS job_location, j.minimum_cgpa AS job_min_cgpa, j.eligible_branch AS job_branch, j.job_status, " +
            "c.company_name, " +
            "u.full_name AS student_name, u.email AS student_email, " +
            "s.enrollment_number, s.branch AS student_branch, s.semester AS student_semester, s.cgpa AS student_cgpa, s.phone AS student_phone, s.resume_path " +
            "FROM applications a " +
            "JOIN jobs j ON a.job_id = j.job_id " +
            "JOIN companies c ON j.company_id = c.company_id " +
            "JOIN students s ON a.student_id = s.student_id " +
            "JOIN users u ON s.user_id = u.user_id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.full_name LIKE ? OR s.enrollment_number LIKE ? OR j.job_title LIKE ? OR c.company_name LIKE ?) ");
            String term = "%" + search.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (status != null && !status.trim().isEmpty() && !"All".equalsIgnoreCase(status.trim())) {
            sql.append("AND a.application_status = ? ");
            params.add(status.trim().toUpperCase());
        }
        if (jobId != null && jobId > 0) {
            sql.append("AND a.job_id = ? ");
            params.add(jobId);
        }

        sql.append("ORDER BY a.application_date DESC");

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public List<Application> getRecentApplications(int limit) throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.application_id, a.job_id, a.student_id, a.application_date, a.application_status, a.remarks, " +
                     "j.job_title, j.location AS job_location, j.minimum_cgpa AS job_min_cgpa, j.eligible_branch AS job_branch, j.job_status, " +
                     "c.company_name, " +
                     "u.full_name AS student_name, u.email AS student_email, " +
                     "s.enrollment_number, s.branch AS student_branch, s.semester AS student_semester, s.cgpa AS student_cgpa, s.phone AS student_phone, s.resume_path " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.job_id " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "ORDER BY a.application_date DESC LIMIT ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public DashboardStats getStudentApplicationStats(int studentId) throws SQLException {
        DashboardStats stats = new DashboardStats();
        String sql = "SELECT application_status, COUNT(*) as cnt FROM applications WHERE student_id = ? GROUP BY application_status";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                int total = 0;
                while (rs.next()) {
                    String status = rs.getString("application_status");
                    int count = rs.getInt("cnt");
                    total += count;
                    switch (status.toUpperCase()) {
                        case Application.STATUS_APPLIED -> stats.setStudentAppliedCount(count);
                        case Application.STATUS_SHORTLISTED -> stats.setStudentShortlistedCount(count);
                        case Application.STATUS_SELECTED -> stats.setStudentSelectedCount(count);
                        case Application.STATUS_REJECTED -> stats.setStudentRejectedCount(count);
                    }
                }
                stats.setStudentTotalApplications(total);
            }
        }
        return stats;
    }

    public DashboardStats getAdminApplicationStats() throws SQLException {
        DashboardStats stats = new DashboardStats();
        String sql = "SELECT application_status, COUNT(*) as cnt FROM applications GROUP BY application_status";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            int total = 0;
            while (rs.next()) {
                String status = rs.getString("application_status");
                int count = rs.getInt("cnt");
                total += count;
                switch (status.toUpperCase()) {
                    case Application.STATUS_APPLIED -> stats.setAppliedCount(count);
                    case Application.STATUS_SHORTLISTED -> stats.setShortlistedCount(count);
                    case Application.STATUS_SELECTED -> stats.setSelectedCount(count);
                    case Application.STATUS_REJECTED -> stats.setRejectedCount(count);
                }
            }
            stats.setTotalApplications(total);
        }
        return stats;
    }

    public List<Application> getApplicationsByCompany(int companyId, String search, String status, Integer jobId) throws SQLException {
        List<Application> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.application_id, a.job_id, a.student_id, a.application_date, a.application_status, a.remarks, " +
            "j.job_title, j.location AS job_location, j.minimum_cgpa AS job_min_cgpa, j.eligible_branch AS job_branch, j.job_status, " +
            "c.company_name, " +
            "u.full_name AS student_name, u.email AS student_email, " +
            "s.enrollment_number, s.branch AS student_branch, s.semester AS student_semester, s.cgpa AS student_cgpa, s.phone AS student_phone, s.resume_path " +
            "FROM applications a " +
            "JOIN jobs j ON a.job_id = j.job_id " +
            "JOIN companies c ON j.company_id = c.company_id " +
            "JOIN students s ON a.student_id = s.student_id " +
            "JOIN users u ON s.user_id = u.user_id " +
            "WHERE j.company_id = ? "
        );

        List<Object> params = new ArrayList<>();
        params.add(companyId);

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.full_name LIKE ? OR s.enrollment_number LIKE ? OR j.job_title LIKE ?) ");
            String term = "%" + search.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (status != null && !status.trim().isEmpty() && !"All".equalsIgnoreCase(status.trim())) {
            sql.append("AND a.application_status = ? ");
            params.add(status.trim().toUpperCase());
        }
        if (jobId != null && jobId > 0) {
            sql.append("AND a.job_id = ? ");
            params.add(jobId);
        }

        sql.append("ORDER BY a.application_date DESC");

        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public Application findByIdAndCompany(int applicationId, int companyId) throws SQLException {
        String sql = "SELECT a.application_id, a.job_id, a.student_id, a.application_date, a.application_status, a.remarks, " +
                     "j.job_title, j.location AS job_location, j.minimum_cgpa AS job_min_cgpa, j.eligible_branch AS job_branch, j.job_status, " +
                     "c.company_name, " +
                     "u.full_name AS student_name, u.email AS student_email, " +
                     "s.enrollment_number, s.branch AS student_branch, s.semester AS student_semester, s.cgpa AS student_cgpa, s.phone AS student_phone, s.resume_path " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.job_id " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE a.application_id = ? AND j.company_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, applicationId);
            stmt.setInt(2, companyId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public DashboardStats getCompanyApplicationStats(int companyId) throws SQLException {
        DashboardStats stats = new DashboardStats();
        String sql = "SELECT a.application_status, COUNT(*) as cnt " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.job_id " +
                     "WHERE j.company_id = ? " +
                     "GROUP BY a.application_status";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, companyId);
            try (ResultSet rs = stmt.executeQuery()) {
                int total = 0;
                while (rs.next()) {
                    String status = rs.getString("application_status");
                    int count = rs.getInt("cnt");
                    total += count;
                    switch (status.toUpperCase()) {
                        case Application.STATUS_APPLIED -> stats.setAppliedCount(count);
                        case Application.STATUS_SHORTLISTED -> stats.setShortlistedCount(count);
                        case Application.STATUS_SELECTED -> stats.setSelectedCount(count);
                        case Application.STATUS_REJECTED -> stats.setRejectedCount(count);
                    }
                }
                stats.setTotalApplications(total);
            }
        }
        return stats;
    }

    public List<Application> getRecentApplicationsForCompany(int companyId, int limit) throws SQLException {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.application_id, a.job_id, a.student_id, a.application_date, a.application_status, a.remarks, " +
                     "j.job_title, j.location AS job_location, j.minimum_cgpa AS job_min_cgpa, j.eligible_branch AS job_branch, j.job_status, " +
                     "c.company_name, " +
                     "u.full_name AS student_name, u.email AS student_email, " +
                     "s.enrollment_number, s.branch AS student_branch, s.semester AS student_semester, s.cgpa AS student_cgpa, s.phone AS student_phone, s.resume_path " +
                     "FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.job_id " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "JOIN students s ON a.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE j.company_id = ? " +
                     "ORDER BY a.application_date DESC LIMIT ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, companyId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    public boolean hasStudentAppliedToCompany(int studentId, int companyId) throws SQLException {
        String sql = "SELECT 1 FROM applications a " +
                     "JOIN jobs j ON a.job_id = j.job_id " +
                     "WHERE a.student_id = ? AND j.company_id = ? LIMIT 1";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, companyId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private Application mapRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setApplicationId(rs.getInt("application_id"));
        a.setJobId(rs.getInt("job_id"));
        a.setStudentId(rs.getInt("student_id"));
        a.setApplicationDate(rs.getTimestamp("application_date"));
        a.setApplicationStatus(rs.getString("application_status"));
        a.setRemarks(rs.getString("remarks"));

        a.setJobTitle(rs.getString("job_title"));
        a.setJobLocation(rs.getString("job_location"));
        a.setJobMinCgpa(rs.getBigDecimal("job_min_cgpa"));
        a.setJobBranch(rs.getString("job_branch"));
        a.setJobStatus(rs.getString("job_status"));
        a.setCompanyName(rs.getString("company_name"));

        a.setStudentName(rs.getString("student_name"));
        a.setStudentEmail(rs.getString("student_email"));
        a.setEnrollmentNumber(rs.getString("enrollment_number"));
        a.setStudentBranch(rs.getString("student_branch"));
        a.setStudentSemester(rs.getInt("student_semester"));
        a.setStudentCgpa(rs.getBigDecimal("student_cgpa"));
        a.setStudentPhone(rs.getString("student_phone"));
        a.setStudentResumePath(rs.getString("resume_path"));
        return a;
    }
}

