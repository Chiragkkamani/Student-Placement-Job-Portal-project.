<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Candidate Applications - ${company.companyName}" />
<c:set var="activePage" value="recruiter-applications" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <!-- Header -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <h4 class="fw-bold mb-0">${company.companyName} Candidate Applicants</h4>
                <span class="badge bg-success-subtle text-success border border-success-subtle">
                    <i class="bi bi-shield-check me-1"></i> Company Scoped
                </span>
            </div>
            <p class="text-muted small mb-0">Evaluate student applicants, view resumes, update evaluation status, and add recruiter notes</p>
        </div>
        <a href="${pageContext.request.contextPath}/recruiter/jobs" class="btn btn-outline-success btn-sm">
            <i class="bi bi-briefcase me-1"></i> Manage Company Drives
        </a>
    </div>

    <!-- Search & Filter Card -->
    <div class="custom-card p-3 mb-4">
        <form action="${pageContext.request.contextPath}/recruiter/applications" method="get" class="row g-2 align-items-center">
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                    <input type="text" name="search" class="form-control" placeholder="Search candidate, enrollment, or drive title..."
                           value="${search}">
                </div>
            </div>
            <div class="col-md-3">
                <select name="status" class="form-select">
                    <option value="" ${empty selectedStatus ? 'selected' : ''}>All Application Statuses</option>
                    <option value="APPLIED" ${selectedStatus == 'APPLIED' ? 'selected' : ''}>APPLIED (Pending Review)</option>
                    <option value="SHORTLISTED" ${selectedStatus == 'SHORTLISTED' ? 'selected' : ''}>SHORTLISTED</option>
                    <option value="SELECTED" ${selectedStatus == 'SELECTED' ? 'selected' : ''}>SELECTED</option>
                    <option value="REJECTED" ${selectedStatus == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
                </select>
            </div>
            <div class="col-md-3">
                <select name="jobId" class="form-select">
                    <option value="" ${empty selectedJobId ? 'selected' : ''}>All ${company.companyName} Drives</option>
                    <c:forEach var="j" items="${companyJobs}">
                        <option value="${j.jobId}" ${selectedJobId == j.jobId ? 'selected' : ''}>
                            ${j.jobTitle} (${j.jobStatus})
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">Filter</button>
                <a href="${pageContext.request.contextPath}/recruiter/applications" class="btn btn-outline-secondary">Reset</a>
            </div>
        </form>
    </div>

    <!-- Applications Table Card -->
    <div class="custom-card p-4">
        <div class="table-responsive">
            <table class="table custom-table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Candidate Profile</th>
                        <th>Academic Record</th>
                        <th>Applied Drive</th>
                        <th>Applied Date</th>
                        <th>Status</th>
                        <th>Resume</th>
                        <th class="text-end">Evaluation</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty applications}">
                            <c:forEach var="app" items="${applications}">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-dark">${app.studentName}</div>
                                        <div class="small text-muted">${app.studentEmail}</div>
                                        <div class="small text-muted"><i class="bi bi-telephone me-1"></i>${app.studentPhone}</div>
                                    </td>
                                    <td>
                                        <div class="small fw-semibold font-monospace">${app.enrollmentNumber}</div>
                                        <div class="small text-dark">${app.studentBranch} (Sem ${app.studentSemester})</div>
                                        <div class="small"><span class="badge bg-light text-primary border">CGPA: ${app.studentCgpa}</span></div>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark">${app.jobTitle}</div>
                                        <div class="small text-muted"><i class="bi bi-geo-alt"></i> ${app.jobLocation}</div>
                                        <div class="small text-muted">Min CGPA: ${app.jobMinCgpa} &bull; ${app.jobBranch}</div>
                                    </td>
                                    <td class="small text-muted">
                                        <fmt:formatDate value="${app.applicationDate}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${app.applicationStatus == 'APPLIED'}">
                                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle d-block text-center py-2 mb-1">
                                                    <i class="bi bi-clock me-1"></i> APPLIED
                                                </span>
                                            </c:when>
                                            <c:when test="${app.applicationStatus == 'SHORTLISTED'}">
                                                <span class="badge bg-warning-subtle text-warning border border-warning-subtle d-block text-center py-2 mb-1" style="color: #b45309 !important;">
                                                    <i class="bi bi-check2-circle me-1"></i> SHORTLISTED
                                                </span>
                                            </c:when>
                                            <c:when test="${app.applicationStatus == 'SELECTED'}">
                                                <span class="badge bg-success-subtle text-success border border-success-subtle d-block text-center py-2 mb-1">
                                                    <i class="bi bi-trophy me-1"></i> SELECTED
                                                </span>
                                            </c:when>
                                            <c:when test="${app.applicationStatus == 'REJECTED'}">
                                                <span class="badge bg-danger-subtle text-danger border border-danger-subtle d-block text-center py-2 mb-1">
                                                    <i class="bi bi-x-circle me-1"></i> REJECTED
                                                </span>
                                            </c:when>
                                        </c:choose>
                                        <small class="text-muted d-block text-truncate" style="max-width: 150px; font-size: 0.75rem;" title="${app.remarks}">
                                            ${app.remarks}
                                        </small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty app.studentResumePath}">
                                                <a href="${pageContext.request.contextPath}/resume/download?studentId=${app.studentId}" target="_blank"
                                                   class="btn btn-sm btn-outline-danger" title="Download Candidate Resume">
                                                    <i class="bi bi-file-earmark-pdf"></i> Resume
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary">None</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <div class="d-inline-flex align-items-center gap-1">
                                            <!-- Accept Button (Marks as SELECTED) -->
                                            <c:choose>
                                                <c:when test="${app.applicationStatus == 'SELECTED'}">
                                                    <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                        <i class="bi bi-check-circle-fill me-1"></i> Accepted
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-sm btn-success fw-semibold" 
                                                            data-bs-toggle="modal" data-bs-target="#quickAcceptModal"
                                                            data-id="${app.applicationId}"
                                                            data-student="${app.studentName}"
                                                            data-job="${app.jobTitle}"
                                                            title="Accept and offer placement">
                                                        <i class="bi bi-check-circle-fill me-1"></i> Accept
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>

                                            <!-- Reject Button (Marks as REJECTED) -->
                                            <c:choose>
                                                <c:when test="${app.applicationStatus == 'REJECTED'}">
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                        <i class="bi bi-x-circle-fill me-1"></i> Rejected
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-sm btn-outline-danger fw-semibold" 
                                                            data-bs-toggle="modal" data-bs-target="#quickRejectModal"
                                                            data-id="${app.applicationId}"
                                                            data-student="${app.studentName}"
                                                            data-job="${app.jobTitle}"
                                                            title="Reject candidate application">
                                                        <i class="bi bi-x-circle-fill me-1"></i> Reject
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="btn-group btn-group-sm ms-1">
                                                <!-- Update Status Detailed Button -->
                                                <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#updateStatusModal"
                                                        data-id="${app.applicationId}"
                                                        data-student="${app.studentName} (${app.enrollmentNumber})"
                                                        data-job="${app.jobTitle}"
                                                        data-status="${app.applicationStatus}"
                                                        data-remarks="${app.remarks}"
                                                        title="Detailed Stage Evaluation &amp; Notes">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>

                                                <!-- View Audit History Button -->
                                                <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#viewHistoryModal"
                                                        data-id="${app.applicationId}"
                                                        title="Audit Trail History">
                                                    <i class="bi bi-clock-history"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-2 d-block mb-2 text-secondary"></i>
                                    <h5>No applications found</h5>
                                    <p class="small mb-0">No student candidate applications matched your filter criteria for ${company.companyName}.</p>
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
<!-- Modal: Update Status                       -->
<!-- ========================================== -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/recruiter/applications" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="applicationId" id="modalAppId">

                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title fw-bold" id="updateStatusModalLabel">
                        <i class="bi bi-pencil-square me-2"></i> Candidate Evaluation
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="p-3 bg-light rounded-3 mb-3 small border">
                        <div><strong>Candidate:</strong> <span id="modalStudentName" class="text-primary"></span></div>
                        <div><strong>Drive Role:</strong> <span id="modalJobTitle" class="fw-semibold"></span></div>
                        <div><strong>Organization:</strong> <span class="badge bg-light text-dark border">${company.companyName}</span></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">New Stage / Decision <span class="text-danger">*</span></label>
                        <select name="newStatus" id="modalNewStatus" class="form-select" required>
                            <option value="APPLIED">APPLIED (Under Review)</option>
                            <option value="SHORTLISTED">SHORTLISTED (For Interview / Online Test)</option>
                            <option value="SELECTED">SELECTED (Final Job Offer Issued)</option>
                            <option value="REJECTED">REJECTED (Candidate Not Selected)</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">HR Feedback &amp; Next Steps</label>
                        <textarea name="remarks" id="modalRemarks" class="form-control" rows="3"
                                  placeholder="e.g. Qualified coding assessment; shortlisted for round 2 technical discussion..."></textarea>
                    </div>
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary px-4 fw-semibold">
                        <i class="bi bi-check-lg me-1"></i> Save Evaluation
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ========================================== -->
<!-- Modal: View History                        -->
<!-- ========================================== -->
<div class="modal fade" id="viewHistoryModal" tabindex="-1" aria-labelledby="viewHistoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold" id="viewHistoryModalLabel">
                    <i class="bi bi-clock-history me-2 text-warning"></i> Application Status History
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div id="historyTimeline">
                    <div class="text-center py-3 text-muted">
                        <div class="spinner-border spinner-border-sm text-primary" role="status"></div>
                        <span class="ms-2">Loading transition history...</span>
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- ========================================== -->
<!-- Modal: Quick Accept Candidate              -->
<!-- ========================================== -->
<div class="modal fade" id="quickAcceptModal" tabindex="-1" aria-labelledby="quickAcceptModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/recruiter/applications" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="action" value="accept">
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

<!-- ========================================== -->
<!-- Modal: Quick Reject Candidate              -->
<!-- ========================================== -->
<div class="modal fade" id="quickRejectModal" tabindex="-1" aria-labelledby="quickRejectModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/recruiter/applications" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="action" value="reject">
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
        // Quick Accept modal
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

        // Quick Reject modal
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

        // Status modal
        const updateModal = document.getElementById('updateStatusModal');
        if (updateModal) {
            updateModal.addEventListener('show.bs.modal', function(event) {
                const button = event.relatedTarget;
                if (!button) return;

                document.getElementById('modalAppId').value = button.getAttribute('data-id') || '';
                document.getElementById('modalStudentName').textContent = button.getAttribute('data-student') || '';
                document.getElementById('modalJobTitle').textContent = button.getAttribute('data-job') || '';
                document.getElementById('modalNewStatus').value = button.getAttribute('data-status') || 'APPLIED';
                document.getElementById('modalRemarks').value = button.getAttribute('data-remarks') || '';
            });
        }

        // History modal
        const historyModal = document.getElementById('viewHistoryModal');
        if (historyModal) {
            historyModal.addEventListener('show.bs.modal', function(event) {
                const button = event.relatedTarget;
                if (!button) return;

                const appId = button.getAttribute('data-id');
                const container = document.getElementById('historyTimeline');
                container.innerHTML = '<div class="text-center py-3 text-muted"><div class="spinner-border spinner-border-sm text-primary" role="status"></div><span class="ms-2">Loading audit records...</span></div>';

                fetch('${pageContext.request.contextPath}/recruiter/applications?action=history&appId=' + appId)
                    .then(response => response.json())
                    .then(data => {
                        if (!data || data.length === 0) {
                            container.innerHTML = '<div class="text-muted text-center py-3">No history records found for this application.</div>';
                            return;
                        }

                        let html = '<ul class="list-group list-group-flush">';
                        data.forEach(item => {
                            const prev = item.previousStatus ? item.previousStatus : 'Initial Submission';
                            html += '<li class="list-group-item px-0 py-2">' +
                                    '<div class="d-flex justify-content-between align-items-center mb-1">' +
                                    '<span class="badge bg-secondary-subtle text-secondary me-1">' + prev + '</span>' +
                                    '<i class="bi bi-arrow-right text-muted mx-1"></i>' +
                                    '<span class="badge bg-primary text-white ms-1">' + item.newStatus + '</span>' +
                                    '</div>' +
                                    '<div class="small text-muted d-flex justify-content-between">' +
                                    '<span><i class="bi bi-person me-1"></i>' + item.changedByName + '</span>' +
                                    '<span><i class="bi bi-clock me-1"></i>' + item.changeTimestamp + '</span>' +
                                    '</div>' +
                                    '</li>';
                        });
                        html += '</ul>';
                        container.innerHTML = html;
                    })
                    .catch(err => {
                        container.innerHTML = '<div class="text-danger text-center py-3"><i class="bi bi-exclamation-triangle me-1"></i> Error loading audit log.</div>';
                    });
            });
        }
    });
</script>

<jsp:include page="../common/footer.jsp" />

