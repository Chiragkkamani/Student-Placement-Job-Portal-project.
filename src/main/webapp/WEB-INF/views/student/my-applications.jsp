<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Applications" />
<c:set var="activePage" value="my-applications" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">My Placement Applications</h4>
            <p class="text-muted small mb-0">Track your application progress and recruiter interview updates</p>
        </div>
        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary btn-sm">
            <i class="bi bi-search me-1"></i> Browse More Drives
        </a>
    </div>

    <div class="custom-card p-4">
        <div class="table-responsive">
            <table class="table custom-table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Job Title &amp; Company</th>
                        <th>Location</th>
                        <th>Applied Date</th>
                        <th>Application Status</th>
                        <th>Recruiter Remarks</th>
                        <th class="text-end">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty applications}">
                            <c:forEach var="app" items="${applications}">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-dark">${app.jobTitle}</div>
                                        <div class="small text-primary fw-semibold">${app.companyName}</div>
                                    </td>
                                    <td class="small text-muted">
                                        <i class="bi bi-geo-alt me-1"></i>${app.jobLocation}
                                    </td>
                                    <td class="small text-muted">
                                        <fmt:formatDate value="${app.applicationDate}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td>
                                        <span class="badge ${app.statusBadgeClass} badge-pill">
                                            ${app.applicationStatus}
                                        </span>
                                    </td>
                                    <td class="small text-muted" style="max-width: 280px;">
                                        <c:choose>
                                            <c:when test="${not empty app.remarks}">
                                                ${app.remarks}
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-secondary fst-italic">No remarks updated</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <a href="${pageContext.request.contextPath}/jobs/details?id=${app.jobId}"
                                           class="btn btn-sm btn-outline-primary" title="View Job Details">
                                            <i class="bi bi-eye me-1"></i> Details
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-2 d-block mb-2 text-secondary"></i>
                                    <h5>No applications found</h5>
                                    <p class="small mb-3">You have not submitted applications to any campus drives yet.</p>
                                    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary btn-sm">
                                        Explore Campus Openings
                                    </a>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

