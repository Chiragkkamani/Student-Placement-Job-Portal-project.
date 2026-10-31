package com.ajt.portal.dao;

import com.ajt.portal.config.DatabaseConfig;
import com.ajt.portal.model.Student;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    private static final Logger logger = LoggerFactory.getLogger(StudentDAO.class);

    public int create(Student s, Connection conn) throws SQLException {
        String sql = "INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, s.getUserId());
            stmt.setString(2, s.getEnrollmentNumber());
            stmt.setString(3, s.getBranch());
            stmt.setInt(4, s.getSemester());
            stmt.setBigDecimal(5, s.getCgpa());
            stmt.setString(6, s.getPhone());
            stmt.setString(7, s.getResumePath());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        s.setStudentId(id);
                        return id;
                    }
                }
            }
            return 0;
        }
    }

    public int create(Student s) throws SQLException {
        try (Connection conn = DatabaseConfig.getConnection()) {
            return create(s, conn);
        }
    }

    public Student findById(int studentId) throws SQLException {
        String sql = "SELECT s.student_id, s.user_id, s.enrollment_number, s.branch, s.semester, s.cgpa, s.phone, s.resume_path, " +
                     "u.full_name, u.email, u.account_status, u.created_at " +
                     "FROM students s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE s.student_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public Student findByUserId(int userId) throws SQLException {
        String sql = "SELECT s.student_id, s.user_id, s.enrollment_number, s.branch, s.semester, s.cgpa, s.phone, s.resume_path, " +
                     "u.full_name, u.email, u.account_status, u.created_at " +
                     "FROM students s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE s.user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public Student findByEnrollmentNumber(String enrollmentNumber) throws SQLException {
        String sql = "SELECT s.student_id, s.user_id, s.enrollment_number, s.branch, s.semester, s.cgpa, s.phone, s.resume_path, " +
                     "u.full_name, u.email, u.account_status, u.created_at " +
                     "FROM students s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE s.enrollment_number = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, enrollmentNumber);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean update(Student s) throws SQLException {
        String sql = "UPDATE students SET branch = ?, semester = ?, cgpa = ?, phone = ? WHERE student_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, s.getBranch());
            stmt.setInt(2, s.getSemester());
            stmt.setBigDecimal(3, s.getCgpa());
            stmt.setString(4, s.getPhone());
            stmt.setInt(5, s.getStudentId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateResumePath(int studentId, String resumePath) throws SQLException {
        String sql = "UPDATE students SET resume_path = ? WHERE student_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, resumePath);
            stmt.setInt(2, studentId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean delete(int studentId) throws SQLException {
        // Deleting the student's user will cascade delete the student record due to FK
        String sql = "DELETE u FROM users u JOIN students s ON u.user_id = s.user_id WHERE s.student_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Student> getAllStudents(String search, String branch) throws SQLException {
        List<Student> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.student_id, s.user_id, s.enrollment_number, s.branch, s.semester, s.cgpa, s.phone, s.resume_path, " +
            "u.full_name, u.email, u.account_status, u.created_at " +
            "FROM students s " +
            "JOIN users u ON s.user_id = u.user_id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (u.full_name LIKE ? OR u.email LIKE ? OR s.enrollment_number LIKE ?) ");
            String term = "%" + search.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (branch != null && !branch.trim().isEmpty() && !"All".equalsIgnoreCase(branch.trim())) {
            sql.append("AND s.branch = ? ");
            params.add(branch.trim());
        }

        sql.append("ORDER BY u.created_at DESC");

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

    public int getTotalStudentCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setEnrollmentNumber(rs.getString("enrollment_number"));
        s.setBranch(rs.getString("branch"));
        s.setSemester(rs.getInt("semester"));
        s.setCgpa(rs.getBigDecimal("cgpa"));
        s.setPhone(rs.getString("phone"));
        s.setResumePath(rs.getString("resume_path"));

        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setAccountStatus(rs.getString("account_status"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}

