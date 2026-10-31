package com.ajt.portal.servlet.student;

import com.ajt.portal.model.Student;
import com.ajt.portal.model.User;
import com.ajt.portal.service.ApplicationService;
import com.ajt.portal.service.StudentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ApplyJobServlet", urlPatterns = {"/student/apply"})
public class ApplyJobServlet extends HttpServlet {

    private final ApplicationService applicationService = new ApplicationService();
    private final StudentService studentService = new StudentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        Student student = studentService.getStudentByUserId(currentUser.getUserId());
        if (student == null) {
            session.setAttribute("flashError", "Student profile not found. Please complete your profile first.");
            response.sendRedirect(request.getContextPath() + "/student/profile");
            return;
        }

        String jobIdStr = request.getParameter("jobId");
        String remarks = request.getParameter("remarks");

        int jobId;
        try {
            jobId = Integer.parseInt(jobIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Invalid job selection.");
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        try {
            applicationService.applyForJob(student.getStudentId(), jobId, remarks);
            session.setAttribute("flashSuccess", "Application submitted successfully! Track its status below.");
            response.sendRedirect(request.getContextPath() + "/student/applications");
        } catch (IllegalStateException | IllegalArgumentException e) {
            session.setAttribute("flashError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/jobs/details?id=" + jobId);
        } catch (Exception e) {
            session.setAttribute("flashError", "An unexpected error occurred while submitting your application: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/jobs/details?id=" + jobId);
        }
    }
}

