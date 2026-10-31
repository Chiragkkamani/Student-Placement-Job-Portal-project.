package com.ajt.portal.servlet.admin;

import com.ajt.portal.model.Student;
import com.ajt.portal.service.StudentService;
import com.ajt.portal.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminStudentServlet", urlPatterns = {"/admin/students"})
public class AdminStudentServlet extends HttpServlet {

    private final StudentService studentService = new StudentService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String branch = request.getParameter("branch");

        List<Student> students = studentService.getAllStudents(search, branch);
        request.setAttribute("students", students);
        request.setAttribute("search", search);
        request.setAttribute("selectedBranch", branch);

        request.getRequestDispatcher("/WEB-INF/views/admin/students.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        try {
            if ("toggleStatus".equalsIgnoreCase(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String currentStatus = request.getParameter("currentStatus");
                String newStatus = "ACTIVE".equalsIgnoreCase(currentStatus) ? "INACTIVE" : "ACTIVE";

                userService.updateUserStatus(userId, newStatus);
                session.setAttribute("flashSuccess", "Student account status updated to " + newStatus + ".");

            } else if ("delete".equalsIgnoreCase(action)) {
                int studentId = Integer.parseInt(request.getParameter("studentId"));
                studentService.deleteStudent(studentId);
                session.setAttribute("flashSuccess", "Student record successfully deleted.");
            }
        } catch (Exception e) {
            session.setAttribute("flashError", "Action failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/students");
    }
}

