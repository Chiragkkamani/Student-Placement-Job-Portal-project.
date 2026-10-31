package com.ajt.portal.dao;

import com.ajt.portal.config.DatabaseConfig;
import com.ajt.portal.model.Job;
import com.ajt.portal.model.Student;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobDAO {

    private static final Logger logger = LoggerFactory.getLogger(JobDAO.class);

    public int create(Job job) throws SQLException {
        String sql = "INSERT INTO jobs (company_id, job_title, description, location, minimum_cgpa, eligible_branch, deadline, job_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, job.getCompanyId());
            stmt.setString(2, job.getJobTitle());
            stmt.setString(3, job.getDescription());
            stmt.setString(4, job.getLocation());
            stmt.setBigDecimal(5, job.getMinimumCgpa());
            stmt.setString(6, job.getEligibleBranch());
            stmt.setDate(7, job.getDeadline());
            stmt.setString(8, job.getJobStatus());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        job.setJobId(id);
                        return id;
                    }
                }
            }
            return 0;
        }
    }

    public Job findById(int jobId) throws SQLException {
        String sql = "SELECT j.job_id, j.company_id, j.job_title, j.description, j.location, j.minimum_cgpa, j.eligible_branch, " +
                     "j.deadline, j.job_status, j.created_at, " +
                     "c.company_name, c.industry AS company_industry, c.location AS company_location, c.website AS company_website, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.job_id) AS applicant_count " +
                     "FROM jobs j " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "WHERE j.job_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, jobId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public Job findByIdWithStudentStatus(int jobId, int studentId) throws SQLException {
        String sql = "SELECT j.job_id, j.company_id, j.job_title, j.description, j.location, j.minimum_cgpa, j.eligible_branch, " +
                     "j.deadline, j.job_status, j.created_at, " +
                     "c.company_name, c.industry AS company_industry, c.location AS company_location, c.website AS company_website, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.job_id) AS applicant_count, " +
                     "a.application_status " +
                     "FROM jobs j " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "LEFT JOIN applications a ON a.job_id = j.job_id AND a.student_id = ? " +
                     "WHERE j.job_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            stmt.setInt(2, jobId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Job job = mapRow(rs);
                    String appStatus = rs.getString("application_status");
                    if (appStatus != null) {
                        job.setAppliedByCurrentUser(true);
                        job.setUserApplicationStatus(appStatus);
                    }
                    return job;
                }
            }
        }
        return null;
    }

    public boolean update(Job job) throws SQLException {
        String sql = "UPDATE jobs SET company_id = ?, job_title = ?, description = ?, location = ?, " +
                     "minimum_cgpa = ?, eligible_branch = ?, deadline = ?, job_status = ? WHERE job_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, job.getCompanyId());
            stmt.setString(2, job.getJobTitle());
            stmt.setString(3, job.getDescription());
            stmt.setString(4, job.getLocation());
            stmt.setBigDecimal(5, job.getMinimumCgpa());
            stmt.setString(6, job.getEligibleBranch());
            stmt.setDate(7, job.getDeadline());
            stmt.setString(8, job.getJobStatus());
            stmt.setInt(9, job.getJobId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int jobId, String status) throws SQLException {
        String sql = "UPDATE jobs SET job_status = ? WHERE job_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, jobId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean delete(int jobId) throws SQLException {
        String sql = "DELETE FROM jobs WHERE job_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, jobId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Job> getAllJobs(String search, String location, String branch, BigDecimal minCgpa, String status, String sortBy) throws SQLException {
        List<Job> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT j.job_id, j.company_id, j.job_title, j.description, j.location, j.minimum_cgpa, j.eligible_branch, " +
            "j.deadline, j.job_status, j.created_at, " +
            "c.company_name, c.industry AS company_industry, c.location AS company_location, c.website AS company_website, " +
            "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.job_id) AS applicant_count " +
            "FROM jobs j " +
            "JOIN companies c ON j.company_id = c.company_id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (j.job_title LIKE ? OR c.company_name LIKE ? OR j.description LIKE ?) ");
            String term = "%" + search.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (location != null && !location.trim().isEmpty() && !"All".equalsIgnoreCase(location.trim())) {
            sql.append("AND j.location LIKE ? ");
            params.add("%" + location.trim() + "%");
        }
        if (branch != null && !branch.trim().isEmpty() && !"All".equalsIgnoreCase(branch.trim()) && !"All Branches".equalsIgnoreCase(branch.trim())) {
            sql.append("AND (j.eligible_branch = 'All Branches' OR j.eligible_branch LIKE ?) ");
            params.add("%" + branch.trim() + "%");
        }
        if (minCgpa != null && minCgpa.compareTo(BigDecimal.ZERO) > 0) {
            sql.append("AND j.minimum_cgpa <= ? ");
            params.add(minCgpa);
        }
        if (status != null && !status.trim().isEmpty() && !"All".equalsIgnoreCase(status.trim())) {
            sql.append("AND j.job_status = ? ");
            params.add(status.trim().toUpperCase());
        }

        if ("deadline".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY j.deadline ASC");
        } else if ("cgpa".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY j.minimum_cgpa ASC");
        } else {
            sql.append("ORDER BY j.created_at DESC");
        }

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

    public List<Job> getFeaturedJobs(int limit) throws SQLException {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.job_id, j.company_id, j.job_title, j.description, j.location, j.minimum_cgpa, j.eligible_branch, " +
                     "j.deadline, j.job_status, j.created_at, " +
                     "c.company_name, c.industry AS company_industry, c.location AS company_location, c.website AS company_website, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.job_id) AS applicant_count " +
                     "FROM jobs j " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "WHERE j.job_status = 'ACTIVE' AND j.deadline >= CURDATE() " +
                     "ORDER BY j.created_at DESC LIMIT ?";
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

    public List<Job> getEligibleJobs(Student student, int limit) throws SQLException {
        List<Job> list = new ArrayList<>();
        if (student == null) {
            return getFeaturedJobs(limit);
        }

        String sql = "SELECT j.job_id, j.company_id, j.job_title, j.description, j.location, j.minimum_cgpa, j.eligible_branch, " +
                     "j.deadline, j.job_status, j.created_at, " +
                     "c.company_name, c.industry AS company_industry, c.location AS company_location, c.website AS company_website, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.job_id) AS applicant_count, " +
                     "a.application_status " +
                     "FROM jobs j " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "LEFT JOIN applications a ON a.job_id = j.job_id AND a.student_id = ? " +
                     "WHERE j.job_status = 'ACTIVE' " +
                     "AND j.deadline >= CURDATE() " +
                     "AND j.minimum_cgpa <= ? " +
                     "AND (j.eligible_branch = 'All Branches' OR j.eligible_branch LIKE ?) " +
                     "ORDER BY j.deadline ASC LIMIT ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, student.getStudentId());
            stmt.setBigDecimal(2, student.getCgpa() != null ? student.getCgpa() : BigDecimal.valueOf(10.0));
            stmt.setString(3, "%" + (student.getBranch() != null ? student.getBranch() : "") + "%");
            stmt.setInt(4, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Job job = mapRow(rs);
                    String appStatus = rs.getString("application_status");
                    if (appStatus != null) {
                        job.setAppliedByCurrentUser(true);
                        job.setUserApplicationStatus(appStatus);
                    }
                    list.add(job);
                }
            }
        }
        return list;
    }

    public int getActiveJobsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM jobs WHERE job_status = 'ACTIVE' AND deadline >= CURDATE()";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Job> getJobsByCompany(int companyId) throws SQLException {
        List<Job> list = new ArrayList<>();
        String sql = "SELECT j.job_id, j.company_id, j.job_title, j.description, j.location, j.minimum_cgpa, j.eligible_branch, " +
                     "j.deadline, j.job_status, j.created_at, " +
                     "c.company_name, c.industry AS company_industry, c.location AS company_location, c.website AS company_website, " +
                     "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.job_id) AS applicant_count " +
                     "FROM jobs j " +
                     "JOIN companies c ON j.company_id = c.company_id " +
                     "WHERE j.company_id = ? ORDER BY j.created_at DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, companyId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    private Job mapRow(ResultSet rs) throws SQLException {
        Job j = new Job();
        j.setJobId(rs.getInt("job_id"));
        j.setCompanyId(rs.getInt("company_id"));
        j.setJobTitle(rs.getString("job_title"));
        j.setDescription(rs.getString("description"));
        j.setLocation(rs.getString("location"));
        j.setMinimumCgpa(rs.getBigDecimal("minimum_cgpa"));
        j.setEligibleBranch(rs.getString("eligible_branch"));
        j.setDeadline(rs.getDate("deadline"));
        j.setJobStatus(rs.getString("job_status"));
        j.setCreatedAt(rs.getTimestamp("created_at"));

        j.setCompanyName(rs.getString("company_name"));
        j.setCompanyIndustry(rs.getString("company_industry"));
        j.setCompanyLocation(rs.getString("company_location"));
        j.setCompanyWebsite(rs.getString("company_website"));
        try {
            j.setApplicantCount(rs.getInt("applicant_count"));
        } catch (SQLException ignored) {
        }
        return j;
    }
}

