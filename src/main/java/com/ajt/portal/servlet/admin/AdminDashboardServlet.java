package com.ajt.portal.servlet.admin;

import com.ajt.portal.model.Application;
import com.ajt.portal.model.DashboardStats;
import com.ajt.portal.service.ApplicationService;
import com.ajt.portal.service.DashboardService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    private final DashboardService dashboardService = new DashboardService();
    private final ApplicationService applicationService = new ApplicationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DashboardStats stats = dashboardService.getAdminDashboardStats();
        List<Application> recentApplications = applicationService.getRecentApplications(6);

        request.setAttribute("stats", stats);
        request.setAttribute("recentApplications", recentApplications);
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}

