<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Manage Recruitment Drives - ${company.companyName}" />
<c:set var="activePage" value="recruiter-jobs" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <!-- Header -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <h4 class="fw-bold mb-0">${company.companyName} Recruitment Drives</h4>
                <span class="badge bg-success-subtle text-success border border-success-subtle">
                    <i class="bi bi-shield-lock me-1"></i> Isolated Scope
                </span>
            </div>
            <p class="text-muted small mb-0">Post and manage job drives exclusively for ${company.companyName}</p>
        </div>
        <button type="button" class="btn btn-success d-inline-flex align-items-center gap-2" 
                data-bs-toggle="modal" data-bs-target="#addRecruiterJobModal">
            <i class="bi bi-plus-circle-fill"></i> Post New Job Drive
        </button>
    </div>

    <!-- Summary Metrics -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="custom-card p-3 d-flex align-items-center gap-3">
                <div class="stat-icon blue">
                    <i class="bi bi-briefcase-fill"></i>
                </div>
                <div>
                    <h4 class="fw-bold mb-0">${totalJobs}</h4>
                    <span class="text-muted small">Total Drives</span>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="custom-card p-3 d-flex align-items-center gap-3">
                <div class="stat-icon green">
                    <i class="bi bi-check-circle-fill"></i>
                </div>
                <div>
                    <h4 class="fw-bold mb-0">${activeCount}</h4>
                    <span class="text-muted small">Active &amp; Accepting Applications</span>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="custom-card p-3 d-flex align-items-center gap-3">
                <div class="stat-icon orange">
                    <i class="bi bi-pause-circle-fill"></i>
                </div>
                <div>
                    <h4 class="fw-bold mb-0">${closedCount}</h4>
                    <span class="text-muted small">Closed Drives</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Search & Filter Card -->
    <div class="custom-card p-3 mb-4">
        <form action="${pageContext.request.contextPath}/recruiter/jobs" method="get" class="row g-2 align-items-center">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                    <input type="text" name="search" class="form-control" placeholder="Search by job title or location..."
                           value="${search}">
                </div>
            </div>
            <div class="col-md-3">
                <select name="status" class="form-select">
                    <option value="ALL" ${empty selectedStatus || selectedStatus == 'ALL' ? 'selected' : ''}>All Statuses</option>
                    <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Active Drives Only</option>
                    <option value="CLOSED" ${selectedStatus == 'CLOSED' ? 'selected' : ''}>Closed Drives Only</option>
                </select>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">Filter</button>
                <a href="${pageContext.request.contextPath}/recruiter/jobs" class="btn btn-outline-secondary">Reset</a>
            </div>
        </form>
    </div>

    <!-- Jobs Table Card -->
    <div class="custom-card p-4">
        <div class="table-responsive">
            <table class="table custom-table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Job Title</th>
                        <th>Location</th>
                        <th>Eligibility Criteria</th>
                        <th>Deadline</th>
                        <th>Applicants</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty jobs}">
                            <c:forEach var="j" items="${jobs}">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-dark">${j.jobTitle}</div>
                                        <small class="text-muted"><i class="bi bi-building me-1"></i>${company.companyName}</small>
                                    </td>
                                    <td class="small text-muted"><i class="bi bi-geo-alt me-1"></i>${j.location}</td>
                                    <td>
                                        <div class="small">Min CGPA: <span class="fw-bold text-dark">${j.minimumCgpa}</span></div>
                                        <div class="small text-muted">${j.eligibleBranch}</div>
                                    </td>
                                    <td class="small ${j.expired ? 'text-danger fw-bold' : 'text-dark'}">
                                        ${j.deadline}
                                        <c:if test="${j.expired}">
                                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle ms-1">Passed</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/recruiter/applications?jobId=${j.jobId}"
                                           class="badge bg-primary-subtle text-primary text-decoration-none font-monospace p-2"
                                           title="View applicants for this job">
                                            <i class="bi bi-people-fill me-1"></i> ${j.applicantCount} candidates
                                        </a>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${j.active}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                    <i class="bi bi-check-circle-fill me-1"></i> ACTIVE (Open)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-2 py-1">
                                                    <i class="bi bi-pause-circle-fill me-1"></i> DEACTIVATED
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-inline-flex align-items-center gap-1">
                                            <!-- Activate / Deactivate Button -->
                                            <c:choose>
                                                <c:when test="${j.active}">
                                                    <form action="${pageContext.request.contextPath}/recruiter/jobs" method="post" class="d-inline">
                                                        <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <input type="hidden" name="jobId" value="${j.jobId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-warning text-dark fw-semibold"
                                                                title="Deactivate and pause this recruitment drive"
                                                                onclick="return confirm('Deactivate recruitment drive \'${j.jobTitle}\'? Students will no longer be able to submit new applications.');">
                                                            <i class="bi bi-pause-circle me-1"></i> Deactivate
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/recruiter/jobs" method="post" class="d-inline">
                                                        <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                        <input type="hidden" name="action" value="activate">
                                                        <input type="hidden" name="jobId" value="${j.jobId}">
                                                        <button type="submit" class="btn btn-sm btn-success fw-semibold"
                                                                title="Activate and reopen this recruitment drive"
                                                                onclick="return confirm('Activate recruitment drive \'${j.jobTitle}\'? Applications will be reopened for students.');">
                                                            <i class="bi bi-play-circle me-1"></i> Activate
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="btn-group btn-group-sm ms-1">
                                                <!-- View Public Link -->
                                                <a href="${pageContext.request.contextPath}/jobs/details?id=${j.jobId}" target="_blank"
                                                   class="btn btn-outline-secondary" title="View Public Posting">
                                                    <i class="bi bi-box-arrow-up-right"></i>
                                                </a>

                                                <!-- Edit Job Trigger -->
                                                <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editRecruiterJobModal"
                                                        data-id="${j.jobId}"
                                                        data-title="${j.jobTitle}"
                                                        data-description="${j.description}"
                                                        data-location="${j.location}"
                                                        data-min-cgpa="${j.minimumCgpa}"
                                                        data-branch="${j.eligibleBranch}"
                                                        data-deadline="${j.deadline}"
                                                        data-status="${j.jobStatus}"
                                                        title="Edit Drive Details">
                                                    <i class="bi bi-pencil"></i>
                                                </button>

                                                <!-- Delete Job -->
                                                <form action="${pageContext.request.contextPath}/recruiter/jobs" method="post" class="d-inline"
                                                      onsubmit="return confirm('Delete drive \'${j.jobTitle}\'? This cannot be undone.');">
                                                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="jobId" value="${j.jobId}">
                                                    <button type="submit" class="btn btn-outline-danger" title="Delete Drive">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-briefcase fs-1 d-block mb-2 text-secondary"></i>
                                    No job drives found for ${company.companyName}. Click "Post New Job Drive" to create your first drive.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- ========================================== -->
<!-- Modal: Post New Job Drive                  -->
<!-- ========================================== -->
<div class="modal fade" id="addRecruiterJobModal" tabindex="-1" aria-labelledby="addRecruiterJobModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/recruiter/jobs" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="action" value="add">

                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title fw-bold" id="addRecruiterJobModalLabel">
                        <i class="bi bi-briefcase-fill me-2"></i> Post New Job Drive
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Company (Strictly Locked)</label>
                            <input type="text" class="form-control bg-light" value="${company.companyName}" readonly>
                            <small class="text-muted"><i class="bi bi-lock me-1"></i> Automatically bound to your authorized organization</small>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Job Title <span class="text-danger">*</span></label>
                            <input type="text" name="jobTitle" class="form-control" required placeholder="e.g. Associate Cloud Software Engineer">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Job Description &amp; Requirements <span class="text-danger">*</span></label>
                            <textarea name="description" class="form-control" rows="4" required
                                      placeholder="Provide technical requirements, day-to-day responsibilities, tech stack, and evaluation process..."></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Job Location <span class="text-danger">*</span></label>
                            <input type="text" name="location" class="form-control" required value="${company.location}" placeholder="e.g. Bengaluru, India">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Minimum Aggregate CGPA <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" min="0.00" max="10.00" name="minimumCgpa" class="form-control" required value="7.00">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Eligible Academic Branch <span class="text-danger">*</span></label>
                            <select name="eligibleBranch" class="form-select" required>
                                <option value="All Branches" selected>All Branches</option>
                                <option value="Computer Science">Computer Science</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Electronics & Comm.">Electronics &amp; Comm.</option>
                                <option value="Mechanical Engineering">Mechanical Engineering</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Application Deadline <span class="text-danger">*</span></label>
                            <input type="date" name="deadline" class="form-control" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success px-4 fw-semibold">
                        <i class="bi bi-check-lg me-1"></i> Publish Drive
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================================== -->
<!-- Modal: Edit Job Drive                      -->
<!-- ========================================== -->
<div class="modal fade" id="editRecruiterJobModal" tabindex="-1" aria-labelledby="editRecruiterJobModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/recruiter/jobs" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="jobId" id="editJobId">

                <div class="modal-header bg-dark text-white">
                    <h5 class="modal-title fw-bold" id="editRecruiterJobModalLabel">
                        <i class="bi bi-pencil-square me-2 text-warning"></i> Edit Recruitment Drive
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Company</label>
                            <input type="text" class="form-control bg-light" value="${company.companyName}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Job Title <span class="text-danger">*</span></label>
                            <input type="text" name="jobTitle" id="editJobTitle" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Job Description <span class="text-danger">*</span></label>
                            <textarea name="description" id="editDescription" class="form-control" rows="4" required></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Job Location <span class="text-danger">*</span></label>
                            <input type="text" name="location" id="editJobLocation" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Minimum Aggregate CGPA <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" min="0.00" max="10.00" name="minimumCgpa" id="editMinimumCgpa" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Eligible Branch <span class="text-danger">*</span></label>
                            <select name="eligibleBranch" id="editEligibleBranch" class="form-select" required>
                                <option value="All Branches">All Branches</option>
                                <option value="Computer Science">Computer Science</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Electronics & Comm.">Electronics &amp; Comm.</option>
                                <option value="Mechanical Engineering">Mechanical Engineering</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Deadline <span class="text-danger">*</span></label>
                            <input type="date" name="deadline" id="editDeadline" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Status <span class="text-danger">*</span></label>
                            <select name="jobStatus" id="editJobStatus" class="form-select" required>
                                <option value="ACTIVE">ACTIVE</option>
                                <option value="CLOSED">CLOSED</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary px-4 fw-semibold">Update Drive</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const editJobModal = document.getElementById('editRecruiterJobModal');
        if (editJobModal) {
            editJobModal.addEventListener('show.bs.modal', function(event) {
                const button = event.relatedTarget;
                if (!button) return;

                document.getElementById('editJobId').value = button.getAttribute('data-id') || '';
                document.getElementById('editJobTitle').value = button.getAttribute('data-title') || '';
                document.getElementById('editDescription').value = button.getAttribute('data-description') || '';
                document.getElementById('editJobLocation').value = button.getAttribute('data-location') || '';
                document.getElementById('editMinimumCgpa').value = button.getAttribute('data-min-cgpa') || '';
                document.getElementById('editEligibleBranch').value = button.getAttribute('data-branch') || 'All Branches';
                document.getElementById('editDeadline').value = button.getAttribute('data-deadline') || '';
                document.getElementById('editJobStatus').value = button.getAttribute('data-status') || 'ACTIVE';
            });
        }
    });
</script>

<jsp:include page="../common/footer.jsp" />

