package com.ajt.portal.servlet.student;

import com.ajt.portal.model.Application;
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
import java.util.List;

@WebServlet(name = "MyApplicationsServlet", urlPatterns = {"/student/applications"})
public class MyApplicationsServlet extends HttpServlet {

    private final ApplicationService applicationService = new ApplicationService();
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        Student student = studentService.getStudentByUserId(currentUser.getUserId());
        if (student != null) {
            List<Application> applications = applicationService.getStudentApplications(student.getStudentId());
            request.setAttribute("applications", applications);
        }

        request.getRequestDispatcher("/WEB-INF/views/student/my-applications.jsp").forward(request, response);
    }
}

