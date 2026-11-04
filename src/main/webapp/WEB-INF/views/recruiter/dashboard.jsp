<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <c:set var="pageTitle" value="HR Recruiter Portal - ${company.companyName}" />
            <c:set var="activePage" value="recruiter-dashboard" />
            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/navbar.jsp" />
            <jsp:include page="../common/alerts.jsp" />

            <div class="container py-4">
                <!-- Company Profile Header -->
                <div class="custom-card p-4 mb-4 border-start border-4 border-success">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                        <div class="d-flex align-items-center gap-3">
                            <div class="stat-icon green" style="width: 56px; height: 56px; font-size: 24px;">
                                <i class="bi bi-building"></i>
                            </div>
                            <div>
                                <div class="d-flex align-items-center gap-2 mb-1">
                                    <h4 class="fw-bold mb-0 text-dark">${company.companyName}</h4>
                                    <span
                                        class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                        <i class="bi bi-shield-check me-1"></i> Company HR Portal
                                    </span>
                                </div>
                                <div class="text-muted small d-flex flex-wrap gap-3">
                                    <span><i class="bi bi-briefcase me-1"></i>${company.industry}</span>
                                    <span><i class="bi bi-geo-alt me-1"></i>${company.location}</span>
                                    <span><i class="bi bi-envelope me-1"></i>${company.contactEmail}</span>
                                    <c:if test="${not empty company.website}">
                                        <span><i class="bi bi-globe me-1"></i><a href="${company.website}"
                                                target="_blank"
                                                class="text-decoration-none">${company.website}</a></span>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="${pageContext.request.contextPath}/recruiter/company"
                                class="btn btn-outline-success d-inline-flex align-items-center gap-2">
                                <i class="bi bi-pencil-square"></i> Edit Company Profile
                            </a>
                            <a href="${pageContext.request.contextPath}/recruiter/jobs"
                                class="btn btn-success d-inline-flex align-items-center gap-2">
                                <i class="bi bi-plus-circle-fill"></i> Post New Job Drive
                            </a>
                            <a href="${pageContext.request.contextPath}/recruiter/applications"
                                class="btn btn-outline-dark d-inline-flex align-items-center gap-2">
                                <i class="bi bi-people-fill"></i> Review Applicants
                            </a>
                        </div>
                    </div>
                    <div class="mt-3 pt-3 border-top d-flex align-items-center text-muted small">
                        <i class="bi bi-info-circle text-primary me-2"></i>
                        <span>Scoped Multi-Tenant Workspace: Logged in as
                            <strong>${sessionScope.currentUser.fullName}</strong> (${sessionScope.currentUser.email}).
                            You have authorized access strictly limited to <strong>${company.companyName}</strong>
                            drives and candidates.</span>
                    </div>
                </div>

                <!-- Metrics Overview -->
                <div class="row g-4 mb-4">
                    <div class="col-xl-3 col-sm-6">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-label">Active Drives</div>
                                    <div class="stat-number text-success">${activeJobsCount}</div>
                                </div>
                                <div class="stat-icon green">
                                    <i class="bi bi-briefcase-fill"></i>
                                </div>
                            </div>
                            <div class="mt-3 pt-2 border-top small text-muted">
                                Total drives posted: <strong>${totalJobsCount}</strong>
                                <a href="${pageContext.request.contextPath}/recruiter/jobs"
                                    class="float-end text-decoration-none text-success">
                                    Manage <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-sm-6">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-label">Total Applicants</div>
                                    <div class="stat-number text-primary">${appStats.totalApplications}</div>
                                </div>
                                <div class="stat-icon blue">
                                    <i class="bi bi-people-fill"></i>
                                </div>
                            </div>
                            <div class="mt-3 pt-2 border-top small text-muted">
                                Initial review pending: <strong>${appStats.appliedCount}</strong>
                                <a href="${pageContext.request.contextPath}/recruiter/applications?status=APPLIED"
                                    class="float-end text-decoration-none text-primary">
                                    View <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-sm-6">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-label">Shortlisted Candidates</div>
                                    <div class="stat-number text-warning" style="color: #d97706 !important;">
                                        ${appStats.shortlistedCount}</div>
                                </div>
                                <div class="stat-icon orange">
                                    <i class="bi bi-person-check-fill"></i>
                                </div>
                            </div>
                            <div class="mt-3 pt-2 border-top small text-muted">
                                Interview / Assessment stage
                                <a href="${pageContext.request.contextPath}/recruiter/applications?status=SHORTLISTED"
                                    class="float-end text-decoration-none text-warning">
                                    View <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-sm-6">
                        <div class="stat-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stat-label">Final Selects / Offers</div>
                                    <div class="stat-number text-success">${appStats.selectedCount}</div>
                                </div>
                                <div class="stat-icon green">
                                    <i class="bi bi-trophy-fill"></i>
                                </div>
                            </div>
                            <div class="mt-3 pt-2 border-top small text-muted">
                                Rejected count: <strong>${appStats.rejectedCount}</strong>
                                <a href="${pageContext.request.contextPath}/recruiter/applications?status=SELECTED"
                                    class="float-end text-decoration-none text-success">
                                    View <i class="bi bi-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Candidate Pipeline Progress -->
                <div class="custom-card p-4 mb-4">
                    <h6 class="fw-bold mb-3 d-flex align-items-center gap-2">
                        <i class="bi bi-funnel text-primary"></i> Recruitment Pipeline Funnel
                    </h6>
                    <div class="row g-3 text-center">
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border">
                                <span class="text-muted small fw-semibold d-block mb-1">Under Review</span>
                                <h4 class="fw-bold text-primary mb-0">${appStats.appliedCount}</h4>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border">
                                <span class="text-muted small fw-semibold d-block mb-1">Shortlisted</span>
                                <h4 class="fw-bold text-warning mb-0" style="color: #d97706 !important;">
                                    ${appStats.shortlistedCount}</h4>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border">
                                <span class="text-muted small fw-semibold d-block mb-1">Selected / Offered</span>
                                <h4 class="fw-bold text-success mb-0">${appStats.selectedCount}</h4>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="p-3 bg-light rounded-3 border">
                                <span class="text-muted small fw-semibold d-block mb-1">Rejected</span>
                                <h4 class="fw-bold text-danger mb-0">${appStats.rejectedCount}</h4>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Applicants Table -->
                <div class="custom-card p-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h5 class="fw-bold mb-1">Recent Applicants for ${company.companyName}</h5>
                            <p class="text-muted small mb-0">Students who recently applied to your company's recruitment
                                drives</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/recruiter/applications"
                            class="btn btn-outline-primary btn-sm">
                            View All (${appStats.totalApplications}) <i class="bi bi-arrow-right ms-1"></i>
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="table custom-table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Candidate</th>
                                    <th>Drive / Role</th>
                                    <th>Branch &amp; CGPA</th>
                                    <th>Applied Date</th>
                                    <th>Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty recentApplications}">
                                        <c:forEach var="a" items="${recentApplications}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark">${a.studentName}</div>
                                                    <small class="text-muted">${a.enrollmentNumber} &bull;
                                                        ${a.studentEmail}</small>
                                                </td>
                                                <td>
                                                    <span class="fw-semibold text-primary">${a.jobTitle}</span>
                                                    <div class="small text-muted"><i class="bi bi-geo-alt"></i>
                                                        ${a.jobLocation}</div>
                                                </td>
                                                <td>
                                                    <div>${a.studentBranch}</div>
                                                    <span class="badge bg-light text-dark border">CGPA:
                                                        ${a.studentCgpa}</span>
                                                </td>
                                                <td class="text-muted small">
                                                    <fmt:formatDate value="${a.applicationDate}"
                                                        pattern="yyyy-MM-dd HH:mm" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${a.applicationStatus == 'APPLIED'}">
                                                            <span
                                                                class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                                <i class="bi bi-clock me-1"></i> APPLIED
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${a.applicationStatus == 'SHORTLISTED'}">
                                                            <span
                                                                class="badge bg-warning-subtle text-warning border border-warning-subtle"
                                                                style="color: #b45309 !important;">
                                                                <i class="bi bi-check2-circle me-1"></i> SHORTLISTED
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${a.applicationStatus == 'SELECTED'}">
                                                            <span
                                                                class="badge bg-success-subtle text-success border border-success-subtle">
                                                                <i class="bi bi-trophy me-1"></i> SELECTED
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${a.applicationStatus == 'REJECTED'}">
                                                            <span
                                                                class="badge bg-danger-subtle text-danger border border-danger-subtle">
                                                                <i class="bi bi-x-circle me-1"></i> REJECTED
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <div class="d-inline-flex align-items-center gap-1">
                                                        <c:if test="${not empty a.studentResumePath}">
                                                            <a href="${pageContext.request.contextPath}/resume/download?studentId=${a.studentId}"
                                                                target="_blank" class="btn btn-sm btn-outline-secondary"
                                                                title="View Candidate Resume">
                                                                <i class="bi bi-file-earmark-pdf text-danger"></i>
                                                            </a>
                                                        </c:if>

                                                        <!-- Accept Button -->
                                                        <c:choose>
                                                            <c:when test="${a.applicationStatus == 'SELECTED'}">
                                                                <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                                    <i class="bi bi-check-circle-fill me-1"></i> Accepted
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-sm btn-success fw-semibold" 
                                                                        data-bs-toggle="modal" data-bs-target="#quickAcceptModal"
                                                                        data-id="${a.applicationId}"
                                                                        data-student="${a.studentName}"
                                                                        data-job="${a.jobTitle}"
                                                                        title="Accept and offer placement">
                                                                    <i class="bi bi-check-circle-fill me-1"></i> Accept
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <!-- Reject Button -->
                                                        <c:choose>
                                                            <c:when test="${a.applicationStatus == 'REJECTED'}">
                                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                                    <i class="bi bi-x-circle-fill me-1"></i> Rejected
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-sm btn-outline-danger fw-semibold" 
                                                                        data-bs-toggle="modal" data-bs-target="#quickRejectModal"
                                                                        data-id="${a.applicationId}"
                                                                        data-student="${a.studentName}"
                                                                        data-job="${a.jobTitle}"
                                                                        title="Reject candidate application">
                                                                    <i class="bi bi-x-circle-fill me-1"></i> Reject
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <a href="${pageContext.request.contextPath}/recruiter/applications?search=${a.studentName}"
                                                            class="btn btn-sm btn-outline-primary" title="Review candidate details">
                                                            Review
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">
                                                <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                                                No candidate applications submitted to your company yet.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Quick Accept Modal -->
            <div class="modal fade" id="quickAcceptModal" tabindex="-1" aria-labelledby="quickAcceptModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/recruiter/applications" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                            <input type="hidden" name="action" value="accept">
                            <input type="hidden" name="redirect" value="/recruiter/dashboard">
                            <input type="hidden" name="applicationId" id="acceptAppId">

                            <div class="modal-header bg-success text-white">
                                <h5 class="modal-title fw-bold" id="quickAcceptModalLabel">
                                    <i class="bi bi-check-circle-fill me-2"></i> Accept &amp; Select Candidate
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body p-4">
                                <div class="p-3 bg-light rounded-3 mb-3 small border">
                                    <div><strong>Candidate:</strong> <span id="acceptStudentName" class="text-success fw-bold"></span></div>
                                    <div><strong>Role / Drive:</strong> <span id="acceptJobTitle" class="fw-semibold"></span></div>
                                    <div><strong>Company:</strong> ${company.companyName}</div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Offer Remarks / Congratulatory Note</label>
                                    <textarea name="remarks" id="acceptRemarks" class="form-control" rows="3"
                                              placeholder="e.g. Candidate successfully selected for the role. Welcome to the team!"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-success px-4 fw-semibold">
                                    <i class="bi bi-check-circle-fill me-1"></i> Confirm Acceptance &amp; Offer
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Quick Reject Modal -->
            <div class="modal fade" id="quickRejectModal" tabindex="-1" aria-labelledby="quickRejectModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/recruiter/applications" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                            <input type="hidden" name="action" value="reject">
                            <input type="hidden" name="redirect" value="/recruiter/dashboard">
                            <input type="hidden" name="applicationId" id="rejectAppId">

                            <div class="modal-header bg-danger text-white">
                                <h5 class="modal-title fw-bold" id="quickRejectModalLabel">
                                    <i class="bi bi-x-circle-fill me-2"></i> Reject Candidate Application
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body p-4">
                                <div class="p-3 bg-light rounded-3 mb-3 small border">
                                    <div><strong>Candidate:</strong> <span id="rejectStudentName" class="text-danger fw-bold"></span></div>
                                    <div><strong>Role / Drive:</strong> <span id="rejectJobTitle" class="fw-semibold"></span></div>
                                    <div><strong>Company:</strong> ${company.companyName}</div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Rejection Feedback / Notes</label>
                                    <textarea name="remarks" id="rejectRemarks" class="form-control" rows="3"
                                              placeholder="e.g. Profile does not match the technical criteria for this hiring drive."></textarea>
                                </div>
                            </div>
                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-danger px-4 fw-semibold">
                                    <i class="bi bi-x-circle-fill me-1"></i> Confirm Rejection
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function() {
                    const quickAcceptModal = document.getElementById('quickAcceptModal');
                    if (quickAcceptModal) {
                        quickAcceptModal.addEventListener('show.bs.modal', function(event) {
                            const button = event.relatedTarget;
                            if (!button) return;
                            document.getElementById('acceptAppId').value = button.getAttribute('data-id') || '';
                            document.getElementById('acceptStudentName').textContent = button.getAttribute('data-student') || '';
                            document.getElementById('acceptJobTitle').textContent = button.getAttribute('data-job') || '';
                            document.getElementById('acceptRemarks').value = 'Candidate selected and offered position at ' + '${company.companyName}';
                        });
                    }

                    const quickRejectModal = document.getElementById('quickRejectModal');
                    if (quickRejectModal) {
                        quickRejectModal.addEventListener('show.bs.modal', function(event) {
                            const button = event.relatedTarget;
                            if (!button) return;
                            document.getElementById('rejectAppId').value = button.getAttribute('data-id') || '';
                            document.getElementById('rejectStudentName').textContent = button.getAttribute('data-student') || '';
                            document.getElementById('rejectJobTitle').textContent = button.getAttribute('data-job') || '';
                            document.getElementById('rejectRemarks').value = 'Application not selected after recruiter evaluation.';
                        });
                    }
                });
            </script>

            <jsp:include page="../common/footer.jsp" />