<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="${job.jobTitle} - Job Details" />
<c:set var="activePage" value="jobs" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/jobs">Jobs</a></li>
            <li class="breadcrumb-item active" aria-current="page">${job.jobTitle}</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- Main Job Description -->
        <div class="col-lg-8">
            <div class="custom-card p-4 mb-4">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <span class="badge bg-primary-subtle text-primary badge-pill mb-2">${job.companyIndustry}</span>
                        <h3 class="fw-bold text-dark mb-1">${job.jobTitle}</h3>
                        <div class="company-name fs-5">
                            <i class="bi bi-building me-1"></i> ${job.companyName}
                        </div>
                    </div>
                    <span class="badge ${job.active ? 'bg-success' : 'bg-secondary'} px-3 py-2 fs-6">
                        ${job.jobStatus}
                    </span>
                </div>

                <div class="d-flex flex-wrap gap-3 py-3 border-top border-bottom my-3 small text-muted">
                    <div><i class="bi bi-geo-alt me-1 text-primary"></i> ${job.location}</div>
                    <div><i class="bi bi-people me-1 text-primary"></i> ${job.applicantCount} Applicants</div>
                    <div><i class="bi bi-calendar-check me-1 text-primary"></i> Posted: <fmt:formatDate value="${job.createdAt}" pattern="MMM dd, yyyy" /></div>
                    <c:if test="${not empty job.companyWebsite}">
                        <div>
                            <i class="bi bi-globe me-1 text-primary"></i> 
                            <a href="${job.companyWebsite}" target="_blank" class="text-decoration-none">Visit Company Site</a>
                        </div>
                    </c:if>
                </div>

                <h5 class="fw-bold mb-3 mt-4">Job Description &amp; Responsibilities</h5>
                <div class="text-muted lh-base mb-4" style="white-space: pre-line;">
                    ${job.description}
                </div>
            </div>

            <!-- Recruiter Profile Card -->
            <div class="custom-card p-4">
                <h5 class="fw-bold mb-3">About ${job.companyName}</h5>
                <div class="row g-3 small">
                    <div class="col-sm-6">
                        <span class="text-muted d-block">Industry Sector:</span>
                        <span class="fw-semibold text-dark">${job.companyIndustry}</span>
                    </div>
                    <div class="col-sm-6">
                        <span class="text-muted d-block">Headquarters:</span>
                        <span class="fw-semibold text-dark">${job.companyLocation}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar / Eligibility & Apply Box -->
        <div class="col-lg-4">
            <div class="custom-card p-4 sticky-top" style="top: 80px;">
                <h5 class="fw-bold mb-3 pb-2 border-bottom">Placement Criteria</h5>

                <div class="mb-3">
                    <label class="small text-muted d-block mb-1">Minimum Aggregate CGPA</label>
                    <div class="d-flex align-items-center justify-content-between p-2 bg-light rounded-3">
                        <span class="fw-bold text-dark fs-5">${job.minimumCgpa}</span>
                        <c:if test="${not empty studentProfile}">
                            <span class="small ${studentProfile.cgpa >= job.minimumCgpa ? 'text-success fw-bold' : 'text-danger fw-bold'}">
                                (Your CGPA: ${studentProfile.cgpa})
                            </span>
                        </c:if>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="small text-muted d-block mb-1">Eligible Academic Branch</label>
                    <div class="p-2 bg-light rounded-3">
                        <span class="fw-semibold text-dark">${job.eligibleBranch}</span>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="small text-muted d-block mb-1">Application Deadline</label>
                    <div class="d-flex align-items-center justify-content-between p-2 bg-light rounded-3">
                        <span class="fw-bold ${job.expired ? 'text-danger' : 'text-primary'}">
                            <i class="bi bi-clock-history me-1"></i> ${job.deadline}
                        </span>
                        <c:choose>
                            <c:when test="${job.expired}">
                                <span class="badge bg-danger">Expired</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-success">Active Drive</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Action Controls -->
                <c:choose>
                    <c:when test="${empty sessionScope.currentUser}">
                        <div class="alert alert-info small mb-3">
                            <i class="bi bi-info-circle me-1"></i> Please sign in to verify academic eligibility and apply.
                        </div>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary w-100 mb-2">
                            Sign In to Apply
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary w-100 btn-sm">
                            New Student Registration
                        </a>
                    </c:when>

                    <c:when test="${sessionScope.currentUser.role == 'ADMIN'}">
                        <div class="alert alert-secondary small mb-3">
                            <i class="bi bi-shield-lock me-1"></i> You are logged in with Administrator privileges.
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/jobs" class="btn btn-primary w-100 mb-2">
                            Manage in Admin Panel
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/applications?jobId=${job.jobId}" class="btn btn-outline-primary w-100 btn-sm">
                            View Applicants (${job.applicantCount})
                        </a>
                    </c:when>

                    <c:otherwise>
                        <c:choose>
                            <c:when test="${job.appliedByCurrentUser}">
                                <div class="alert alert-success text-center p-3 mb-3">
                                    <i class="bi bi-check-circle-fill fs-3 d-block mb-1 text-success"></i>
                                    <h6 class="fw-bold mb-1">Application Submitted</h6>
                                    <div class="small">Current Status: <span class="badge bg-primary">${job.userApplicationStatus}</span></div>
                                </div>
                                <a href="${pageContext.request.contextPath}/student/applications" class="btn btn-outline-primary w-100 btn-sm">
                                    Track in My Applications
                                </a>
                            </c:when>

                            <c:when test="${!job.active || job.expired}">
                                <div class="alert alert-warning text-center p-3 mb-0">
                                    <i class="bi bi-exclamation-triangle-fill fs-4 d-block mb-1 text-warning"></i>
                                    <h6 class="fw-bold mb-1">Application Window Closed</h6>
                                    <p class="small mb-0 text-muted">This campus drive is no longer accepting new candidate submissions.</p>
                                </div>
                            </c:when>

                            <c:when test="${not isEligible}">
                                <div class="alert alert-danger p-3 mb-3 small">
                                    <i class="bi bi-x-circle-fill me-1"></i> <strong>Not Eligible:</strong> Your profile doesn't meet the academic criteria for this role.
                                </div>
                                <button class="btn btn-secondary w-100" disabled>
                                    Criteria Not Met
                                </button>
                            </c:when>

                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/student/apply" method="post">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                    <input type="hidden" name="jobId" value="${job.jobId}">

                                    <div class="mb-3">
                                        <label for="remarks" class="form-label small">Application Note / Remarks (Optional)</label>
                                        <textarea class="form-control form-control-sm" id="remarks" name="remarks" rows="2"
                                                  placeholder="Any certifications, projects, or notes for the recruiter..."></textarea>
                                    </div>

                                    <div class="small text-muted mb-3">
                                        <i class="bi bi-file-earmark-check text-success me-1"></i> Your profile resume will be attached automatically.
                                    </div>

                                    <button type="submit" class="btn btn-success w-100 py-2 fw-semibold">
                                        <i class="bi bi-send-check me-1"></i> Submit Application Now
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

