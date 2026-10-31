package com.ajt.portal.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public final class CsrfUtil {

    public static final String CSRF_SESSION_KEY = "CSRF_TOKEN";
    public static final String CSRF_PARAM_NAME = "csrfToken";
    public static final String CSRF_HEADER_NAME = "X-CSRF-TOKEN";

    private static final SecureRandom RANDOM = new SecureRandom();

    private CsrfUtil() {
    }

    public static String getOrCreateToken(HttpSession session) {
        if (session == null) return null;
        String token = (String) session.getAttribute(CSRF_SESSION_KEY);
        if (token == null) {
            token = generateToken();
            session.setAttribute(CSRF_SESSION_KEY, token);
        }
        return token;
    }

    public static String generateToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    public static boolean isValidToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String sessionToken = (String) session.getAttribute(CSRF_SESSION_KEY);
        if (sessionToken == null || sessionToken.isEmpty()) {
            return false;
        }

        String requestToken = request.getParameter(CSRF_PARAM_NAME);
        if (requestToken == null || requestToken.isEmpty()) {
            requestToken = request.getHeader(CSRF_HEADER_NAME);
        }

        return sessionToken.equals(requestToken);
    }
}

