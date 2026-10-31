package com.ajt.portal.servlet.student;

import com.ajt.portal.model.Application;
import com.ajt.portal.model.DashboardStats;
import com.ajt.portal.model.Job;
import com.ajt.portal.model.Student;
import com.ajt.portal.model.User;
import com.ajt.portal.service.ApplicationService;
import com.ajt.portal.service.DashboardService;
import com.ajt.portal.service.JobService;
import com.ajt.portal.service.StudentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/student/dashboard"})
public class StudentDashboardServlet extends HttpServlet {

    private final StudentService studentService = new StudentService();
    private final DashboardService dashboardService = new DashboardService();
    private final ApplicationService applicationService = new ApplicationService();
    private final JobService jobService = new JobService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        Student student = studentService.getStudentByUserId(currentUser.getUserId());
        session.setAttribute("currentStudent", student);

        if (student != null) {
            DashboardStats stats = dashboardService.getStudentDashboardStats(student);
            List<Application> recentApplications = applicationService.getStudentApplications(student.getStudentId());
            if (recentApplications.size() > 5) {
                recentApplications = recentApplications.subList(0, 5);
            }
            List<Job> recommendedJobs = jobService.getRecommendedJobsForStudent(student, 4);

            request.setAttribute("stats", stats);
            request.setAttribute("recentApplications", recentApplications);
            request.setAttribute("recommendedJobs", recommendedJobs);
        }

        request.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(request, response);
    }
}

