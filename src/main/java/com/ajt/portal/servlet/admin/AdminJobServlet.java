package com.ajt.portal.servlet.admin;

import com.ajt.portal.model.Company;
import com.ajt.portal.model.Job;
import com.ajt.portal.service.CompanyService;
import com.ajt.portal.service.JobService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "AdminJobServlet", urlPatterns = {"/admin/jobs"})
public class AdminJobServlet extends HttpServlet {

    private final JobService jobService = new JobService();
    private final CompanyService companyService = new CompanyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String status = request.getParameter("status");

        List<Job> jobs = jobService.searchJobs(search, null, null, null, status, "latest");
        List<Company> companies = companyService.getAllCompanies(null);

        request.setAttribute("jobs", jobs);
        request.setAttribute("companies", companies);
        request.setAttribute("search", search);
        request.setAttribute("selectedStatus", status);

        request.getRequestDispatcher("/WEB-INF/views/admin/jobs.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                int companyId = Integer.parseInt(request.getParameter("companyId"));
                String jobTitle = request.getParameter("jobTitle");
                String description = request.getParameter("description");
                String location = request.getParameter("location");
                String minCgpaStr = request.getParameter("minimumCgpa");
                String eligibleBranch = request.getParameter("eligibleBranch");
                String deadlineStr = request.getParameter("deadline");
                String jobStatus = request.getParameter("jobStatus");

                BigDecimal minCgpa = (minCgpaStr != null && !minCgpaStr.trim().isEmpty())
                    ? new BigDecimal(minCgpaStr.trim()) : BigDecimal.ZERO;

                Job job = new Job();
                job.setCompanyId(companyId);
                job.setJobTitle(jobTitle);
                job.setDescription(description);
                job.setLocation(location);
                job.setMinimumCgpa(minCgpa);
                job.setEligibleBranch(eligibleBranch != null ? eligibleBranch : "All Branches");
                job.setDeadline(Date.valueOf(deadlineStr));
                job.setJobStatus(jobStatus != null ? jobStatus : Job.STATUS_ACTIVE);

                jobService.createJob(job);
                session.setAttribute("flashSuccess", "Job opening '" + jobTitle + "' posted successfully.");

            } else if ("edit".equalsIgnoreCase(action)) {
                int jobId = Integer.parseInt(request.getParameter("jobId"));
                int companyId = Integer.parseInt(request.getParameter("companyId"));
                String jobTitle = request.getParameter("jobTitle");
                String description = request.getParameter("description");
                String location = request.getParameter("location");
                String minCgpaStr = request.getParameter("minimumCgpa");
                String eligibleBranch = request.getParameter("eligibleBranch");
                String deadlineStr = request.getParameter("deadline");
                String jobStatus = request.getParameter("jobStatus");

                BigDecimal minCgpa = (minCgpaStr != null && !minCgpaStr.trim().isEmpty())
                    ? new BigDecimal(minCgpaStr.trim()) : BigDecimal.ZERO;

                Job job = new Job();
                job.setJobId(jobId);
                job.setCompanyId(companyId);
                job.setJobTitle(jobTitle);
                job.setDescription(description);
                job.setLocation(location);
                job.setMinimumCgpa(minCgpa);
                job.setEligibleBranch(eligibleBranch != null ? eligibleBranch : "All Branches");
                job.setDeadline(Date.valueOf(deadlineStr));
                job.setJobStatus(jobStatus != null ? jobStatus : Job.STATUS_ACTIVE);

                jobService.updateJob(job);
                session.setAttribute("flashSuccess", "Job opening updated successfully.");

            } else if ("toggleStatus".equalsIgnoreCase(action)) {
                int jobId = Integer.parseInt(request.getParameter("jobId"));
                String currentStatus = request.getParameter("currentStatus");
                String newStatus = Job.STATUS_ACTIVE.equalsIgnoreCase(currentStatus) ? Job.STATUS_CLOSED : Job.STATUS_ACTIVE;

                jobService.updateJobStatus(jobId, newStatus);
                session.setAttribute("flashSuccess", "Job status updated to " + newStatus + ".");

            } else if ("delete".equalsIgnoreCase(action)) {
                int jobId = Integer.parseInt(request.getParameter("jobId"));
                jobService.deleteJob(jobId);
                session.setAttribute("flashSuccess", "Job opening deleted successfully.");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("flashError", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("flashError", "Action failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/jobs");
    }
}

