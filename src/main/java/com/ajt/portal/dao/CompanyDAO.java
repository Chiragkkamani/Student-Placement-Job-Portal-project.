package com.ajt.portal.dao;

import com.ajt.portal.config.DatabaseConfig;
import com.ajt.portal.model.Company;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompanyDAO {

    private static final Logger logger = LoggerFactory.getLogger(CompanyDAO.class);

    public int create(Company c) throws SQLException {
        String sql = "INSERT INTO companies (company_name, industry, location, website, contact_email) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, c.getCompanyName());
            stmt.setString(2, c.getIndustry());
            stmt.setString(3, c.getLocation());
            stmt.setString(4, c.getWebsite());
            stmt.setString(5, c.getContactEmail());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int id = rs.getInt(1);
                        c.setCompanyId(id);
                        return id;
                    }
                }
            }
            return 0;
        }
    }

    public Company findById(int companyId) throws SQLException {
        String sql = "SELECT c.company_id, c.company_name, c.industry, c.location, c.website, c.contact_email, c.created_at, " +
                     "(SELECT COUNT(*) FROM jobs j WHERE j.company_id = c.company_id) AS job_count " +
                     "FROM companies c WHERE c.company_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, companyId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public Company findByName(String name) throws SQLException {
        String sql = "SELECT c.company_id, c.company_name, c.industry, c.location, c.website, c.contact_email, c.created_at, " +
                     "(SELECT COUNT(*) FROM jobs j WHERE j.company_id = c.company_id) AS job_count " +
                     "FROM companies c WHERE c.company_name = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    public boolean update(Company c) throws SQLException {
        String sql = "UPDATE companies SET company_name = ?, industry = ?, location = ?, website = ?, contact_email = ? WHERE company_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, c.getCompanyName());
            stmt.setString(2, c.getIndustry());
            stmt.setString(3, c.getLocation());
            stmt.setString(4, c.getWebsite());
            stmt.setString(5, c.getContactEmail());
            stmt.setInt(6, c.getCompanyId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean delete(int companyId) throws SQLException {
        String sql = "DELETE FROM companies WHERE company_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, companyId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Company> getAllCompanies(String search) throws SQLException {
        List<Company> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT c.company_id, c.company_name, c.industry, c.location, c.website, c.contact_email, c.created_at, " +
            "(SELECT COUNT(*) FROM jobs j WHERE j.company_id = c.company_id) AS job_count " +
            "FROM companies c "
        );

        List<Object> params = new ArrayList<>();
        if (search != null && !search.trim().isEmpty()) {
            sql.append("WHERE c.company_name LIKE ? OR c.industry LIKE ? OR c.location LIKE ? ");
            String term = "%" + search.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }

        sql.append("ORDER BY c.company_name ASC");

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

    public int getTotalCompanyCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM companies";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    private Company mapRow(ResultSet rs) throws SQLException {
        Company c = new Company();
        c.setCompanyId(rs.getInt("company_id"));
        c.setCompanyName(rs.getString("company_name"));
        c.setIndustry(rs.getString("industry"));
        c.setLocation(rs.getString("location"));
        c.setWebsite(rs.getString("website"));
        c.setContactEmail(rs.getString("contact_email"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            c.setJobCount(rs.getInt("job_count"));
        } catch (SQLException ignored) {
        }
        return c;
    }
}

