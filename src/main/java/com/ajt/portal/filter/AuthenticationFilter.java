package com.ajt.portal.filter;

import com.ajt.portal.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = { "/student/*", "/admin/*", "/recruiter/*" })
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            // Save requested URL for redirect after login
            if (session == null) {
                session = httpRequest.getSession(true);
            }
            String targetUri = httpRequest.getRequestURI();
            if (httpRequest.getQueryString() != null) {
                targetUri += "?" + httpRequest.getQueryString();
            }
            session.setAttribute("redirectAfterLogin", targetUri);
            session.setAttribute("flashError", "Please sign in to access that page.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}
