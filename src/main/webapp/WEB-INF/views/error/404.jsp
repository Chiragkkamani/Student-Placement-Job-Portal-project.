<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="404 - Page Not Found" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container py-5 text-center">
    <div class="custom-card p-5 mx-auto" style="max-width: 550px;">
        <div class="stat-icon yellow mx-auto mb-3" style="width: 72px; height: 72px; font-size: 2.25rem;">
            <i class="bi bi-question-circle"></i>
        </div>
        <h2 class="fw-bold text-dark mb-2">404 - Page Not Found</h2>
        <p class="text-muted mb-4">
            The page, job drive, or document you requested could not be located on the university placement server.
        </p>
        <div class="d-flex justify-content-center gap-2">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                <i class="bi bi-house-door me-1"></i> Return Home
            </a>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline-primary">
                <i class="bi bi-briefcase me-1"></i> Browse Job Drives
            </a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

