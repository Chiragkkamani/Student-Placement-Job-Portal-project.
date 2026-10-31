<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Manage Job Openings" />
<c:set var="activePage" value="admin-jobs" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Campus Placement Drives</h4>
            <p class="text-muted small mb-0">Post, configure eligibility criteria, and manage recruitment openings</p>
        </div>
        <button type="button" class="btn btn-primary btn-sm d-inline-flex align-items-center gap-1" 
                data-bs-toggle="modal" data-bs-target="#addJobModal" onclick="openAddJobModal()">
            <i class="bi bi-plus-lg me-1"></i> Post New Job Opening
        </button>
    </div>

    <!-- Filter Card -->
    <div class="custom-card p-3 mb-4">
        <form action="${pageContext.request.contextPath}/admin/jobs" method="get" class="row g-2 align-items-center">
            <div class="col-md-6">
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                    <input type="text" name="search" class="form-control" placeholder="Search by job title or company..."
                           value="${search}">
                </div>
            </div>
            <div class="col-md-3">
                <select name="status" class="form-select">
                    <option value="" ${empty selectedStatus ? 'selected' : ''}>All Statuses</option>
                    <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>Active Drives</option>
                    <option value="CLOSED" ${selectedStatus == 'CLOSED' ? 'selected' : ''}>Closed Drives</option>
                </select>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">Filter</button>
                <a href="${pageContext.request.contextPath}/admin/jobs" class="btn btn-outline-secondary">Reset</a>
            </div>
        </form>
    </div>

    <!-- Jobs Table Card -->
    <div class="custom-card p-4">
        <div class="table-responsive">
            <table class="table custom-table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Job Title &amp; Recruiter</th>
                        <th>Location</th>
                        <th>Eligibility</th>
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
                                        <div class="small text-primary fw-semibold">${j.companyName}</div>
                                    </td>
                                    <td class="small text-muted">${j.location}</td>
                                    <td>
                                        <div class="small">Min CGPA: <span class="fw-bold">${j.minimumCgpa}</span></div>
                                        <div class="small text-muted">${j.eligibleBranch}</div>
                                    </td>
                                    <td class="small ${j.expired ? 'text-danger fw-bold' : 'text-dark'}">
                                        ${j.deadline}
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/applications?jobId=${j.jobId}"
                                           class="badge bg-primary-subtle text-primary text-decoration-none font-monospace p-2">
                                            <i class="bi bi-people me-1"></i> ${j.applicantCount} candidates
                                        </a>
                                    </td>
                                    <td>
                                        <span class="badge ${j.active ? 'bg-success' : 'bg-secondary'} badge-pill">
                                            ${j.jobStatus}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <div class="btn-group btn-group-sm">
                                            <!-- View Public Link -->
                                            <a href="${pageContext.request.contextPath}/jobs/details?id=${j.jobId}" target="_blank"
                                               class="btn btn-outline-secondary" title="Preview Public Page">
                                                <i class="bi bi-box-arrow-up-right"></i>
                                            </a>

                                            <!-- Edit Job Trigger -->
                                            <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editJobModal"
                                                    data-id="${j.jobId}"
                                                    data-company-id="${j.companyId}"
                                                    data-title="${j.jobTitle}"
                                                    data-description="${j.description}"
                                                    data-location="${j.location}"
                                                    data-min-cgpa="${j.minimumCgpa}"
                                                    data-branch="${j.eligibleBranch}"
                                                    data-deadline="${j.deadline}"
                                                    data-status="${j.jobStatus}"
                                                    title="Edit Job Details">
                                                <i class="bi bi-pencil"></i>
                                            </button>

                                            <!-- Toggle Status -->
                                            <form action="${pageContext.request.contextPath}/admin/jobs" method="post" class="d-inline">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                <input type="hidden" name="action" value="toggleStatus">
                                                <input type="hidden" name="jobId" value="${j.jobId}">
                                                <input type="hidden" name="currentStatus" value="${j.jobStatus}">
                                                <button type="submit" class="btn btn-outline-${j.active ? 'warning text-dark' : 'success'}"
                                                        title="${j.active ? 'Close Job Opening' : 'Reactivate Job Opening'}">
                                                    <i class="bi ${j.active ? 'bi-pause-circle' : 'bi-play-circle'}"></i>
                                                </button>
                                            </form>

                                            <!-- Delete Job -->
                                            <form action="${pageContext.request.contextPath}/admin/jobs" method="post" class="d-inline"
                                                  onsubmit="return confirm('Delete this job opening? All student applications for this position will also be removed.');">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="jobId" value="${j.jobId}">
                                                <button type="submit" class="btn btn-outline-danger" title="Delete Job Opening">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">
                                    No job openings found. Click "Post New Job Opening" to create one.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal: Add Job -->
<div class="modal fade" id="addJobModal" tabindex="-1" aria-labelledby="addJobModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/jobs" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="action" value="add">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="addJobModalLabel">Create Placement Job Drive</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Recruiter Company <span class="text-danger">*</span></label>
                            <select name="companyId" class="form-select" required>
                                <option value="" disabled selected>Select Company</option>
                                <c:forEach var="c" items="${companies}">
                                    <option value="${c.companyId}">${c.companyName} (${c.industry})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Job Title <span class="text-danger">*</span></label>
                            <input type="text" name="jobTitle" class="form-control" required placeholder="e.g. Associate Software Engineer">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Job Description &amp; Responsibilities <span class="text-danger">*</span></label>
                            <textarea name="description" class="form-control" rows="4" required
                                      placeholder="Provide role overview, requirements, tech stack, and interview process..."></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Job Location <span class="text-danger">*</span></label>
                            <input type="text" name="location" class="form-control" required placeholder="e.g. Bengaluru, India">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Minimum Aggregate CGPA <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" min="0.00" max="10.00" name="minimumCgpa" class="form-control" required value="7.00">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Eligible Academic Branch <span class="text-danger">*</span></label>
                            <select name="eligibleBranch" class="form-select" required>
                                <option value="All Branches" selected>All Branches</option>
                                <option value="Computer Science">Computer Science</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Electronics & Comm.">Electronics &amp; Comm.</option>
                                <option value="Mechanical Engineering">Mechanical Engineering</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Application Deadline <span class="text-danger">*</span></label>
                            <input type="date" name="deadline" class="form-control" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="closeAddJobModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Publish Job Opening</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: Edit Job -->
<div class="modal fade" id="editJobModal" tabindex="-1" aria-labelledby="editJobModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/jobs" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="jobId" id="editJobId">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="editJobModalLabel">Edit Placement Job Drive</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Recruiter Company <span class="text-danger">*</span></label>
                            <select name="companyId" id="editCompanyId" class="form-select" required>
                                <c:forEach var="c" items="${companies}">
                                    <option value="${c.companyId}">${c.companyName} (${c.industry})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Job Title <span class="text-danger">*</span></label>
                            <input type="text" name="jobTitle" id="editJobTitle" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Job Description &amp; Responsibilities <span class="text-danger">*</span></label>
                            <textarea name="description" id="editDescription" class="form-control" rows="4" required></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Job Location <span class="text-danger">*</span></label>
                            <input type="text" name="location" id="editJobLocation" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Minimum Aggregate CGPA <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" min="0.00" max="10.00" name="minimumCgpa" id="editMinimumCgpa" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Eligible Branch <span class="text-danger">*</span></label>
                            <select name="eligibleBranch" id="editEligibleBranch" class="form-select" required>
                                <option value="All Branches">All Branches</option>
                                <option value="Computer Science">Computer Science</option>
                                <option value="Information Technology">Information Technology</option>
                                <option value="Electronics & Comm.">Electronics &amp; Comm.</option>
                                <option value="Mechanical Engineering">Mechanical Engineering</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Deadline <span class="text-danger">*</span></label>
                            <input type="date" name="deadline" id="editDeadline" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Status <span class="text-danger">*</span></label>
                            <select name="jobStatus" id="editJobStatus" class="form-select" required>
                                <option value="ACTIVE">ACTIVE</option>
                                <option value="CLOSED">CLOSED</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Update Job Drive</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openAddJobModal() {
        const modalEl = document.getElementById('addJobModal');
        if (!modalEl) return;
        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        } else {
            modalEl.style.display = 'block';
            modalEl.classList.add('show');
            document.body.classList.add('modal-open');
            let backdrop = document.getElementById('modalBackdropFallback');
            if (!backdrop) {
                backdrop = document.createElement('div');
                backdrop.id = 'modalBackdropFallback';
                backdrop.className = 'modal-backdrop fade show';
                document.body.appendChild(backdrop);
            }
        }
    }

    function closeAddJobModal() {
        const modalEl = document.getElementById('addJobModal');
        if (!modalEl) return;
        if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) modal.hide();
        }
        modalEl.style.display = 'none';
        modalEl.classList.remove('show');
        document.body.classList.remove('modal-open');
        const backdrop = document.getElementById('modalBackdropFallback');
        if (backdrop) backdrop.remove();
    }
</script>

<jsp:include page="../common/footer.jsp" />

