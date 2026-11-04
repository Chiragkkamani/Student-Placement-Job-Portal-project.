package com.ajt.portal.filter;

import com.ajt.portal.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/admin/*", "/student/*", "/recruiter/*"})
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        if (path.startsWith("/admin/") && !currentUser.isAdmin()) {
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            httpRequest.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(httpRequest, httpResponse);
            return;
        }

        if (path.startsWith("/student/") && !currentUser.isStudent()) {
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            httpRequest.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(httpRequest, httpResponse);
            return;
        }

        if (path.startsWith("/recruiter/") && !currentUser.isCompanyHr() && !currentUser.isAdmin()) {
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            httpRequest.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(httpRequest, httpResponse);
            return;
        }

        chain.doFilter(request, response);
    }
}

