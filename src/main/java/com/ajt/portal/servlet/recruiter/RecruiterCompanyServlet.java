package com.ajt.portal.servlet.recruiter;

import com.ajt.portal.model.Company;
import com.ajt.portal.model.User;
import com.ajt.portal.service.CompanyService;
import com.ajt.portal.service.JobService;
import com.ajt.portal.service.ApplicationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "RecruiterCompanyServlet", urlPatterns = {"/recruiter/company"})
public class RecruiterCompanyServlet extends HttpServlet {

    private final CompanyService companyService = new CompanyService();
    private final JobService jobService = new JobService();
    private final ApplicationService applicationService = new ApplicationService();

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
        int totalJobs = jobService.getTotalJobsCountByCompany(companyId);
        int activeJobs = jobService.getActiveJobsCountByCompany(companyId);
        int totalApplicants = applicationService.getCompanyApplicationStats(companyId).getTotalApplications();

        request.setAttribute("company", company);
        request.setAttribute("totalJobs", totalJobs);
        request.setAttribute("activeJobs", activeJobs);
        request.setAttribute("totalApplicants", totalApplicants);
        request.setAttribute("activePage", "recruiter-company");

        request.getRequestDispatcher("/WEB-INF/views/recruiter/company.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        try {
            String companyName = request.getParameter("companyName");
            String industry = request.getParameter("industry");
            String location = request.getParameter("location");
            String website = request.getParameter("website");
            String contactEmail = request.getParameter("contactEmail");

            Company c = new Company(companyName, industry, location, website, contactEmail);
            c.setCompanyId(companyId);

            companyService.updateCompany(c);

            // Update session cache so navbar immediately reflects any updated company name
            currentUser.setCompanyName(companyName);
            session.setAttribute("currentUser", currentUser);

            session.setAttribute("flashSuccess", "Company profile details for '" + companyName + "' updated successfully.");
        } catch (IllegalArgumentException e) {
            session.setAttribute("flashError", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("flashError", "Failed to update company details: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/recruiter/company");
    }
}
