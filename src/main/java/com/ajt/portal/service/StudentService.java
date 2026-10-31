package com.ajt.portal.service;

import com.ajt.portal.dao.StudentDAO;
import com.ajt.portal.dao.UserDAO;
import com.ajt.portal.model.Student;
import com.ajt.portal.model.User;
import com.ajt.portal.util.ValidationUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;
import java.util.List;

public class StudentService {

    private static final Logger logger = LoggerFactory.getLogger(StudentService.class);

    private final StudentDAO studentDAO;
    private final UserDAO userDAO;

    public StudentService() {
        this.studentDAO = new StudentDAO();
        this.userDAO = new UserDAO();
    }

    public StudentService(StudentDAO studentDAO, UserDAO userDAO) {
        this.studentDAO = studentDAO;
        this.userDAO = userDAO;
    }

    public Student getStudentByUserId(int userId) {
        try {
            return studentDAO.findByUserId(userId);
        } catch (SQLException e) {
            logger.error("Error retrieving student by user id {}: {}", userId, e.getMessage());
            throw new RuntimeException("Could not retrieve student profile.", e);
        }
    }

    public Student getStudentById(int studentId) {
        try {
            return studentDAO.findById(studentId);
        } catch (SQLException e) {
            logger.error("Error retrieving student by id {}: {}", studentId, e.getMessage());
            throw new RuntimeException("Could not retrieve student details.", e);
        }
    }

    public boolean updateProfile(Student student, String fullName, String email) throws IllegalArgumentException {
        if (!ValidationUtil.isNotEmpty(fullName)) {
            throw new IllegalArgumentException("Full name cannot be empty.");
        }
        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email format.");
        }
        if (!ValidationUtil.isNotEmpty(student.getBranch())) {
            throw new IllegalArgumentException("Branch is required.");
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

        try {
            // Update User details
            User user = userDAO.findById(student.getUserId());
            if (user != null) {
                user.setFullName(fullName.trim());
                user.setEmail(email.trim().toLowerCase());
                userDAO.update(user);
            }

            // Update Student details
            return studentDAO.update(student);
        } catch (SQLException e) {
            logger.error("Error updating student profile: {}", e.getMessage());
            throw new RuntimeException("Could not update student profile: " + e.getMessage(), e);
        }
    }

    public boolean updateResume(int studentId, String resumePath) {
        try {
            return studentDAO.updateResumePath(studentId, resumePath);
        } catch (SQLException e) {
            logger.error("Error updating resume path for student {}: {}", studentId, e.getMessage());
            throw new RuntimeException("Could not update resume path.", e);
        }
    }

    public List<Student> getAllStudents(String search, String branch) {
        try {
            return studentDAO.getAllStudents(search, branch);
        } catch (SQLException e) {
            logger.error("Error fetching students: {}", e.getMessage());
            throw new RuntimeException("Could not fetch students list.", e);
        }
    }

    public boolean deleteStudent(int studentId) {
        try {
            return studentDAO.delete(studentId);
        } catch (SQLException e) {
            logger.error("Error deleting student {}: {}", studentId, e.getMessage());
            throw new RuntimeException("Could not delete student record.", e);
        }
    }

    public int getTotalStudents() {
        try {
            return studentDAO.getTotalStudentCount();
        } catch (SQLException e) {
            return 0;
        }
    }
}

