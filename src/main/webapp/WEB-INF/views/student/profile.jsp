<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="My Profile" />
<c:set var="activePage" value="profile" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="custom-card p-4">
                <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                    <div class="stat-icon blue me-3">
                        <i class="bi bi-person-gear"></i>
                    </div>
                    <div>
                        <h4 class="fw-bold mb-0">Student Profile &amp; Resume</h4>
                        <p class="text-muted small mb-0">Maintain up-to-date academic details for recruiters</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/student/profile" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">

                    <!-- Personal Information -->
                    <h6 class="text-primary fw-bold text-uppercase small mb-3">Personal &amp; Contact Details</h6>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullName" name="fullName"
                                   value="${sessionScope.currentUser.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Email Address <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email"
                                   value="${sessionScope.currentUser.email}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="phone" class="form-label">Phone Number <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="phone" name="phone"
                                   value="${student.phone}" required placeholder="+91 9876543210">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Enrollment Number</label>
                            <input type="text" class="form-control bg-light" value="${student.enrollmentNumber}" readonly>
                            <div class="form-text">Enrollment number is assigned upon admission.</div>
                        </div>
                    </div>

                    <!-- Academic Details -->
                    <h6 class="text-primary fw-bold text-uppercase small mb-3">Academic Performance</h6>
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="branch" class="form-label">Branch of Study <span class="text-danger">*</span></label>
                            <select class="form-select" id="branch" name="branch" required>
                                <option value="Computer Science" ${student.branch == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                                <option value="Information Technology" ${student.branch == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                                <option value="Electronics & Comm." ${student.branch == 'Electronics & Comm.' ? 'selected' : ''}>Electronics &amp; Comm.</option>
                                <option value="Mechanical Engineering" ${student.branch == 'Mechanical Engineering' ? 'selected' : ''}>Mechanical Engineering</option>
                                <option value="Civil Engineering" ${student.branch == 'Civil Engineering' ? 'selected' : ''}>Civil Engineering</option>
                                <option value="Electrical Engineering" ${student.branch == 'Electrical Engineering' ? 'selected' : ''}>Electrical Engineering</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="semester" class="form-label">Current Semester <span class="text-danger">*</span></label>
                            <select class="form-select" id="semester" name="semester" required>
                                <c:forEach var="sem" begin="1" end="8">
                                    <option value="${sem}" ${student.semester == sem ? 'selected' : ''}>Semester ${sem}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="cgpa" class="form-label">Aggregate CGPA <span class="text-danger">*</span></label>
                            <input type="number" step="0.01" min="0.00" max="10.00" class="form-control" id="cgpa" name="cgpa"
                                   value="${student.cgpa}" required>
                        </div>
                    </div>

                    <!-- Resume Upload Section -->
                    <h6 class="text-primary fw-bold text-uppercase small mb-3">Placement Resume</h6>
                    <div class="p-3 bg-light rounded-3 border mb-4">
                        <div class="d-flex align-items-center justify-content-between mb-3">
                            <div>
                                <span class="fw-bold text-dark">Current Resume Document:</span>
                                <c:choose>
                                    <c:when test="${student.hasResume()}">
                                        <span class="badge bg-success ms-2"><i class="bi bi-check-circle me-1"></i> Uploaded</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning text-dark ms-2"><i class="bi bi-exclamation-circle me-1"></i> Not Uploaded</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:if test="${student.hasResume()}">
                                <a href="${pageContext.request.contextPath}/resume/download" target="_blank" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-file-earmark-pdf me-1"></i> View Current File
                                </a>
                            </c:if>
                        </div>

                        <div>
                            <label for="resumeFile" class="form-label mb-1">Upload New Resume (PDF or DOCX, max 5MB)</label>
                            <input type="file" class="form-control" id="resumeFile" name="resumeFile"
                                   accept=".pdf,.docx,.doc" data-max-size="5242880">
                            <div class="form-text">Uploading a new file will automatically replace your existing resume.</div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-outline-secondary">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-save me-1"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

