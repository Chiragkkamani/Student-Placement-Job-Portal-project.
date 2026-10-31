package com.ajt.portal.servlet.student;

import com.ajt.portal.model.Student;
import com.ajt.portal.model.User;
import com.ajt.portal.service.StudentService;
import com.ajt.portal.service.UserService;
import com.ajt.portal.util.FileUploadUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "StudentProfileServlet", urlPatterns = {"/student/profile"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 5,         // 5 MB
    maxRequestSize = 1024 * 1024 * 10     // 10 MB
)
public class StudentProfileServlet extends HttpServlet {

    private final StudentService studentService = new StudentService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        Student student = studentService.getStudentByUserId(currentUser.getUserId());
        request.setAttribute("student", student);
        request.getRequestDispatcher("/WEB-INF/views/student/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        Student student = studentService.getStudentByUserId(currentUser.getUserId());

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
            return;
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String branch = request.getParameter("branch");
        String semesterStr = request.getParameter("semester");
        String cgpaStr = request.getParameter("cgpa");
        String phone = request.getParameter("phone");

        try {
            int semester = (semesterStr != null && !semesterStr.trim().isEmpty()) ? Integer.parseInt(semesterStr.trim()) : student.getSemester();
            BigDecimal cgpa = (cgpaStr != null && !cgpaStr.trim().isEmpty()) ? new BigDecimal(cgpaStr.trim()) : student.getCgpa();

            student.setBranch(branch != null ? branch.trim() : student.getBranch());
            student.setSemester(semester);
            student.setCgpa(cgpa);
            student.setPhone(phone != null ? phone.trim() : student.getPhone());

            // Handle optional resume upload
            Part resumePart = null;
            try {
                resumePart = request.getPart("resumeFile");
            } catch (Exception ignored) {
            }

            if (resumePart != null && resumePart.getSize() > 0) {
                String uploadDir = getServletContext().getRealPath("/uploads/resumes");
                String relativePath = FileUploadUtil.saveResume(resumePart, uploadDir);
                if (relativePath != null) {
                    student.setResumePath(relativePath);
                }
            }

            studentService.updateProfile(student, fullName, email);

            // Refresh user and student in session
            User updatedUser = userService.getUserById(currentUser.getUserId());
            session.setAttribute("currentUser", updatedUser);
            session.setAttribute("currentStudent", studentService.getStudentById(student.getStudentId()));

            session.setAttribute("flashSuccess", "Profile updated successfully!");
            response.sendRedirect(request.getContextPath() + "/student/profile");

        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Please provide valid numbers for semester and CGPA.");
            response.sendRedirect(request.getContextPath() + "/student/profile");
        } catch (IllegalArgumentException e) {
            session.setAttribute("flashError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/student/profile");
        } catch (Exception e) {
            session.setAttribute("flashError", "Failed to update profile: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/student/profile");
        }
    }
}

