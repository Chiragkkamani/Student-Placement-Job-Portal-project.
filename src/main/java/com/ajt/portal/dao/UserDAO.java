package com.ajt.portal.dao;

import com.ajt.portal.config.DatabaseConfig;
import com.ajt.portal.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);

    public int create(User user) throws SQLException {
        String sql = "INSERT INTO users (full_name, email, password_hash, role, account_status, company_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getAccountStatus());
            if (user.getCompanyId() != null && user.getCompanyId() > 0) {
                stmt.setInt(6, user.getCompanyId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        user.setUserId(id);
                        return id;
                    }
                }
            }
            return 0;
        }
    }

    public int create(User user, Connection conn) throws SQLException {
        String sql = "INSERT INTO users (full_name, email, password_hash, role, account_status, company_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getRole());
            stmt.setString(5, user.getAccountStatus());
            if (user.getCompanyId() != null && user.getCompanyId() > 0) {
                stmt.setInt(6, user.getCompanyId());
            } else {
                stmt.setNull(6, Types.INTEGER);
            }

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        user.setUserId(id);
                        return id;
                    }
                }
            }
            return 0;
        }
    }

    public User findById(int userId) throws SQLException {
        String sql = "SELECT u.user_id, u.full_name, u.email, u.password_hash, u.role, u.account_status, u.company_id, u.created_at, " +
                     "c.company_name " +
                     "FROM users u " +
                     "LEFT JOIN companies c ON u.company_id = c.company_id " +
                     "WHERE u.user_id = ?";
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

    public User findByEmail(String email) throws SQLException {
        return findByEmailOrUsername(email);
    }

    public User findByEmailOrUsername(String identifier) throws SQLException {
        if (identifier == null || identifier.trim().isEmpty()) {
            return null;
        }
        String clean = identifier.trim().toLowerCase();
        String sql = "SELECT u.user_id, u.full_name, u.email, u.password_hash, u.role, u.account_status, u.company_id, u.created_at, " +
                     "c.company_name " +
                     "FROM users u " +
                     "LEFT JOIN companies c ON u.company_id = c.company_id " +
                     "WHERE LOWER(u.email) = ? OR LOWER(u.email) = ? OR LOWER(u.email) LIKE ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, clean);
            stmt.setString(2, clean + "@placement.edu");
            stmt.setString(3, clean + "@%");
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean update(User user) throws SQLException {
        String sql = "UPDATE users SET full_name = ?, email = ?, account_status = ?, company_id = ? WHERE user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getAccountStatus());
            if (user.getCompanyId() != null && user.getCompanyId() > 0) {
                stmt.setInt(4, user.getCompanyId());
            } else {
                stmt.setNull(4, Types.INTEGER);
            }
            stmt.setInt(5, user.getUserId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(int userId, String newHash) throws SQLException {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newHash);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int userId, String status) throws SQLException {
        String sql = "UPDATE users SET account_status = ? WHERE user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.user_id, u.full_name, u.email, u.password_hash, u.role, u.account_status, u.company_id, u.created_at, " +
                     "c.company_name " +
                     "FROM users u " +
                     "LEFT JOIN companies c ON u.company_id = c.company_id " +
                     "ORDER BY u.created_at DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));
        u.setAccountStatus(rs.getString("account_status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        int compId = rs.getInt("company_id");
        if (!rs.wasNull()) {
            u.setCompanyId(compId);
        }
        try {
            u.setCompanyName(rs.getString("company_name"));
        } catch (SQLException ignored) {
        }
        return u;
    }
}

