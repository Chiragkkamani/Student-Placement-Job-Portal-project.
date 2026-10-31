package com.ajt.portal.servlet.admin;

import com.ajt.portal.model.Application;
import com.ajt.portal.model.ApplicationStatusHistory;
import com.ajt.portal.model.Job;
import com.ajt.portal.model.User;
import com.ajt.portal.service.ApplicationService;
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

@WebServlet(name = "AdminApplicationServlet", urlPatterns = {"/admin/applications"})
public class AdminApplicationServlet extends HttpServlet {

    private final ApplicationService applicationService = new ApplicationService();
    private final JobService jobService = new JobService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // AJAX request for history
        if ("history".equalsIgnoreCase(action)) {
            handleHistoryRequest(request, response);
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

        List<Application> applications = applicationService.getAllApplications(search, status, jobId);
        List<Job> allJobs = jobService.searchJobs(null, null, null, null, null, "latest");

        request.setAttribute("applications", applications);
        request.setAttribute("allJobs", allJobs);
        request.setAttribute("search", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedJobId", jobId);

        request.getRequestDispatcher("/WEB-INF/views/admin/applications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        String action = request.getParameter("action");

        try {
            if ("updateStatus".equalsIgnoreCase(action)) {
                int applicationId = Integer.parseInt(request.getParameter("applicationId"));
                String newStatus = request.getParameter("newStatus");
                String remarks = request.getParameter("remarks");

                applicationService.updateApplicationStatus(applicationId, newStatus, remarks, currentUser.getUserId());
                session.setAttribute("flashSuccess", "Application status successfully updated to " + newStatus + ".");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("flashError", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("flashError", "Failed to update status: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/applications");
    }

    private void handleHistoryRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String appIdStr = request.getParameter("appId");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int appId = Integer.parseInt(appIdStr);
            List<ApplicationStatusHistory> history = applicationService.getApplicationHistory(appId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < history.size(); i++) {
                ApplicationStatusHistory h = history.get(i);
                json.append("{")
                    .append("\"historyId\":").append(h.getHistoryId()).append(",")
                    .append("\"previousStatus\":\"").append(h.getPreviousStatus() != null ? h.getPreviousStatus() : "").append("\",")
                    .append("\"newStatus\":\"").append(h.getNewStatus()).append("\",")
                    .append("\"changedByName\":\"").append(h.getChangedByName() != null ? h.getChangedByName() : "System").append("\",")
                    .append("\"timestamp\":\"").append(h.getChangeTimestamp() != null ? h.getChangeTimestamp().toString() : "").append("\"")
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
        out.flush();
    }
}

