<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Manage Students" />
<c:set var="activePage" value="admin-students" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h4 class="fw-bold mb-1">Student Profiles Directory</h4>
            <p class="text-muted small mb-0">Review academic profiles, resumes, and manage student accounts</p>
        </div>
    </div>

    <!-- Search & Filter Card -->
    <div class="custom-card p-3 mb-4">
        <form action="${pageContext.request.contextPath}/admin/students" method="get" class="row g-2 align-items-center">
            <div class="col-md-5">
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                    <input type="text" name="search" class="form-control" placeholder="Search by name, email, or enrollment..."
                           value="${search}">
                </div>
            </div>
            <div class="col-md-4">
                <select name="branch" class="form-select">
                    <option value="" ${empty selectedBranch ? 'selected' : ''}>All Branches</option>
                    <option value="Computer Science" ${selectedBranch == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                    <option value="Information Technology" ${selectedBranch == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                    <option value="Electronics & Comm." ${selectedBranch == 'Electronics & Comm.' ? 'selected' : ''}>Electronics &amp; Comm.</option>
                    <option value="Mechanical Engineering" ${selectedBranch == 'Mechanical Engineering' ? 'selected' : ''}>Mechanical Engineering</option>
                </select>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">Filter</button>
                <a href="${pageContext.request.contextPath}/admin/students" class="btn btn-outline-secondary">Reset</a>
            </div>
        </form>
    </div>

    <!-- Students Table Card -->
    <div class="custom-card p-4">
        <div class="table-responsive">
            <table class="table custom-table align-middle mb-0">
                <thead>
                    <tr>
                        <th>Student Name &amp; Email</th>
                        <th>Enrollment No.</th>
                        <th>Branch &amp; Sem</th>
                        <th>CGPA</th>
                        <th>Phone</th>
                        <th>Resume</th>
                        <th>Status</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty students}">
                            <c:forEach var="s" items="${students}">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-dark">${s.fullName}</div>
                                        <div class="small text-muted">${s.email}</div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border font-monospace">
                                            ${s.enrollmentNumber}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="small fw-semibold text-dark">${s.branch}</div>
                                        <div class="small text-muted">Semester ${s.semester}</div>
                                    </td>
                                    <td>
                                        <span class="fw-bold ${s.cgpa >= 8.0 ? 'text-success' : (s.cgpa >= 6.5 ? 'text-primary' : 'text-danger')}">
                                            ${s.cgpa}
                                        </span>
                                    </td>
                                    <td class="small text-muted">${s.phone}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${s.hasResume()}">
                                                <a href="${pageContext.request.contextPath}/resume/download?studentId=${s.studentId}" target="_blank"
                                                   class="btn btn-sm btn-outline-primary" title="Download Resume">
                                                    <i class="bi bi-file-earmark-pdf"></i> Resume
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary">None</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge ${s.accountStatus == 'ACTIVE' ? 'bg-success' : 'bg-danger'} badge-pill">
                                            ${s.accountStatus}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <div class="btn-group btn-group-sm">
                                            <!-- Toggle Status -->
                                            <form action="${pageContext.request.contextPath}/admin/students" method="post" class="d-inline">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                <input type="hidden" name="action" value="toggleStatus">
                                                <input type="hidden" name="userId" value="${s.userId}">
                                                <input type="hidden" name="currentStatus" value="${s.accountStatus}">
                                                <button type="submit" class="btn btn-outline-${s.accountStatus == 'ACTIVE' ? 'warning text-dark' : 'success'}"
                                                        title="${s.accountStatus == 'ACTIVE' ? 'Deactivate Account' : 'Activate Account'}">
                                                    <i class="bi ${s.accountStatus == 'ACTIVE' ? 'bi-lock' : 'bi-unlock'}"></i>
                                                </button>
                                            </form>

                                            <!-- Delete Student -->
                                            <form action="${pageContext.request.contextPath}/admin/students" method="post" class="d-inline"
                                                  onsubmit="return confirm('Are you sure you want to permanently delete this student record?');">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="studentId" value="${s.studentId}">
                                                <button type="submit" class="btn btn-outline-danger" title="Delete Student Profile">
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
                                <td colspan="8" class="text-center py-4 text-muted">
                                    No students found matching your criteria.
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

