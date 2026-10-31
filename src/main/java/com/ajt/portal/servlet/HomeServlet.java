package com.ajt.portal.servlet;

import com.ajt.portal.model.Job;
import com.ajt.portal.service.CompanyService;
import com.ajt.portal.service.JobService;
import com.ajt.portal.service.StudentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private final JobService jobService = new JobService();
    private final StudentService studentService = new StudentService();
    private final CompanyService companyService = new CompanyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Job> featuredJobs = jobService.getFeaturedJobs(6);
            request.setAttribute("featuredJobs", featuredJobs);
            request.setAttribute("totalJobs", jobService.getActiveJobsCount());
            request.setAttribute("totalStudents", studentService.getTotalStudents());
            request.setAttribute("totalCompanies", companyService.getTotalCompanies());
        } catch (Exception e) {
            request.setAttribute("featuredJobs", List.of());
        }

        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }
}

