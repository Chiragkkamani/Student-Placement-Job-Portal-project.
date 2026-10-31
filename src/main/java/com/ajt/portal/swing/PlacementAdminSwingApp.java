package com.ajt.portal.swing;

import com.ajt.portal.config.DatabaseConfig;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Advanced Java Technologies (AJT) - Java Swing Desktop Client
 * 
 * Demonstrates the 2-Tier Desktop Counterpart of the Placement Portal.
 * Allows a Placement Officer to connect directly via JDBC to view students,
 * companies, and active placement drives in a native desktop GUI.
 */
public class PlacementAdminSwingApp extends JFrame {

    private JTable tableStudents;
    private JTable tableJobs;
    private DefaultTableModel studentModel;
    private DefaultTableModel jobModel;
    private JLabel statusLabel;

    public PlacementAdminSwingApp() {
        setTitle("Student Placement Portal - AJT Desktop Administration Console (Swing)");
        setSize(950, 650);
        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        setLocationRelativeTo(null);

        initComponents();
        loadDatabaseData();
    }

    private void initComponents() {
        // Main container with BorderLayout
        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(new EmptyBorder(15, 15, 15, 15));
        mainPanel.setBackground(new Color(245, 247, 250));

        // Header Banner
        JPanel headerPanel = new JPanel(new BorderLayout());
        headerPanel.setBackground(new Color(13, 110, 253));
        headerPanel.setBorder(new EmptyBorder(12, 16, 12, 16));

        JLabel titleLabel = new JLabel("AJT Campus Placement Console");
        titleLabel.setFont(new Font("Segoe UI", Font.BOLD, 18));
        titleLabel.setForeground(Color.WHITE);

        JLabel subtitleLabel = new JLabel("Java Swing Desktop Implementation | Connected to MySQL / Embedded Store");
        subtitleLabel.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        subtitleLabel.setForeground(new Color(222, 235, 255));

        headerPanel.add(titleLabel, BorderLayout.NORTH);
        headerPanel.add(subtitleLabel, BorderLayout.SOUTH);
        mainPanel.add(headerPanel, BorderLayout.NORTH);

        // Tabbed Pane for Multi-View Navigation
        JTabbedPane tabbedPane = new JTabbedPane();
        tabbedPane.setFont(new Font("Segoe UI", Font.BOLD, 13));

        // Tab 1: Students Table
        studentModel = new DefaultTableModel(new String[]{"ID", "Name", "Enrollment No", "Branch", "Semester", "CGPA", "Phone"}, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        tableStudents = new JTable(studentModel);
        tableStudents.setRowHeight(24);
        tableStudents.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        tableStudents.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));
        JScrollPane scrollStudents = new JScrollPane(tableStudents);
        tabbedPane.addTab("Registered Students", scrollStudents);

        // Tab 2: Jobs Table
        jobModel = new DefaultTableModel(new String[]{"Job ID", "Job Title", "Company", "Location", "Min CGPA", "Branch", "Deadline", "Status"}, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        tableJobs = new JTable(jobModel);
        tableJobs.setRowHeight(24);
        tableJobs.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        tableJobs.getTableHeader().setFont(new Font("Segoe UI", Font.BOLD, 12));
        JScrollPane scrollJobs = new JScrollPane(tableJobs);
        tabbedPane.addTab("Campus Job Drives", scrollJobs);

        mainPanel.add(tabbedPane, BorderLayout.CENTER);

        // Bottom Control Panel
        JPanel bottomPanel = new JPanel(new BorderLayout(10, 5));
        bottomPanel.setBackground(new Color(245, 247, 250));

        statusLabel = new JLabel("Ready. Connecting to JDBC datasource...");
        statusLabel.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        statusLabel.setForeground(new Color(108, 117, 125));

        JPanel buttonBar = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 0));
        buttonBar.setBackground(new Color(245, 247, 250));

        JButton btnRefresh = new JButton("Refresh Data");
        btnRefresh.setFont(new Font("Segoe UI", Font.BOLD, 12));
        btnRefresh.setBackground(new Color(13, 110, 253));
        btnRefresh.setForeground(Color.WHITE);
        btnRefresh.setFocusPainted(false);
        btnRefresh.addActionListener(e -> loadDatabaseData());

        JButton btnClose = new JButton("Close Window");
        btnClose.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        btnClose.addActionListener(e -> dispose());

        buttonBar.add(btnRefresh);
        buttonBar.add(btnClose);

        bottomPanel.add(statusLabel, BorderLayout.WEST);
        bottomPanel.add(buttonBar, BorderLayout.EAST);
        mainPanel.add(bottomPanel, BorderLayout.SOUTH);

        setContentPane(mainPanel);
    }

    public void loadDatabaseData() {
        studentModel.setRowCount(0);
        jobModel.setRowCount(0);

        try (Connection conn = DatabaseConfig.getConnection()) {
            // Load Students via JDBC PreparedStatement
            String sqlStudents = "SELECT s.student_id, u.full_name, s.enrollment_number, s.branch, s.semester, s.cgpa, s.phone " +
                                 "FROM students s JOIN users u ON s.user_id = u.user_id ORDER BY s.student_id ASC";
            try (PreparedStatement stmt = conn.prepareStatement(sqlStudents);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    studentModel.addRow(new Object[]{
                            rs.getInt(1),
                            rs.getString(2),
                            rs.getString(3),
                            rs.getString(4),
                            rs.getInt(5),
                            rs.getBigDecimal(6),
                            rs.getString(7)
                    });
                }
            }

            // Load Jobs via JDBC PreparedStatement
            String sqlJobs = "SELECT j.job_id, j.job_title, c.company_name, j.location, j.minimum_cgpa, j.eligible_branch, j.deadline, j.job_status " +
                             "FROM jobs j JOIN companies c ON j.company_id = c.company_id ORDER BY j.job_id ASC";
            try (PreparedStatement stmt = conn.prepareStatement(sqlJobs);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    jobModel.addRow(new Object[]{
                            rs.getInt(1),
                            rs.getString(2),
                            rs.getString(3),
                            rs.getString(4),
                            rs.getBigDecimal(5),
                            rs.getString(6),
                            rs.getDate(7),
                            rs.getString(8)
                    });
                }
            }

            statusLabel.setText("Database synchronized. Loaded " + studentModel.getRowCount() + " students, " + jobModel.getRowCount() + " job openings.");
            statusLabel.setForeground(new Color(25, 135, 84));

        } catch (SQLException e) {
            statusLabel.setText("JDBC Error: " + e.getMessage());
            statusLabel.setForeground(new Color(220, 53, 69));
            JOptionPane.showMessageDialog(this, "Could not fetch data from database: " + e.getMessage(), "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            PlacementAdminSwingApp app = new PlacementAdminSwingApp();
            app.setVisible(true);
        });
    }
}

