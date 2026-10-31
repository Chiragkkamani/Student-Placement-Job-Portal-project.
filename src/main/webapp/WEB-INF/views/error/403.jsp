<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="403 - Access Denied" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container py-5 text-center">
    <div class="custom-card p-5 mx-auto" style="max-width: 550px;">
        <div class="stat-icon red mx-auto mb-3" style="width: 72px; height: 72px; font-size: 2.25rem;">
            <i class="bi bi-shield-x"></i>
        </div>
        <h2 class="fw-bold text-dark mb-2">403 - Access Forbidden</h2>
        <p class="text-muted mb-4">
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    ${errorMessage}
                </c:when>
                <c:otherwise>
                    You do not possess the required permissions or role clearance to access this resource.
                </c:otherwise>
            </c:choose>
        </p>
        <div class="d-flex justify-content-center gap-2">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                <i class="bi bi-house-door me-1"></i> Return Home
            </a>
            <c:if test="${empty sessionScope.currentUser}">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                </a>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

