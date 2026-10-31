package com.ajt.portal.filter;

import com.ajt.portal.util.CsrfUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "CsrfFilter", urlPatterns = {"/*"})
public class CsrfFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(true);
        // Ensure a CSRF token always exists in the session under both keys
        String token = CsrfUtil.getOrCreateToken(session);
        session.setAttribute("csrfToken", token);
        session.setAttribute("CSRF_TOKEN", token);
        httpRequest.setAttribute("csrfToken", token);
        httpRequest.setAttribute("CSRF_TOKEN", token);

        String method = httpRequest.getMethod();
        if ("POST".equalsIgnoreCase(method) || "PUT".equalsIgnoreCase(method) || "DELETE".equalsIgnoreCase(method)) {
            String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

            // Exclude public authentication endpoints from CSRF check to prevent edge cases with initial cookies
            boolean isAuthEndpoint = path.equals("/login") || path.equals("/register");

            if (!isAuthEndpoint) {
                // If it's multipart (file upload), parts can be processed by servlet, or header checked
                String contentType = httpRequest.getContentType();
                boolean isMultipart = contentType != null && contentType.toLowerCase().startsWith("multipart/");

                if (!isMultipart) {
                    if (!CsrfUtil.isValidToken(httpRequest)) {
                        httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        httpRequest.setAttribute("errorMessage", "Invalid or missing CSRF token. Please refresh and try again.");
                        httpRequest.getRequestDispatcher("/WEB-INF/views/error/403.jsp").forward(httpRequest, httpResponse);
                        return;
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }
}

