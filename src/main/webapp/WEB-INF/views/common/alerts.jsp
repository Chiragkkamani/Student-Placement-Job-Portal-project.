<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container mt-3">
    <!-- Success Flash -->
    <c:if test="${not empty sessionScope.flashSuccess}">
        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="bi bi-check-circle-fill fs-5 me-2"></i>
            <div>${sessionScope.flashSuccess}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashSuccess" scope="session" />
    </c:if>

    <!-- Error Flash -->
    <c:if test="${not empty sessionScope.flashError}">
        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="bi bi-exclamation-triangle-fill fs-5 me-2"></i>
            <div>${sessionScope.flashError}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashError" scope="session" />
    </c:if>

    <!-- Form Error (Request Scope) -->
    <c:if test="${not empty requestScope.formError}">
        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="bi bi-x-circle-fill fs-5 me-2"></i>
            <div>${requestScope.formError}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Info Flash -->
    <c:if test="${not empty sessionScope.flashInfo}">
        <div class="alert alert-info alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="bi bi-info-circle-fill fs-5 me-2"></i>
            <div>${sessionScope.flashInfo}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashInfo" scope="session" />
    </c:if>

    <!-- Warning Flash -->
    <c:if test="${not empty sessionScope.flashWarning}">
        <div class="alert alert-warning alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="bi bi-exclamation-circle-fill fs-5 me-2"></i>
            <div>${sessionScope.flashWarning}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="flashWarning" scope="session" />
    </c:if>
</div>

