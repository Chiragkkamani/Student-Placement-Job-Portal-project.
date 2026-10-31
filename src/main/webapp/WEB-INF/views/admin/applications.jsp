<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Manage Applications" />
<c:set var="activePage" value="admin-applications" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Student Candidate Applications</h4>
            <p class="text-muted small mb-0">Evaluate candidates, review resumes, update interview statuses, and track audit history</p>
        </div>
    </div>

    <!-- Filter Card -->
    <div class="custom-card p-3 mb-4">
        <form action="${pageContext.request.contextPath}/admin/applications" method="get" class="row g-2 align-items-center">
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                    <input type="text" name="search" class="form-control" placeholder="Search candidate, enrollment, or role..."
                           value="${search}">
                </div>
            </div>
            <div class="col-md-3">
                <select name="status" class="form-select">
                    <option value="" ${empty selectedStatus ? 'selected' : ''}>All Application Statuses</option>
                    <option value="APPLIED" ${selectedStatus == 'APPLIED' ? 'selected' : ''}>APPLIED</option>
                    <option value="SHORTLISTED" ${selectedStatus == 'SHORTLISTED' ? 'selected' : ''}>SHORTLISTED</option>
                    <option value="SELECTED" ${selectedStatus == 'SELECTED' ? 'selected' : ''}>SELECTED</option>
                    <option value="REJECTED" ${selectedStatus == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
                </select>
            </div>
            <div class="col-md-3">
                <select name="jobId" class="form-select">
                    <option value="" ${empty selectedJobId ? 'selected' : ''}>All Job Openings</option>
                    <c:forEach var="j" items="${allJobs}">
                        <option value="${j.jobId}" ${selectedJobId == j.jobId ? 'selected' : ''}>
                            ${j.jobTitle} - ${j.companyName}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">Filter</button>
                <a href="${pageContext.request.contextPath}/admin/applications" class="btn btn-outline-secondary">Reset</a>
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
                        <th>Academic Info</th>
                        <th>Applied Position</th>
                        <th>Date</th>
                        <th>Current Status</th>
                        <th>Resume</th>
                        <th class="text-end">Manage Status</th>
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
                                        <div class="small text-primary fw-semibold">${app.companyName}</div>
                                        <div class="small text-muted"><i class="bi bi-geo-alt"></i> ${app.jobLocation}</div>
                                    </td>
                                    <td class="small text-muted">
                                        <fmt:formatDate value="${app.applicationDate}" pattern="MMM dd, yyyy" />
                                    </td>
                                    <td>
                                        <span class="badge ${app.statusBadgeClass} badge-pill d-block text-center py-2 mb-1">
                                            ${app.applicationStatus}
                                        </span>
                                        <small class="text-muted d-block" style="max-width: 150px; font-size: 0.75rem;">
                                            ${app.remarks}
                                        </small>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty app.studentResumePath}">
                                                <a href="${pageContext.request.contextPath}/resume/download?studentId=${app.studentId}" target="_blank"
                                                   class="btn btn-sm btn-outline-primary" title="View Candidate Resume">
                                                    <i class="bi bi-file-earmark-pdf"></i> View
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary">None</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <div class="btn-group btn-group-sm">
                                            <!-- Update Status Button -->
                                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#updateStatusModal"
                                                    data-id="${app.applicationId}"
                                                    data-student="${app.studentName} (${app.enrollmentNumber})"
                                                    data-job="${app.jobTitle} - ${app.companyName}"
                                                    data-status="${app.applicationStatus}"
                                                    data-remarks="${app.remarks}"
                                                    title="Update Status &amp; Remarks">
                                                <i class="bi bi-pencil-square me-1"></i> Update
                                            </button>

                                            <!-- View Audit History Button -->
                                            <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#viewHistoryModal"
                                                    data-id="${app.applicationId}"
                                                    title="View Transition History">
                                                <i class="bi bi-clock-history"></i>
                                            </button>
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
                                    <p class="small mb-0">No student candidate applications matched your filter criteria.</p>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal: Update Status -->
<div class="modal fade" id="updateStatusModal" tabindex="-1" aria-labelledby="updateStatusModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/applications" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="applicationId" id="modalAppId">

                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="updateStatusModalLabel">Update Application Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="p-3 bg-light rounded-3 mb-3 small">
                        <div><strong>Candidate:</strong> <span id="modalStudentName"></span></div>
                        <div><strong>Position:</strong> <span id="modalJobTitle"></span></div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">New Application Status <span class="text-danger">*</span></label>
                        <select name="newStatus" id="modalNewStatus" class="form-select" required>
                            <option value="APPLIED">APPLIED</option>
                            <option value="SHORTLISTED">SHORTLISTED</option>
                            <option value="SELECTED">SELECTED</option>
                            <option value="REJECTED">REJECTED</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Recruiter Remarks / Interview Feedback</label>
                        <textarea name="remarks" id="modalRemarks" class="form-control" rows="3"
                                  placeholder="e.g. Cleared technical interview round 1; Scheduled for HR round..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Status Transition</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal: View History -->
<div class="modal fade" id="viewHistoryModal" tabindex="-1" aria-labelledby="viewHistoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="viewHistoryModalLabel">
                    <i class="bi bi-clock-history me-1 text-primary"></i> Application Status Audit Log
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="historyTimeline">
                    <!-- Populated dynamically via AJAX -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

