package com.ajt.portal.servlet.auth;

import com.ajt.portal.model.Student;
import com.ajt.portal.model.User;
import com.ajt.portal.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession(false) != null && request.getSession(false).getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String enrollmentNumber = request.getParameter("enrollmentNumber");
        String branch = request.getParameter("branch");
        String semesterStr = request.getParameter("semester");
        String cgpaStr = request.getParameter("cgpa");
        String phone = request.getParameter("phone");

        // Retain values in case of error
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("enrollmentNumber", enrollmentNumber);
        request.setAttribute("branch", branch);
        request.setAttribute("semester", semesterStr);
        request.setAttribute("cgpa", cgpaStr);
        request.setAttribute("phone", phone);

        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("formError", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            return;
        }

        try {
            int semester = (semesterStr != null && !semesterStr.trim().isEmpty()) ? Integer.parseInt(semesterStr.trim()) : 0;
            BigDecimal cgpa = (cgpaStr != null && !cgpaStr.trim().isEmpty()) ? new BigDecimal(cgpaStr.trim()) : BigDecimal.ZERO;

            User user = new User();
            user.setFullName(fullName != null ? fullName.trim() : "");
            user.setEmail(email != null ? email.trim() : "");

            Student student = new Student();
            student.setEnrollmentNumber(enrollmentNumber != null ? enrollmentNumber.trim().toUpperCase() : "");
            student.setBranch(branch != null ? branch.trim() : "");
            student.setSemester(semester);
            student.setCgpa(cgpa);
            student.setPhone(phone != null ? phone.trim() : "");

            userService.registerStudent(user, student, password);

            request.getSession(true).setAttribute("flashSuccess", "Registration successful! You can now log in with your credentials.");
            response.sendRedirect(request.getContextPath() + "/login");

        } catch (NumberFormatException e) {
            request.setAttribute("formError", "Please enter valid numeric values for semester and CGPA.");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("formError", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("formError", "An unexpected error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }
}

