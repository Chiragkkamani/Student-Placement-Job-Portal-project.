package com.ajt.portal.servlet.jobs;

import com.ajt.portal.model.Job;
import com.ajt.portal.model.Student;
import com.ajt.portal.model.User;
import com.ajt.portal.service.JobService;
import com.ajt.portal.service.StudentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "JobListServlet", urlPatterns = {"/jobs"})
public class JobListServlet extends HttpServlet {

    private final JobService jobService = new JobService();
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("q");
        String location = request.getParameter("location");
        String branch = request.getParameter("branch");
        String minCgpaStr = request.getParameter("minCgpa");
        String status = request.getParameter("status");
        String sortBy = request.getParameter("sortBy");

        BigDecimal minCgpa = null;
        if (minCgpaStr != null && !minCgpaStr.trim().isEmpty()) {
            try {
                minCgpa = new BigDecimal(minCgpaStr.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        // Default to ACTIVE jobs for public listing unless explicitly requested
        if (status == null || status.trim().isEmpty()) {
            status = "ACTIVE";
        }

        List<Job> jobs = jobService.searchJobs(search, location, branch, minCgpa, status, sortBy);

        int pageSize = 6;
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam.trim());
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException ignored) {
            }
        }
        int totalJobs = jobs != null ? jobs.size() : 0;
        int totalPages = totalJobs > 0 ? (int) Math.ceil((double) totalJobs / pageSize) : 1;
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        // If a student is logged in, attach their applied status
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user.isStudent()) {
                Student student = (Student) session.getAttribute("currentStudent");
                if (student == null) {
                    student = studentService.getStudentByUserId(user.getUserId());
                    session.setAttribute("currentStudent", student);
                }
                if (student != null) {
                    request.setAttribute("studentProfile", student);
                }
            }
        }

        request.setAttribute("jobs", jobs);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalJobsCount", totalJobs);
        request.setAttribute("query", search);
        request.setAttribute("selectedLocation", location);
        request.setAttribute("selectedBranch", branch);
        request.setAttribute("selectedCgpa", minCgpaStr);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedSort", sortBy);

        request.getRequestDispatcher("/WEB-INF/views/jobs/browse.jsp").forward(request, response);
    }
}

