package com.ajt.portal.servlet.recruiter;

import com.ajt.portal.model.Application;
import com.ajt.portal.model.Company;
import com.ajt.portal.model.DashboardStats;
import com.ajt.portal.model.User;
import com.ajt.portal.service.ApplicationService;
import com.ajt.portal.service.CompanyService;
import com.ajt.portal.service.JobService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RecruiterDashboardServlet", urlPatterns = {"/recruiter/dashboard"})
public class RecruiterDashboardServlet extends HttpServlet {

    private final JobService jobService = new JobService();
    private final ApplicationService applicationService = new ApplicationService();
    private final CompanyService companyService = new CompanyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null || !currentUser.isCompanyHr()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied: Recruiter authentication required.");
            return;
        }

        Integer companyId = currentUser.getCompanyId();
        if (companyId == null || companyId <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No company assigned to this HR profile.");
            return;
        }

        Company company = companyService.getCompanyById(companyId);
        int activeJobsCount = jobService.getActiveJobsCountByCompany(companyId);
        int totalJobsCount = jobService.getTotalJobsCountByCompany(companyId);
        DashboardStats appStats = applicationService.getCompanyApplicationStats(companyId);
        List<Application> recentApplications = applicationService.getRecentApplicationsForCompany(companyId, 6);

        request.setAttribute("company", company);
        request.setAttribute("activeJobsCount", activeJobsCount);
        request.setAttribute("totalJobsCount", totalJobsCount);
        request.setAttribute("appStats", appStats);
        request.setAttribute("recentApplications", recentApplications);
        request.setAttribute("activePage", "recruiter-dashboard");

        request.getRequestDispatcher("/WEB-INF/views/recruiter/dashboard.jsp").forward(request, response);
    }
}

