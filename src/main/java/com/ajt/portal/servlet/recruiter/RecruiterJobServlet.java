package com.ajt.portal.servlet.recruiter;

import com.ajt.portal.model.Company;
import com.ajt.portal.model.Job;
import com.ajt.portal.model.User;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RecruiterJobServlet", urlPatterns = {"/recruiter/jobs"})
public class RecruiterJobServlet extends HttpServlet {

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

        Company company = companyService.getCompanyById(companyId);
        List<Job> allCompanyJobs = jobService.getJobsByCompany(companyId);

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        List<Job> filteredJobs = new ArrayList<>();
        int activeCount = 0;
        int closedCount = 0;

        for (Job j : allCompanyJobs) {
            if (Job.STATUS_ACTIVE.equalsIgnoreCase(j.getJobStatus())) {
                activeCount++;
            } else {
                closedCount++;
            }

            boolean matchesSearch = true;
            if (search != null && !search.trim().isEmpty()) {
                String q = search.trim().toLowerCase();
                matchesSearch = (j.getJobTitle() != null && j.getJobTitle().toLowerCase().contains(q))
                        || (j.getDescription() != null && j.getDescription().toLowerCase().contains(q))
                        || (j.getLocation() != null && j.getLocation().toLowerCase().contains(q));
            }

            boolean matchesStatus = (status == null || status.trim().isEmpty() || "ALL".equalsIgnoreCase(status)
                    || j.getJobStatus().equalsIgnoreCase(status.trim()));

            if (matchesSearch && matchesStatus) {
                filteredJobs.add(j);
            }
        }

        request.setAttribute("company", company);
        request.setAttribute("jobs", filteredJobs);
        request.setAttribute("totalJobs", allCompanyJobs.size());
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("closedCount", closedCount);
        request.setAttribute("search", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("activePage", "recruiter-jobs");

        request.getRequestDispatcher("/WEB-INF/views/recruiter/jobs.jsp").forward(request, response);
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
            if ("add".equalsIgnoreCase(action)) {
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
                // Strictly enforce companyId from authenticated session
                job.setCompanyId(companyId);
                job.setJobTitle(jobTitle);
                job.setDescription(description);
                job.setLocation(location);
                job.setMinimumCgpa(minCgpa);
                job.setEligibleBranch(eligibleBranch != null ? eligibleBranch : "All Branches");
                job.setDeadline(Date.valueOf(deadlineStr));
                job.setJobStatus(jobStatus != null ? jobStatus : Job.STATUS_ACTIVE);

                jobService.createJob(job);
                session.setAttribute("flashSuccess", "Recruitment drive '" + jobTitle + "' posted successfully for your company.");

            } else if ("edit".equalsIgnoreCase(action)) {
                int jobId = Integer.parseInt(request.getParameter("jobId"));

                // Verify job belongs to this recruiter's company
                Job existing = jobService.getJobByIdAndCompany(jobId, companyId);
                if (existing == null) {
                    throw new IllegalStateException("Security restriction: You cannot modify jobs belonging to another organization.");
                }

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

                jobService.updateJobForCompany(job, companyId);
                session.setAttribute("flashSuccess", "Job opening '" + jobTitle + "' updated successfully.");

            } else if ("toggleStatus".equalsIgnoreCase(action)) {
                int jobId = Integer.parseInt(request.getParameter("jobId"));
                Job existing = jobService.getJobByIdAndCompany(jobId, companyId);
                if (existing == null) {
                    throw new IllegalStateException("Security restriction: Job not found or belongs to another company.");
                }

                String currentStatus = request.getParameter("currentStatus");
                String newStatus = Job.STATUS_ACTIVE.equalsIgnoreCase(currentStatus) ? Job.STATUS_CLOSED : Job.STATUS_ACTIVE;

                jobService.updateJobStatusForCompany(jobId, companyId, newStatus);
                session.setAttribute("flashSuccess", "Job drive status updated to " + newStatus + ".");

            } else if ("delete".equalsIgnoreCase(action)) {
                int jobId = Integer.parseInt(request.getParameter("jobId"));
                Job existing = jobService.getJobByIdAndCompany(jobId, companyId);
                if (existing == null) {
                    throw new IllegalStateException("Security restriction: Job not found or belongs to another company.");
                }

                jobService.deleteJobForCompany(jobId, companyId);
                session.setAttribute("flashSuccess", "Job opening removed from your company listings.");
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            session.setAttribute("flashError", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("flashError", "Operation failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/recruiter/jobs");
    }
}

