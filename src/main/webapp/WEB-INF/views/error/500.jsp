<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="500 - Server Error" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container py-5 text-center">
    <div class="custom-card p-5 mx-auto" style="max-width: 580px;">
        <div class="stat-icon red mx-auto mb-3" style="width: 72px; height: 72px; font-size: 2.25rem;">
            <i class="bi bi-exclamation-triangle"></i>
        </div>
        <h2 class="fw-bold text-dark mb-2">500 - Application Error</h2>
        <p class="text-muted mb-4">
            An internal server error occurred while processing your request. Please ensure the MySQL database service is running and accessible.
        </p>
        <div class="d-flex justify-content-center gap-2">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                <i class="bi bi-house-door me-1"></i> Return to Homepage
            </a>
            <a href="javascript:history.back()" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i> Go Back
            </a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

