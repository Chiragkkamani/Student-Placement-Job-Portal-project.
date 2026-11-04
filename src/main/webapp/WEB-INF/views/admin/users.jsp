<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <c:set var="pageTitle" value="User Accounts Management" />
            <c:set var="activePage" value="admin-users" />
            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/navbar.jsp" />
            <jsp:include page="../common/alerts.jsp" />

            <div class="container py-4">
                <!-- Page Header -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h4 class="fw-bold mb-1">User &amp; Administrator Accounts</h4>
                        <p class="text-muted small mb-0">Create new administrator or student accounts, reset passwords,
                            and manage permissions</p>
                    </div>
                    <button type="button" class="btn btn-primary d-inline-flex align-items-center gap-2"
                        data-bs-toggle="modal" data-bs-target="#addUserModal">
                        <i class="bi bi-person-plus-fill"></i> Add New Account
                    </button>
                </div>

                <!-- Summary Metrics -->
                <div class="row g-3 mb-4">
                    <div class="col-6 col-md">
                        <div class="custom-card p-3 d-flex align-items-center gap-3">
                            <div class="stat-icon blue">
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <div>
                                <h4 class="fw-bold mb-0">${totalUsers}</h4>
                                <span class="text-muted small">Total Accounts</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md">
                        <div class="custom-card p-3 d-flex align-items-center gap-3">
                            <div class="stat-icon red" style="background-color: #fee2e2; color: #dc2626;">
                                <i class="bi bi-shield-lock-fill"></i>
                            </div>
                            <div>
                                <h4 class="fw-bold mb-0">${adminCount}</h4>
                                <span class="text-muted small">Administrators</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md">
                        <div class="custom-card p-3 d-flex align-items-center gap-3">
                            <div class="stat-icon green" style="background-color: #dcfce7; color: #16a34a;">
                                <i class="bi bi-building"></i>
                            </div>
                            <div>
                                <h4 class="fw-bold mb-0">${companyHrCount}</h4>
                                <span class="text-muted small">Company HRs</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md">
                        <div class="custom-card p-3 d-flex align-items-center gap-3">
                            <div class="stat-icon green">
                                <i class="bi bi-mortarboard-fill"></i>
                            </div>
                            <div>
                                <h4 class="fw-bold mb-0">${studentCount}</h4>
                                <span class="text-muted small">Students</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md">
                        <div class="custom-card p-3 d-flex align-items-center gap-3">
                            <div class="stat-icon orange">
                                <i class="bi bi-check-circle-fill"></i>
                            </div>
                            <div>
                                <h4 class="fw-bold mb-0">${activeCount}</h4>
                                <span class="text-muted small">Active Accounts</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Search & Filter Card -->
                <div class="custom-card p-3 mb-4">
                    <form action="${pageContext.request.contextPath}/admin/users" method="get"
                        class="row g-2 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                                <input type="text" name="search" class="form-control"
                                    placeholder="Search by name, email, or username..." value="${search}">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <select name="role" class="form-select">
                                <option value="ALL" ${empty selectedRole || selectedRole=='ALL' ? 'selected' : '' }>All
                                    Roles</option>
                                <option value="ADMIN" ${selectedRole=='ADMIN' ? 'selected' : '' }>Administrators (ADMIN)
                                </option>
                                <option value="COMPANY_HR" ${selectedRole=='COMPANY_HR' ? 'selected' : '' }>Company HRs
                                    (COMPANY_HR)</option>
                                <option value="STUDENT" ${selectedRole=='STUDENT' ? 'selected' : '' }>Students (STUDENT)
                                </option>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-grow-1">Filter</button>
                            <a href="${pageContext.request.contextPath}/admin/users"
                                class="btn btn-outline-secondary">Reset</a>
                        </div>
                    </form>
                </div>

                <!-- Users Table Card -->
                <div class="custom-card p-4">
                    <div class="table-responsive">
                        <table class="table custom-table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>User ID</th>
                                    <th>Full Name</th>
                                    <th>Email / Account ID</th>
                                    <th>Role</th>
                                    <th>Account Status</th>
                                    <th>Created Date</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty users}">
                                        <c:forEach var="u" items="${users}">
                                            <tr>
                                                <td><span
                                                        class="badge bg-light text-dark font-monospace">#${u.userId}</span>
                                                </td>
                                                <td>
                                                    <div class="fw-bold text-dark">${u.fullName}</div>
                                                    <c:if test="${sessionScope.currentUser.userId == u.userId}">
                                                        <span
                                                            class="badge bg-info-subtle text-info border border-info-subtle"
                                                            style="font-size: 11px;">You (Current Session)</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <code class="text-primary fw-semibold">${u.email}</code>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${u.role == 'ADMIN'}">
                                                            <span
                                                                class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                                <i class="bi bi-shield-shaded me-1"></i> ADMIN
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${u.role == 'COMPANY_HR'}">
                                                            <span
                                                                class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                                <i class="bi bi-building me-1"></i> COMPANY HR
                                                            </span>
                                                            <c:if test="${not empty u.companyName}">
                                                                <div class="small text-muted mt-1 fw-semibold"><i
                                                                        class="bi bi-building-check me-1 text-success"></i>${u.companyName}
                                                                </div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="badge bg-primary-subtle text-primary border border-primary-subtle px-2 py-1">
                                                                <i class="bi bi-person me-1"></i> STUDENT
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${u.accountStatus == 'ACTIVE'}">
                                                            <span
                                                                class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                                <i class="bi bi-check-circle-fill me-1"></i> ACTIVE
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span
                                                                class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-2 py-1">
                                                                <i class="bi bi-x-circle me-1"></i> INACTIVE
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-muted small">
                                                    <fmt:formatDate value="${u.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                                </td>
                                                <td class="text-end">
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-light border dropdown-toggle"
                                                            type="button" data-bs-toggle="dropdown">
                                                            Actions
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                                            <!-- Toggle Status Form -->
                                                            <li>
                                                                <form
                                                                    action="${pageContext.request.contextPath}/admin/users"
                                                                    method="post" class="d-inline">
                                                                    <input type="hidden" name="csrfToken"
                                                                        value="${sessionScope.CSRF_TOKEN}">
                                                                    <input type="hidden" name="action"
                                                                        value="toggleStatus">
                                                                    <input type="hidden" name="userId"
                                                                        value="${u.userId}">
                                                                    <input type="hidden" name="currentStatus"
                                                                        value="${u.accountStatus}">
                                                                    <button type="submit"
                                                                        class="dropdown-item ${sessionScope.currentUser.userId == u.userId ? 'disabled' : ''}">
                                                                        <i
                                                                            class="bi ${u.accountStatus == 'ACTIVE' ? 'bi-pause-circle text-warning' : 'bi-play-circle text-success'} me-2"></i>
                                                                        ${u.accountStatus == 'ACTIVE' ? 'Deactivate' :
                                                                        'Activate'}
                                                                    </button>
                                                                </form>
                                                            </li>

                                                            <!-- Reset Password Button -->
                                                            <li>
                                                                <button type="button" class="dropdown-item"
                                                                    onclick="openResetPasswordModal(${u.userId}, '${u.fullName}', '${u.email}')">
                                                                    <i class="bi bi-key text-primary me-2"></i> Reset
                                                                    Password
                                                                </button>
                                                            </li>

                                                            <li>
                                                                <hr class="dropdown-divider">
                                                            </li>

                                                            <!-- Delete User Form -->
                                                            <li>
                                                                <form
                                                                    action="${pageContext.request.contextPath}/admin/users"
                                                                    method="post" class="d-inline"
                                                                    onsubmit="return confirm('Are you sure you want to delete user account \'${u.fullName}\'? This will remove associated profile and applications.');">
                                                                    <input type="hidden" name="csrfToken"
                                                                        value="${sessionScope.CSRF_TOKEN}">
                                                                    <input type="hidden" name="action" value="delete">
                                                                    <input type="hidden" name="userId"
                                                                        value="${u.userId}">
                                                                    <button type="submit"
                                                                        class="dropdown-item text-danger ${sessionScope.currentUser.userId == u.userId ? 'disabled' : ''}">
                                                                        <i class="bi bi-trash me-2"></i> Delete Account
                                                                    </button>
                                                                </form>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-muted">
                                                <i class="bi bi-person-x fs-1 d-block mb-2"></i>
                                                No user accounts found matching the criteria.
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
            <!-- Modal: Add New Account                      -->
            <!-- ========================================== -->
            <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content border-0 shadow">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title fw-bold" id="addUserModalLabel">
                                <i class="bi bi-person-plus-fill me-2"></i> Create New Account
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/users" method="post">
                            <div class="modal-body p-4">
                                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                <input type="hidden" name="action" value="create">

                                <!-- Role Selection -->
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Select Account Role <span
                                            class="text-danger">*</span></label>
                                    <div class="d-flex flex-wrap gap-4">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="role" id="roleAdmin"
                                                value="ADMIN" checked onchange="toggleRoleFields('ADMIN')">
                                            <label class="form-check-label fw-semibold text-danger" for="roleAdmin">
                                                <i class="bi bi-shield-shaded me-1"></i> Administrator (ADMIN)
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="role" id="roleCompanyHr"
                                                value="COMPANY_HR" onchange="toggleRoleFields('COMPANY_HR')">
                                            <label class="form-check-label fw-semibold text-success"
                                                for="roleCompanyHr">
                                                <i class="bi bi-building me-1"></i> Company HR (COMPANY_HR)
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="role" id="roleStudent"
                                                value="STUDENT" onchange="toggleRoleFields('STUDENT')">
                                            <label class="form-check-label fw-semibold text-primary" for="roleStudent">
                                                <i class="bi bi-mortarboard-fill me-1"></i> Student (STUDENT)
                                            </label>
                                        </div>
                                    </div>
                                    <small class="text-muted">Company HRs have strictly isolated access to their
                                        company's job drives and applicants only.</small>
                                </div>

                                <!-- Company Selection Field (for COMPANY_HR) -->
                                <div id="companyHrFields" class="d-none mt-3 p-3 bg-light rounded-3 border">
                                    <h6 class="fw-bold text-success mb-2">
                                        <i class="bi bi-building-check me-1"></i> Company Affiliation <span
                                            class="text-danger">*</span>
                                    </h6>
                                    <label class="form-label small fw-semibold" for="companySelect">Select
                                        Company</label>
                                    <select class="form-select" name="companyId" id="companySelect">
                                        <option value="">-- Choose Assigned Company --</option>
                                        <c:forEach var="c" items="${companies}">
                                            <option value="${c.companyId}">${c.companyName} (${c.location})</option>
                                        </c:forEach>
                                    </select>
                                    <small class="text-muted d-block mt-1">
                                        <i class="bi bi-lock me-1"></i> The HR recruiter will strictly have visibility
                                        into this company's jobs and applicants only.
                                    </small>
                                </div>

                                <hr class="my-3">

                                <div class="row g-3">
                                    <!-- Full Name -->
                                    <div class="col-md-6">
                                        <label for="newFullName" class="form-label fw-semibold">Full Name <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="newFullName" name="fullName"
                                            required placeholder="e.g. Chirag Patel">
                                    </div>

                                    <!-- Email or Username -->
                                    <div class="col-md-6">
                                        <label for="newEmail" class="form-label fw-semibold">Email or Username / Admin
                                            ID <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="newEmail" name="email" required
                                            placeholder="e.g. chiragadmin2 or admin@placement.edu">
                                        <small class="text-muted">Used as the login ID</small>
                                    </div>

                                    <!-- Password -->
                                    <div class="col-md-6">
                                        <label for="newPassword" class="form-label fw-semibold">Password <span
                                                class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="newPassword" name="password"
                                            required placeholder="Min 6 characters">
                                    </div>

                                    <!-- Status -->
                                    <div class="col-md-6">
                                        <label for="newStatus" class="form-label fw-semibold">Account Status</label>
                                        <select class="form-select" id="newStatus" name="status">
                                            <option value="ACTIVE" selected>ACTIVE (Can log in)</option>
                                            <option value="INACTIVE">INACTIVE (Disabled)</option>
                                        </select>
                                    </div>
                                </div>

                                <!-- Additional Student Profile Fields (Conditional) -->
                                <div id="studentProfileFields" class="d-none mt-4 p-3 bg-light rounded-3 border">
                                    <h6 class="fw-bold text-primary mb-3">
                                        <i class="bi bi-mortarboard me-1"></i> Student Academic Information (Optional)
                                    </h6>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold">Enrollment Number</label>
                                            <input type="text" class="form-control form-control-sm"
                                                name="enrollmentNumber" placeholder="e.g. EN2024CS0505">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold">Branch</label>
                                            <select class="form-select form-select-sm" name="branch">
                                                <option value="Computer Science" selected>Computer Science</option>
                                                <option value="Information Technology">Information Technology</option>
                                                <option value="Electronics & Comm.">Electronics &amp; Comm.</option>
                                                <option value="Mechanical Engineering">Mechanical Engineering</option>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold">Semester (1 - 10)</label>
                                            <input type="number" class="form-control form-control-sm" name="semester"
                                                min="1" max="10" value="8">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold">CGPA (0.00 - 10.00)</label>
                                            <input type="number" step="0.01" class="form-control form-control-sm"
                                                name="cgpa" min="0" max="10" value="8.50">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label small fw-semibold">Phone Number</label>
                                            <input type="text" class="form-control form-control-sm" name="phone"
                                                placeholder="+91 9876543210">
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-outline-secondary"
                                    data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                    <i class="bi bi-check-lg me-1"></i> Create Account
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- ========================================== -->
            <!-- Modal: Reset Password                       -->
            <!-- ========================================== -->
            <div class="modal fade" id="resetPasswordModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content border-0 shadow">
                        <div class="modal-header bg-dark text-white">
                            <h5 class="modal-title fw-bold">
                                <i class="bi bi-key-fill text-warning me-2"></i> Reset User Password
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                aria-label="Close"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/users" method="post">
                            <div class="modal-body p-4">
                                <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                                <input type="hidden" name="action" value="resetPassword">
                                <input type="hidden" name="userId" id="resetUserId">

                                <p class="text-muted small mb-3">
                                    Set a new password for <strong id="resetUserName" class="text-dark">User</strong>
                                    (<code id="resetUserEmail">email</code>).
                                </p>

                                <div class="mb-3">
                                    <label for="newPasswordInput" class="form-label fw-semibold">New Password <span
                                            class="text-danger">*</span></label>
                                    <input type="password" class="form-control" id="newPasswordInput" name="newPassword"
                                        required placeholder="Enter new password (min 6 chars)">
                                </div>
                            </div>
                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-outline-secondary"
                                    data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary fw-semibold">Update Password</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                function toggleRoleFields(role) {
                    const studentFields = document.getElementById('studentProfileFields');
                    const companyFields = document.getElementById('companyHrFields');
                    const companySelect = document.getElementById('companySelect');

                    if (role === 'STUDENT') {
                        studentFields.classList.remove('d-none');
                        companyFields.classList.add('d-none');
                        if (companySelect) companySelect.removeAttribute('required');
                    } else if (role === 'COMPANY_HR') {
                        studentFields.classList.add('d-none');
                        companyFields.classList.remove('d-none');
                        if (companySelect) companySelect.setAttribute('required', 'required');
                    } else {
                        studentFields.classList.add('d-none');
                        companyFields.classList.add('d-none');
                        if (companySelect) companySelect.removeAttribute('required');
                    }
                }

                function openResetPasswordModal(userId, name, email) {
                    document.getElementById('resetUserId').value = userId;
                    document.getElementById('resetUserName').textContent = name;
                    document.getElementById('resetUserEmail').textContent = email;
                    document.getElementById('newPasswordInput').value = '';
                    const modal = new bootstrap.Modal(document.getElementById('resetPasswordModal'));
                    modal.show();
                }
            </script>

            <jsp:include page="../common/footer.jsp" />