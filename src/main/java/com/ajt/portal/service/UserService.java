package com.ajt.portal.service;

import com.ajt.portal.config.DatabaseConfig;
import com.ajt.portal.dao.StudentDAO;
import com.ajt.portal.dao.UserDAO;
import com.ajt.portal.model.Student;
import com.ajt.portal.model.User;
import com.ajt.portal.util.PasswordUtil;
import com.ajt.portal.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.SQLException;

public class UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    private final UserDAO userDAO;
    private final StudentDAO studentDAO;

    public UserService() {
        this.userDAO = new UserDAO();
        this.studentDAO = new StudentDAO();
    }

    public UserService(UserDAO userDAO, StudentDAO studentDAO) {
        this.userDAO = userDAO;
        this.studentDAO = studentDAO;
    }

    /**
     * Authenticates user with email or username/admin ID and plain password.
     */
    public User authenticate(String identifier, String plainPassword) throws IllegalArgumentException {
        if (!ValidationUtil.isNotEmpty(identifier)) {
            throw new IllegalArgumentException("Username or email is required.");
        }
        if (!ValidationUtil.isNotEmpty(plainPassword)) {
            throw new IllegalArgumentException("Password cannot be empty.");
        }

        try {
            User user = userDAO.findByEmailOrUsername(identifier.trim());
            if (user == null) {
                return null;
            }

            if (!PasswordUtil.checkPassword(plainPassword, user.getPasswordHash())) {
                return null;
            }

            if (!user.isActive()) {
                throw new IllegalStateException("Your account has been deactivated. Please contact administration.");
            }

            return user;
        } catch (SQLException e) {
            logger.error("Database error during authentication: {}", e.getMessage());
            throw new RuntimeException("Database error during login. Please try again later.", e);
        }
    }

    /**
     * Registers a new student and user atomically in a transaction.
     */
    public User registerStudent(User user, Student student, String plainPassword) throws IllegalArgumentException {
        // Validation
        if (!ValidationUtil.isNotEmpty(user.getFullName())) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (!ValidationUtil.isValidEmail(user.getEmail())) {
            throw new IllegalArgumentException("Valid email address is required.");
        }
        if (plainPassword == null || plainPassword.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters.");
        }
        if (!ValidationUtil.isNotEmpty(student.getEnrollmentNumber())) {
            throw new IllegalArgumentException("Enrollment number is required.");
        }
        if (!ValidationUtil.isNotEmpty(student.getBranch())) {
            throw new IllegalArgumentException("Branch of study is required.");
        }
        if (student.getSemester() < 1 || student.getSemester() > 10) {
            throw new IllegalArgumentException("Semester must be between 1 and 10.");
        }
        if (!ValidationUtil.isValidCgpa(student.getCgpa())) {
            throw new IllegalArgumentException("CGPA must be between 0.00 and 10.00.");
        }
        if (!ValidationUtil.isValidPhone(student.getPhone())) {
            throw new IllegalArgumentException("Valid phone number is required.");
        }

        // Check if email or enrollment already registered
        try {
            if (userDAO.findByEmail(user.getEmail().trim().toLowerCase()) != null) {
                throw new IllegalArgumentException(
                        "Email is already registered. Please login or use a different email.");
            }
            if (studentDAO.findByEnrollmentNumber(student.getEnrollmentNumber().trim()) != null) {
                throw new IllegalArgumentException("Enrollment number already exists.");
            }
        } catch (SQLException e) {
            logger.error("Error checking existing user: {}", e.getMessage());
            throw new RuntimeException("Database error during registration check.", e);
        }

        user.setEmail(user.getEmail().trim().toLowerCase());
        user.setPasswordHash(PasswordUtil.hashPassword(plainPassword));
        user.setRole(User.ROLE_STUDENT);
        user.setAccountStatus(User.STATUS_ACTIVE);

        Connection conn = null;
        try {
            conn = DatabaseConfig.getConnection();
            conn.setAutoCommit(false);

            int userId = userDAO.create(user, conn);
            if (userId <= 0) {
                throw new SQLException("Failed to insert user account.");
            }

            student.setUserId(userId);
            int studentId = studentDAO.create(student, conn);
            if (studentId <= 0) {
                throw new SQLException("Failed to insert student profile.");
            }

            conn.commit();
            logger.info("Successfully registered student '{}' with user id {}", user.getEmail(), userId);
            return user;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    logger.error("Rollback failed: {}", ex.getMessage());
                }
            }
            logger.error("Transaction failed during student registration: {}", e.getMessage());
            throw new RuntimeException("Could not complete registration: " + e.getMessage(), e);
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

    public User getUserById(int userId) {
        try {
            return userDAO.findById(userId);
        } catch (SQLException e) {
            logger.error("Error retrieving user by id {}: {}", userId, e.getMessage());
            throw new RuntimeException("Error retrieving user details.", e);
        }
    }

    public boolean updateUserStatus(int userId, String status) {
        try {
            return userDAO.updateStatus(userId, status);
        } catch (SQLException e) {
            logger.error("Error updating user status: {}", e.getMessage());
            throw new RuntimeException("Could not update account status.", e);
        }
    }

    public java.util.List<User> getAllUsers() {
        try {
            return userDAO.getAllUsers();
        } catch (SQLException e) {
            logger.error("Error retrieving all users: {}", e.getMessage());
            throw new RuntimeException("Could not retrieve user accounts.", e);
        }
    }

    /**
     * Admin creates an account directly (Admin, Company HR, or Student).
     */
    public User createAccountByAdmin(String fullName, String emailOrUsername, String plainPassword, String role,
            String status) {
        return createAccountByAdmin(fullName, emailOrUsername, plainPassword, role, status, null);
    }

    public User createAccountByAdmin(String fullName, String emailOrUsername, String plainPassword, String role,
            String status, Integer companyId) {
        if (!ValidationUtil.isNotEmpty(fullName)) {
            throw new IllegalArgumentException("Full name is required.");
        }
        if (!ValidationUtil.isNotEmpty(emailOrUsername)) {
            throw new IllegalArgumentException("Email or Username/Account ID is required.");
        }
        if (plainPassword == null || plainPassword.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters.");
        }
        if (!User.ROLE_ADMIN.equalsIgnoreCase(role) && !User.ROLE_STUDENT.equalsIgnoreCase(role) && !User.ROLE_COMPANY_HR.equalsIgnoreCase(role)) {
            throw new IllegalArgumentException("Invalid role specified.");
        }
        if (User.ROLE_COMPANY_HR.equalsIgnoreCase(role) && (companyId == null || companyId <= 0)) {
            throw new IllegalArgumentException("Company selection is required for Company HR accounts.");
        }

        try {
            if (userDAO.findByEmail(emailOrUsername.trim().toLowerCase()) != null) {
                throw new IllegalArgumentException(
                        "Account ID / Email '" + emailOrUsername + "' is already registered.");
            }

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(emailOrUsername.trim().toLowerCase());
            user.setPasswordHash(PasswordUtil.hashPassword(plainPassword));
            user.setRole(role.toUpperCase());
            user.setAccountStatus(ValidationUtil.isNotEmpty(status) ? status.toUpperCase() : User.STATUS_ACTIVE);
            if (User.ROLE_COMPANY_HR.equalsIgnoreCase(role)) {
                user.setCompanyId(companyId);
            }

            int userId = userDAO.create(user);
            if (userId <= 0) {
                throw new RuntimeException("Failed to create user record.");
            }
            user.setUserId(userId);
            logger.info("Admin created new user account '{}' with role {}", user.getEmail(), user.getRole());
            return user;
        } catch (SQLException e) {
            logger.error("Database error while creating user account: {}", e.getMessage());
            throw new RuntimeException("Database error creating user account: " + e.getMessage(), e);
        }
    }

    public boolean updatePassword(int userId, String plainPassword) {
        if (plainPassword == null || plainPassword.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters.");
        }
        try {
            return userDAO.updatePassword(userId, PasswordUtil.hashPassword(plainPassword));
        } catch (SQLException e) {
            logger.error("Error resetting password for user {}: {}", userId, e.getMessage());
            throw new RuntimeException("Could not reset password: " + e.getMessage(), e);
        }
    }

    public boolean deleteUser(int userId) {
        try {
            return userDAO.delete(userId);
        } catch (SQLException e) {
            logger.error("Error deleting user {}: {}", userId, e.getMessage());
            throw new RuntimeException("Could not delete user account: " + e.getMessage(), e);
        }
    }

    public boolean isEmailRegistered(String email) {
        try {
            return userDAO.findByEmail(email.trim().toLowerCase()) != null;
        } catch (SQLException e) {
            return false;
        }
    }
}
