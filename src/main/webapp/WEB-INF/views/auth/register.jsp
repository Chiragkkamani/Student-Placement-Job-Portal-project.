<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="Student Registration" />
<c:set var="activePage" value="register" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-5">
    <div class="auth-card" style="max-width: 650px;">
        <div class="text-center mb-4">
            <div class="stat-icon blue mx-auto mb-3">
                <i class="bi bi-person-plus-fill"></i>
            </div>
            <h4 class="fw-bold mb-1">Student Portal Registration</h4>
            <p class="text-muted small">Create your university placement account to browse and apply for jobs</p>
        </div>

        <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation">
            <h6 class="text-primary fw-bold text-uppercase small mb-3 border-bottom pb-2">Account Credentials</h6>
            <div class="row g-3 mb-3">
                <div class="col-md-12">
                    <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="fullName" name="fullName"
                           value="${requestScope.fullName}" required placeholder="e.g. Rahul Sharma">
                </div>
                <div class="col-md-12">
                    <label for="email" class="form-label">College Email Address <span class="text-danger">*</span></label>
                    <input type="email" class="form-control" id="email" name="email"
                           value="${requestScope.email}" required placeholder="e.g. rahul.sharma@student.edu">
                </div>
                <div class="col-md-6">
                    <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="password" name="password" minlength="6" required placeholder="At least 6 characters">
                </div>
                <div class="col-md-6">
                    <label for="confirmPassword" class="form-label">Confirm Password <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" minlength="6" required placeholder="Re-enter password">
                </div>
            </div>

            <h6 class="text-primary fw-bold text-uppercase small mt-4 mb-3 border-bottom pb-2">Academic Profile</h6>
            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label for="enrollmentNumber" class="form-label">Enrollment Number <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="enrollmentNumber" name="enrollmentNumber"
                           value="${requestScope.enrollmentNumber}" required placeholder="e.g. EN2024CS0150">
                </div>
                <div class="col-md-6">
                    <label for="branch" class="form-label">Branch of Study <span class="text-danger">*</span></label>
                    <select class="form-select" id="branch" name="branch" required>
                        <option value="" disabled ${empty requestScope.branch ? 'selected' : ''}>Select Branch</option>
                        <option value="Computer Science" ${requestScope.branch == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                        <option value="Information Technology" ${requestScope.branch == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                        <option value="Electronics & Comm." ${requestScope.branch == 'Electronics & Comm.' ? 'selected' : ''}>Electronics &amp; Comm.</option>
                        <option value="Mechanical Engineering" ${requestScope.branch == 'Mechanical Engineering' ? 'selected' : ''}>Mechanical Engineering</option>
                        <option value="Civil Engineering" ${requestScope.branch == 'Civil Engineering' ? 'selected' : ''}>Civil Engineering</option>
                        <option value="Electrical Engineering" ${requestScope.branch == 'Electrical Engineering' ? 'selected' : ''}>Electrical Engineering</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="semester" class="form-label">Current Semester <span class="text-danger">*</span></label>
                    <select class="form-select" id="semester" name="semester" required>
                        <c:forEach var="sem" begin="1" end="8">
                            <option value="${sem}" ${requestScope.semester == sem ? 'selected' : (empty requestScope.semester && sem == 8 ? 'selected' : '')}>
                                Semester ${sem}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="cgpa" class="form-label">Aggregate CGPA <span class="text-danger">*</span></label>
                    <input type="number" step="0.01" min="0.00" max="10.00" class="form-control" id="cgpa" name="cgpa"
                           value="${requestScope.cgpa}" required placeholder="e.g. 8.50">
                </div>
                <div class="col-md-4">
                    <label for="phone" class="form-label">Phone Number <span class="text-danger">*</span></label>
                    <input type="tel" class="form-control" id="phone" name="phone"
                           value="${requestScope.phone}" required placeholder="+91 9876543210">
                </div>
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-primary py-2 fw-semibold">
                    <i class="bi bi-check2-circle me-1"></i> Register Student Account
                </button>
            </div>
        </form>

        <div class="text-center mt-3 small text-muted">
            Already registered? 
            <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary">Sign In</a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

