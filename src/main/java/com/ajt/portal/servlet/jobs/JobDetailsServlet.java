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

@WebServlet(name = "JobDetailsServlet", urlPatterns = {"/jobs/details"})
public class JobDetailsServlet extends HttpServlet {

    private final JobService jobService = new JobService();
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        int jobId;
        try {
            jobId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/jobs");
            return;
        }

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        Job job = null;
        Student student = null;

        if (currentUser != null && currentUser.isStudent()) {
            student = (Student) session.getAttribute("currentStudent");
            if (student == null) {
                student = studentService.getStudentByUserId(currentUser.getUserId());
                session.setAttribute("currentStudent", student);
            }
            if (student != null) {
                job = jobService.getJobByIdForStudent(jobId, student.getStudentId());
                boolean isEligible = job != null && job.isEligible(student);
                request.setAttribute("isEligible", isEligible);
                request.setAttribute("studentProfile", student);
            }
        }

        if (job == null) {
            job = jobService.getJobById(jobId);
        }

        if (job == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            request.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(request, response);
            return;
        }

        request.setAttribute("job", job);
        request.getRequestDispatcher("/WEB-INF/views/jobs/details.jsp").forward(request, response);
    }
}

