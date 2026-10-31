package com.ajt.portal.config;

import com.ajt.portal.dao.UserDAO;
import com.ajt.portal.model.User;
import com.ajt.portal.util.PasswordUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger logger = LoggerFactory.getLogger(AppContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Initializing Placement Portal Application context...");

        // Ensure upload directory exists
        String realPath = sce.getServletContext().getRealPath("/uploads/resumes");
        if (realPath != null) {
            File uploadDir = new File(realPath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                logger.info("Upload directory created at {}: {}", realPath, created);
            }
        }

        // Initialize first admin if none exists
        initDefaultAdmin();

        logger.info("Placement Portal Application initialized successfully.");
    }

    private void initDefaultAdmin() {
        try {
            UserDAO userDAO = new UserDAO();
            
            // Ensure chiragadmin exists
            User chiragAdmin = userDAO.findByEmail("chiragadmin");
            if (chiragAdmin == null) {
                chiragAdmin = new User();
                chiragAdmin.setFullName("Chirag Administrator");
                chiragAdmin.setEmail("chiragadmin");
                chiragAdmin.setPasswordHash(PasswordUtil.hashPassword("chirag@123"));
                chiragAdmin.setRole(User.ROLE_ADMIN);
                chiragAdmin.setAccountStatus(User.STATUS_ACTIVE);
                userDAO.create(chiragAdmin);
                logger.info("Chirag admin user initialized: chiragadmin");
            } else {
                userDAO.updatePassword(chiragAdmin.getUserId(), PasswordUtil.hashPassword("chirag@123"));
                logger.info("Chirag admin password synchronized: chiragadmin");
            }

            // Ensure default admin exists
            String adminEmail = System.getenv("INITIAL_ADMIN_EMAIL");
            if (adminEmail == null || adminEmail.trim().isEmpty()) {
                adminEmail = "admin@placement.edu";
            }

            User existing = userDAO.findByEmail(adminEmail);
            if (existing == null) {
                User admin = new User();
                admin.setFullName("Placement Administrator");
                admin.setEmail(adminEmail);
                admin.setPasswordHash(PasswordUtil.hashPassword("chirag@123"));
                admin.setRole(User.ROLE_ADMIN);
                admin.setAccountStatus(User.STATUS_ACTIVE);

                userDAO.create(admin);
                logger.info("Initial admin user initialized: {}", adminEmail);
            } else {
                userDAO.updatePassword(existing.getUserId(), PasswordUtil.hashPassword("chirag@123"));
                logger.info("Admin user password synchronized: {}", adminEmail);
            }
        } catch (Exception e) {
            logger.warn("Could not check/initialize default admin during startup: {}", e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Destroying Placement Portal Application context...");
        DatabaseConfig.shutdown();
        logger.info("Placement Portal Application context destroyed.");
    }
}

