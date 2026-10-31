package com.ajt.portal.service;

import com.ajt.portal.dao.CompanyDAO;
import com.ajt.portal.model.Company;
import com.ajt.portal.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;
import java.util.List;

public class CompanyService {

    private static final Logger logger = LoggerFactory.getLogger(CompanyService.class);

    private final CompanyDAO companyDAO;

    public CompanyService() {
        this.companyDAO = new CompanyDAO();
    }

    public CompanyService(CompanyDAO companyDAO) {
        this.companyDAO = companyDAO;
    }

    public Company getCompanyById(int companyId) {
        try {
            return companyDAO.findById(companyId);
        } catch (SQLException e) {
            logger.error("Error retrieving company by id {}: {}", companyId, e.getMessage());
            throw new RuntimeException("Could not retrieve company.", e);
        }
    }

    public int createCompany(Company company) throws IllegalArgumentException {
        validateCompany(company);

        try {
            Company existing = companyDAO.findByName(company.getCompanyName().trim());
            if (existing != null) {
                throw new IllegalArgumentException("A company with name '" + company.getCompanyName() + "' already exists.");
            }
            return companyDAO.create(company);
        } catch (SQLException e) {
            logger.error("Error creating company: {}", e.getMessage());
            throw new RuntimeException("Could not create company.", e);
        }
    }

    public boolean updateCompany(Company company) throws IllegalArgumentException {
        validateCompany(company);

        try {
            return companyDAO.update(company);
        } catch (SQLException e) {
            logger.error("Error updating company: {}", e.getMessage());
            throw new RuntimeException("Could not update company.", e);
        }
    }

    public boolean deleteCompany(int companyId) {
        try {
            return companyDAO.delete(companyId);
        } catch (SQLException e) {
            logger.error("Error deleting company {}: {}", companyId, e.getMessage());
            throw new RuntimeException("Could not delete company. It may have associated job listings.", e);
        }
    }

    public List<Company> getAllCompanies(String search) {
        try {
            return companyDAO.getAllCompanies(search);
        } catch (SQLException e) {
            logger.error("Error fetching companies: {}", e.getMessage());
            throw new RuntimeException("Could not fetch companies.", e);
        }
    }

    public int getTotalCompanies() {
        try {
            return companyDAO.getTotalCompanyCount();
        } catch (SQLException e) {
            return 0;
        }
    }

    private void validateCompany(Company c) throws IllegalArgumentException {
        if (!ValidationUtil.isNotEmpty(c.getCompanyName())) {
            throw new IllegalArgumentException("Company name is required.");
        }
        if (!ValidationUtil.isNotEmpty(c.getIndustry())) {
            throw new IllegalArgumentException("Industry is required.");
        }
        if (!ValidationUtil.isNotEmpty(c.getLocation())) {
            throw new IllegalArgumentException("Company location is required.");
        }
        if (!ValidationUtil.isValidEmail(c.getContactEmail())) {
            throw new IllegalArgumentException("Valid contact email is required.");
        }
    }
}

