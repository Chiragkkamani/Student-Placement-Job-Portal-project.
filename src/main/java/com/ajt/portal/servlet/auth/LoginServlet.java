package com.ajt.portal.servlet.auth;

import com.ajt.portal.model.Student;
import com.ajt.portal.model.User;
import com.ajt.portal.service.StudentService;
import com.ajt.portal.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final StudentService studentService = new StudentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            }
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String identifier = request.getParameter("email");
        if (identifier == null || identifier.trim().isEmpty()) {
            identifier = request.getParameter("identifier");
        }
        String password = request.getParameter("password");

        try {
            User user = userService.authenticate(identifier, password);
            if (user == null) {
                request.getSession(true).setAttribute("flashError", "Invalid username/email or password. Please try again.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Secure session management: regenerate session ID to prevent session fixation attacks
            request.changeSessionId();
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);

            if (user.isStudent()) {
                Student student = studentService.getStudentByUserId(user.getUserId());
                session.setAttribute("currentStudent", student);
            }

            session.setAttribute("flashSuccess", "Welcome back, " + user.getFullName() + "!");

            // Check if there was a redirected URL saved
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectUrl);
                return;
            }

            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            }

        } catch (IllegalStateException e) {
            request.getSession(true).setAttribute("flashError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/login");
        } catch (Exception e) {
            request.getSession(true).setAttribute("flashError", "An unexpected error occurred during login: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}

