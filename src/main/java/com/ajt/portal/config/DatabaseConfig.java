package com.ajt.portal.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.sql.DataSource;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class DatabaseConfig {

    private static final Logger logger = LoggerFactory.getLogger(DatabaseConfig.class);
    private static volatile HikariDataSource dataSource;
    private static final Object lock = new Object();

    private DatabaseConfig() {
    }

    public static DataSource getDataSource() {
        if (dataSource == null) {
            synchronized (lock) {
                if (dataSource == null) {
                    initDataSource();
                }
            }
        }
        return dataSource;
    }

    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    private static void initDataSource() {
        Properties props = loadMergedProperties();

        String host = getEnvOrProp("DB_HOST", "db.host", props, "localhost");
        String port = getEnvOrProp("DB_PORT", "db.port", props, "3306");
        String dbName = getEnvOrProp("DB_NAME", "db.name", props, "placement_portal");
        String user = getEnvOrProp("DB_USER", "db.user", props, "root");
        String password = getEnvOrProp("DB_PASSWORD", "db.password", props, "root");
        String maxPoolSize = getEnvOrProp("DB_POOL_SIZE", "db.pool.maximumPoolSize", props, "10");

        String jdbcUrl = String.format(
                "jdbc:mysql://%s:%s/%s?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&useSSL=false&allowPublicKeyRetrieval=true",
                host, port, dbName);

        logger.info("Attempting connection to MySQL DataSource at jdbc:mysql://{}:{}/{}", host, port, dbName);

        try {
            HikariConfig config = new HikariConfig();
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");
            config.setJdbcUrl(jdbcUrl);
            config.setUsername(user);
            config.setPassword(password);
            config.setMaximumPoolSize(Integer.parseInt(maxPoolSize));
            config.setMinimumIdle(1);
            config.setIdleTimeout(30000);
            config.setConnectionTimeout(3000); // 3-second quick failover if MySQL isn't running
            config.setPoolName("PlacementPortalMySQLPool");

            // MySQL optimizations
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            HikariDataSource testDs = new HikariDataSource(config);
            try (Connection conn = testDs.getConnection()) {
                logger.info("Successfully connected to MySQL database: {}", dbName);
                dataSource = testDs;
                return;
            }
        } catch (Exception e) {
            logger.warn(
                    "MySQL service not reachable on {}:{}. Switching to embedded zero-config database mode for seamless execution: {}",
                    host, port, e.getMessage());
            if (dataSource != null && !dataSource.isClosed()) {
                dataSource.close();
                dataSource = null;
            }
        }

        // Seamless Fallback: Embedded H2 database running in MySQL compatibility mode
        initEmbeddedFallback();
    }

    private static void initEmbeddedFallback() {
        try {
            logger.info("Initializing embedded standalone database with MySQL compatibility mode...");
            String dbDir = System.getProperty("user.home") + File.separator + ".placement_portal_data";
            File dir = new File(dbDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String dbFilePath = dbDir + File.separator + "portal";
            String h2Url = "jdbc:h2:" + dbFilePath
                    + ";MODE=MySQL;DATABASE_TO_LOWER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE;AUTO_SERVER=TRUE";

            HikariConfig config = new HikariConfig();
            config.setDriverClassName("org.h2.Driver");
            config.setJdbcUrl(h2Url);
            config.setUsername("sa");
            config.setPassword("");
            config.setMaximumPoolSize(10);
            config.setPoolName("PlacementPortalEmbeddedPool");

            dataSource = new HikariDataSource(config);

            // Execute schema and seed data
            try (Connection conn = dataSource.getConnection()) {
                executeInitScript(conn);
            }

            logger.info("Standalone embedded database ready at {}", dbFilePath);
        } catch (Exception e) {
            logger.error("Failed to initialize embedded database: {}", e.getMessage(), e);
            throw new RuntimeException("Database initialization failure: " + e.getMessage(), e);
        }
    }

    private static void executeInitScript(Connection conn) {
        try (InputStream is = DatabaseConfig.class.getClassLoader().getResourceAsStream("schema_init.sql")) {
            if (is == null) {
                logger.warn("schema_init.sql not found on classpath.");
                return;
            }
            String script = new String(is.readAllBytes(), StandardCharsets.UTF_8);
            String cleanScript = script.replaceAll("(?m)^--.*$", "");
            String[] statements = cleanScript.split(";");
            try (Statement stmt = conn.createStatement()) {
                for (String sql : statements) {
                    String trimmed = sql.trim();
                    if (!trimmed.isEmpty()) {
                        try {
                            stmt.execute(trimmed);
                        } catch (SQLException ex) {
                            logger.warn("Statement execution warning: {} for SQL: {}", ex.getMessage(), trimmed);
                        }
                    }
                }
            }
            logger.info("Database schema and seed data initialized successfully.");
        } catch (Exception e) {
            logger.error("Error running schema_init.sql: {}", e.getMessage(), e);
        }
    }

    public static void setCustomDataSource(HikariDataSource customDs) {
        synchronized (lock) {
            if (dataSource != null && !dataSource.isClosed()) {
                dataSource.close();
            }
            dataSource = customDs;
        }
    }

    public static void shutdown() {
        synchronized (lock) {
            if (dataSource != null && !dataSource.isClosed()) {
                logger.info("Closing database connection pool.");
                dataSource.close();
                dataSource = null;
            }
        }
    }

    private static String getEnvOrProp(String envKey, String propKey, Properties props, String defaultValue) {
        String envVal = System.getenv(envKey);
        if (envVal != null && !envVal.trim().isEmpty()) {
            return envVal.trim();
        }
        String sysProp = System.getProperty(envKey);
        if (sysProp != null && !sysProp.trim().isEmpty()) {
            return sysProp.trim();
        }
        String propVal = props.getProperty(propKey);
        if (propVal != null && !propVal.trim().isEmpty()) {
            return propVal.trim();
        }
        return defaultValue;
    }

    private static Properties loadMergedProperties() {
        Properties props = new Properties();
        try (InputStream is = DatabaseConfig.class.getClassLoader().getResourceAsStream("portal.properties")) {
            if (is != null) {
                props.load(is);
            }
        } catch (Exception ignored) {
        }

        File envFile = new File(".env");
        if (envFile.exists() && envFile.isFile()) {
            try (FileInputStream fis = new FileInputStream(envFile)) {
                Properties envProps = new Properties();
                envProps.load(fis);
                props.putAll(envProps);
            } catch (Exception ignored) {
            }
        }

        return props;
    }
}
