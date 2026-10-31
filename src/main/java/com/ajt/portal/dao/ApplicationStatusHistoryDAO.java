package com.ajt.portal.dao;

import com.ajt.portal.config.DatabaseConfig;
import com.ajt.portal.model.ApplicationStatusHistory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationStatusHistoryDAO {

    private static final Logger logger = LoggerFactory.getLogger(ApplicationStatusHistoryDAO.class);

    public int create(ApplicationStatusHistory history, Connection conn) throws SQLException {
        String sql = "INSERT INTO application_status_history (application_id, previous_status, new_status, changed_by) " +
                     "VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, history.getApplicationId());
            if (history.getPreviousStatus() != null) {
                stmt.setString(2, history.getPreviousStatus());
            } else {
                stmt.setNull(2, Types.VARCHAR);
            }
            stmt.setString(3, history.getNewStatus());
            if (history.getChangedBy() != null) {
                stmt.setInt(4, history.getChangedBy());
            } else {
                stmt.setNull(4, Types.INTEGER);
            }

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        history.setHistoryId(id);
                        return id;
                    }
                }
            }
            return 0;
        }
    }

    public List<ApplicationStatusHistory> findByApplicationId(int applicationId) throws SQLException {
        List<ApplicationStatusHistory> list = new ArrayList<>();
        String sql = "SELECT h.history_id, h.application_id, h.previous_status, h.new_status, h.changed_by, h.change_timestamp, " +
                     "u.full_name AS changed_by_name " +
                     "FROM application_status_history h " +
                     "LEFT JOIN users u ON h.changed_by = u.user_id " +
                     "WHERE h.application_id = ? ORDER BY h.change_timestamp DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, applicationId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ApplicationStatusHistory h = new ApplicationStatusHistory();
                    h.setHistoryId(rs.getInt("history_id"));
                    h.setApplicationId(rs.getInt("application_id"));
                    h.setPreviousStatus(rs.getString("previous_status"));
                    h.setNewStatus(rs.getString("new_status"));
                    int changedBy = rs.getInt("changed_by");
                    if (!rs.wasNull()) {
                        h.setChangedBy(changedBy);
                    }
                    h.setChangedByName(rs.getString("changed_by_name"));
                    h.setChangeTimestamp(rs.getTimestamp("change_timestamp"));
                    list.add(h);
                }
            }
        }
        return list;
    }
}

