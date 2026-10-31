<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Sign In" />
<c:set var="activePage" value="login" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-5">
    <div class="auth-card">
        <div class="text-center mb-4">
            <div class="stat-icon blue mx-auto mb-3">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <h4 class="fw-bold mb-1">Sign in to Placement Portal</h4>
            <p class="text-muted small">Access your student dashboard or administration console</p>
        </div>

        <form action="${pageContext.request.contextPath}/login" method="post" class="needs-validation">
            <div class="mb-3">
                <label for="email" class="form-label">Email Address or Admin ID</label>
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-person-badge"></i></span>
                    <input type="text" class="form-control" id="email" name="email" required
                           placeholder="chiragadmin or student@student.edu" autocomplete="username">
                </div>
            </div>

            <div class="mb-4">
                <div class="d-flex justify-content-between align-items-center">
                    <label for="password" class="form-label mb-0">Password</label>
                </div>
                <div class="input-group mt-1">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-lock"></i></span>
                    <input type="password" class="form-control" id="password" name="password" required
                           placeholder="Enter your password" autocomplete="current-password">
                </div>
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-primary py-2 fw-semibold">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                </button>
            </div>
        </form>

        <!-- Quick Demo Credentials Assist Box -->
        <div class="bg-light p-3 rounded-3 mt-4 small border">
            <div class="fw-bold text-dark mb-2">
                <i class="bi bi-shield-check text-primary me-1"></i> Authorized Credentials for Project Evaluation:
            </div>
            <div class="d-flex justify-content-between py-1 border-bottom">
                <span><strong>Admin ID:</strong> chiragadmin</span>
                <span class="text-primary fw-bold font-monospace">chirag@123</span>
            </div>
            <div class="d-flex justify-content-between py-1 border-bottom">
                <span><strong>Admin Email:</strong> admin@placement.edu</span>
                <span class="text-primary fw-bold font-monospace">chirag@123</span>
            </div>
            <div class="d-flex justify-content-between py-1">
                <span><strong>Student Demo:</strong> aarav.sharma@student.edu</span>
                <span class="text-muted font-monospace">Password@123</span>
            </div>
        </div>

        <div class="text-center mt-4 small text-muted">
            Don't have a student account? 
            <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-primary">Register Here</a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

