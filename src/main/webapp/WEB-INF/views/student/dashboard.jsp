<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Student Dashboard" />
<c:set var="activePage" value="dashboard" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <!-- Student Header Banner -->
    <div class="bg-white p-4 rounded-4 shadow-sm border mb-4">
        <div class="row align-items-center">
            <div class="col-md-8">
                <div class="d-flex align-items-center">
                    <div class="stat-icon blue me-3" style="width: 56px; height: 56px; font-size: 1.75rem;">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div>
                        <h4 class="fw-bold mb-1">${sessionScope.currentUser.fullName}</h4>
                        <div class="text-muted small">
                            <span class="me-3"><i class="bi bi-card-text me-1"></i> ${sessionScope.currentStudent.enrollmentNumber}</span>
                            <span class="me-3"><i class="bi bi-book me-1"></i> ${sessionScope.currentStudent.branch} (Sem ${sessionScope.currentStudent.semester})</span>
                            <span class="badge bg-primary-subtle text-primary fw-bold">CGPA: ${sessionScope.currentStudent.cgpa}</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4 text-md-end mt-3 mt-md-0">
                <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-outline-primary btn-sm me-2">
                    <i class="bi bi-pencil-square me-1"></i> Edit Profile
                </a>
                <c:choose>
                    <c:when test="${sessionScope.currentStudent.hasResume()}">
                        <a href="${pageContext.request.contextPath}/resume/download" target="_blank" class="btn btn-success btn-sm">
                            <i class="bi bi-file-earmark-pdf me-1"></i> View Resume
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/student/profile" class="btn btn-warning btn-sm text-dark">
                            <i class="bi bi-upload me-1"></i> Upload Resume
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Application Stat Counters -->
    <div class="row g-4 mb-4">
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-label">Total Applied</div>
                        <div class="stat-number text-primary">${stats.studentTotalApplications}</div>
                    </div>
                    <div class="stat-icon blue">
                        <i class="bi bi-send-fill"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-label">Shortlisted</div>
                        <div class="stat-number text-primary">${stats.studentShortlistedCount}</div>
                    </div>
                    <div class="stat-icon yellow">
                        <i class="bi bi-star-fill"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-label">Selected / Placed</div>
                        <div class="stat-number text-success">${stats.studentSelectedCount}</div>
                    </div>
                    <div class="stat-icon green">
                        <i class="bi bi-trophy-fill"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stat-card">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-label">Under Review</div>
                        <div class="stat-number text-muted">${stats.studentAppliedCount}</div>
                    </div>
                    <div class="stat-icon blue">
                        <i class="bi bi-hourglass-split"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Applications & Recommended Jobs -->
    <div class="row g-4">
        <!-- Recent Applications -->
        <div class="col-lg-7">
            <div class="custom-card p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold mb-0">My Recent Applications</h5>
                    <a href="${pageContext.request.contextPath}/student/applications" class="small fw-semibold text-primary">
                        View All (${stats.studentTotalApplications})
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table custom-table align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Position &amp; Company</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty recentApplications}">
                                    <c:forEach var="app" items="${recentApplications}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${app.jobTitle}</div>
                                                <div class="small text-muted">${app.companyName}</div>
                                            </td>
                                            <td class="small text-muted">
                                                <fmt:formatDate value="${app.applicationDate}" pattern="MMM dd, yyyy" />
                                            </td>
                                            <td>
                                                <span class="badge ${app.statusBadgeClass} badge-pill">
                                                    ${app.applicationStatus}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <a href="${pageContext.request.contextPath}/jobs/details?id=${app.jobId}" class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted">
                                            You haven't submitted any job applications yet.<br>
                                            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-sm btn-primary mt-2">
                                                Browse Available Drives
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

        <!-- Recommended Jobs Based on Eligibility -->
        <div class="col-lg-5">
            <div class="custom-card p-4 h-100">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h5 class="fw-bold mb-0">Eligible Job Drives</h5>
                        <small class="text-muted">Matched for ${sessionScope.currentStudent.branch} (CGPA &gt;= ${sessionScope.currentStudent.cgpa})</small>
                    </div>
                    <a href="${pageContext.request.contextPath}/jobs" class="small fw-semibold text-primary">All Jobs</a>
                </div>

                <div class="d-flex flex-column gap-3">
                    <c:choose>
                        <c:when test="${not empty recommendedJobs}">
                            <c:forEach var="rec" items="${recommendedJobs}">
                                <div class="p-3 border rounded-3 bg-light">
                                    <div class="d-flex justify-content-between align-items-start mb-1">
                                        <h6 class="fw-bold mb-0">${rec.jobTitle}</h6>
                                        <span class="badge bg-success-subtle text-success badge-pill">Eligible</span>
                                    </div>
                                    <div class="small text-primary fw-semibold mb-2">${rec.companyName}</div>
                                    <div class="d-flex justify-content-between small text-muted">
                                        <span><i class="bi bi-geo-alt"></i> ${rec.location}</span>
                                        <span><i class="bi bi-calendar-event"></i> Deadline: ${rec.deadline}</span>
                                    </div>
                                    <div class="mt-2 text-end">
                                        <a href="${pageContext.request.contextPath}/jobs/details?id=${rec.jobId}" class="btn btn-sm btn-primary">
                                            Apply Now
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4 text-muted">
                                No eligible jobs found matching your branch criteria right now. Check back soon!
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

