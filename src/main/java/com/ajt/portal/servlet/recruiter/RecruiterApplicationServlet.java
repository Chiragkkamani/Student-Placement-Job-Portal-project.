package com.ajt.portal.servlet.recruiter;

import com.ajt.portal.model.Application;
import com.ajt.portal.model.ApplicationStatusHistory;
import com.ajt.portal.model.Company;
import com.ajt.portal.model.Job;
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
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "RecruiterApplicationServlet", urlPatterns = {"/recruiter/applications"})
public class RecruiterApplicationServlet extends HttpServlet {

    private final ApplicationService applicationService = new ApplicationService();
    private final JobService jobService = new JobService();
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

        String action = request.getParameter("action");

        // AJAX request for history scoped to this company
        if ("history".equalsIgnoreCase(action)) {
            handleHistoryRequest(request, response, companyId);
            return;
        }

        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String jobIdStr = request.getParameter("jobId");

        Integer jobId = null;
        if (jobIdStr != null && !jobIdStr.trim().isEmpty()) {
            try {
                jobId = Integer.parseInt(jobIdStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        Company company = companyService.getCompanyById(companyId);
        List<Application> applications = applicationService.getCompanyApplications(companyId, search, status, jobId);
        List<Job> companyJobs = jobService.getJobsByCompany(companyId);

        request.setAttribute("company", company);
        request.setAttribute("applications", applications);
        request.setAttribute("companyJobs", companyJobs);
        request.setAttribute("search", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedJobId", jobId);
        request.setAttribute("activePage", "recruiter-applications");

        request.getRequestDispatcher("/WEB-INF/views/recruiter/applications.jsp").forward(request, response);
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

        String action = request.getParameter("action");

        try {
            if ("updateStatus".equalsIgnoreCase(action)) {
                int applicationId = Integer.parseInt(request.getParameter("applicationId"));
                String newStatus = request.getParameter("newStatus");
                String remarks = request.getParameter("remarks");

                applicationService.updateApplicationStatusForCompany(applicationId, companyId, newStatus, remarks, currentUser.getUserId());
                session.setAttribute("flashSuccess", "Applicant status updated to " + newStatus + ".");
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            session.setAttribute("flashError", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("flashError", "Failed to update candidate status: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/recruiter/applications");
    }

    private void handleHistoryRequest(HttpServletRequest request, HttpServletResponse response, int companyId) throws IOException {
        String appIdStr = request.getParameter("appId");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int appId = Integer.parseInt(appIdStr);
            // Verify ownership
            Application app = applicationService.getApplicationByIdAndCompany(appId, companyId);
            if (app == null) {
                out.print("[]");
                return;
            }

            List<ApplicationStatusHistory> history = applicationService.getApplicationHistory(appId);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < history.size(); i++) {
                ApplicationStatusHistory h = history.get(i);
                json.append("{")
                        .append("\"historyId\":").append(h.getHistoryId()).append(",")
                        .append("\"previousStatus\":\"").append(h.getPreviousStatus() != null ? h.getPreviousStatus() : "").append("\",")
                        .append("\"newStatus\":\"").append(h.getNewStatus()).append("\",")
                        .append("\"changedByName\":\"").append(h.getChangedByName() != null ? escapeJson(h.getChangedByName()) : "System").append("\",")
                        .append("\"changeTimestamp\":\"").append(h.getChangeTimestamp() != null ? h.getChangeTimestamp().toString() : "").append("\"")
                        .append("}");
                if (i < history.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            out.print(json.toString());
        } catch (Exception e) {
            out.print("[]");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}

