<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <c:set var="pageTitle" value="Admin Placement Dashboard" />
            <c:set var="activePage" value="admin-dashboard" />
            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/navbar.jsp" />
            <jsp:include page="../common/alerts.jsp" />

            <div class="container py-4">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold mb-1">Placement Administration Console</h4>
                        <p class="text-muted small mb-0">Overview of student profiles, company recruitment drives, and
                            applications</p>
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-dark btn-sm">
                            <i class="bi bi-person-gear me-1"></i> Manage Accounts
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/jobs?action=new"
                            class="btn btn-primary btn-sm">
                            <i class="bi bi-plus-lg me-1"></i> Post New Job
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/companies"
                            class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-building me-1"></i> Add Company
                        </a>
                    </div>
                </div>

                <!-- Metric Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-sm-6">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-label">Total Students</div>
                                    <div class="stat-number text-primary">${stats.totalStudents}</div>
                                </div>
                                <div class="stat-icon blue">
                                    <i class="bi bi-people-fill"></i>
                                </div>
                            </div>
                            <div class="mt-3 pt-2 border-top small">
                                <a href="${pageContext.request.contextPath}/admin/students"
                                    class="text-decoration-none">
                                    Manage Students <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-sm-6">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-label">Partner Companies</div>
                                    <div class="stat-number text-dark">${stats.totalCompanies}</div>
                                </div>
                                <div class="stat-icon blue">
                                    <i class="bi bi-buildings"></i>
                                </div>
                            </div>
                            <div class="mt-3 pt-2 border-top small">
                                <a href="${pageContext.request.contextPath}/admin/companies"
                                    class="text-decoration-none">
                                    View Companies <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-sm-6">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-label">Active Drives</div>
                                    <div class="stat-number text-success">${stats.activeJobs}</div>
                                </div>
                                <div class="stat-icon green">
                                    <i class="bi bi-briefcase-fill"></i>
                                </div>
                            </div>
                            <div class="mt-3 pt-2 border-top small">
                                <a href="${pageContext.request.contextPath}/admin/jobs"
                                    class="text-decoration-none text-success">
                                    Manage Job Openings <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-sm-6">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-label">Total Applications</div>
                                    <div class="stat-number text-info">${stats.totalApplications}</div>
                                </div>
                                <div class="stat-icon blue">
                                    <i class="bi bi-card-checklist"></i>
                                </div>
                            </div>
                            <div class="mt-3 pt-2 border-top small">
                                <a href="${pageContext.request.contextPath}/admin/applications"
                                    class="text-decoration-none text-info">
                                    Review Applications <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Application Status Breakdown Bar -->
                <div class="custom-card p-4 mb-4">
                    <h6 class="fw-bold mb-3">Application Pipeline Breakdown</h6>
                    <div class="row g-3 text-center">
                        <div class="col-md-3 col-6">
                            <div class="p-3 bg-light rounded-3 border">
                                <span class="badge bg-warning text-dark badge-pill mb-1">Applied</span>
                                <h3 class="fw-bold mb-0 text-dark">${stats.appliedCount}</h3>
                                <small class="text-muted">Awaiting Review</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="p-3 bg-light rounded-3 border">
                                <span class="badge bg-primary badge-pill mb-1">Shortlisted</span>
                                <h3 class="fw-bold mb-0 text-primary">${stats.shortlistedCount}</h3>
                                <small class="text-muted">In Interview Process</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="p-3 bg-light rounded-3 border">
                                <span class="badge bg-success badge-pill mb-1">Selected</span>
                                <h3 class="fw-bold mb-0 text-success">${stats.selectedCount}</h3>
                                <small class="text-muted">Offer Letters Released</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="p-3 bg-light rounded-3 border">
                                <span class="badge bg-danger badge-pill mb-1">Rejected</span>
                                <h3 class="fw-bold mb-0 text-danger">${stats.rejectedCount}</h3>
                                <small class="text-muted">Not Shortlisted</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Candidate Applications Table -->
                <div class="custom-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">Recent Candidate Applications</h5>
                        <a href="${pageContext.request.contextPath}/admin/applications"
                            class="small fw-semibold text-primary">
                            View All Applications (${stats.totalApplications})
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="table custom-table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Candidate</th>
                                    <th>Academic Info</th>
                                    <th>Job Opening</th>
                                    <th>Applied On</th>
                                    <th>Status</th>
                                    <th class="text-end">Manage</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentApplications}">
                                        <c:forEach var="app" items="${recentApplications}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark">${app.studentName}</div>
                                                    <div class="small text-muted">${app.studentEmail}</div>
                                                </td>
                                                <td>
                                                    <div class="small fw-semibold">${app.enrollmentNumber}</div>
                                                    <div class="small text-muted">${app.studentBranch} | CGPA:
                                                        ${app.studentCgpa}</div>
                                                </td>
                                                <td>
                                                    <div class="fw-bold text-dark">${app.jobTitle}</div>
                                                    <div class="small text-primary">${app.companyName}</div>
                                                </td>
                                                <td class="small text-muted">
                                                    <fmt:formatDate value="${app.applicationDate}"
                                                        pattern="MMM dd, yyyy" />
                                                </td>
                                                <td>
                                                    <span class="badge ${app.statusBadgeClass} badge-pill">
                                                        ${app.applicationStatus}
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/admin/applications"
                                                        class="btn btn-sm btn-outline-primary">
                                                        Update Status
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center py-4 text-muted">
                                                No candidate applications submitted yet.
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