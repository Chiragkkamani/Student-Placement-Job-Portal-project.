<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
            <i class="bi bi-mortarboard-fill text-primary fs-3 me-2"></i>
            <div>
                <span class="d-block lh-1">PlacementPortal</span>
                <small class="text-muted fw-normal fs-6">Atmanirbhar Chirag Scheme</small>
            </div>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent"
                aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-3">
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'home' ? 'active' : ''}" href="${pageContext.request.contextPath}/">
                        <i class="bi bi-house-door me-1"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activePage == 'jobs' ? 'active' : ''}" href="${pageContext.request.contextPath}/jobs">
                        <i class="bi bi-briefcase me-1"></i> Browse Jobs
                    </a>
                </li>

                <!-- Student Navigation -->
                <c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.role == 'STUDENT'}">
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/dashboard">
                            <i class="bi bi-speedometer2 me-1"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'my-applications' ? 'active' : ''}" href="${pageContext.request.contextPath}/student/applications">
                            <i class="bi bi-file-earmark-text me-1"></i> My Applications
                        </a>
                    </li>
                </c:if>

                <!-- Recruiter Navigation -->
                <c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.role == 'COMPANY_HR'}">
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'recruiter-dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/recruiter/dashboard">
                            <i class="bi bi-speedometer2 me-1"></i> HR Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'recruiter-jobs' ? 'active' : ''}" href="${pageContext.request.contextPath}/recruiter/jobs">
                            <i class="bi bi-briefcase me-1"></i> My Drives
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'recruiter-applications' ? 'active' : ''}" href="${pageContext.request.contextPath}/recruiter/applications">
                            <i class="bi bi-people me-1"></i> Applicants
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'recruiter-company' ? 'active' : ''}" href="${pageContext.request.contextPath}/recruiter/company">
                            <i class="bi bi-building-gear me-1"></i> Company Profile
                        </a>
                    </li>
                </c:if>

                <!-- Admin Navigation -->
                <c:if test="${not empty sessionScope.currentUser and sessionScope.currentUser.role == 'ADMIN'}">
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'admin-dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2 me-1"></i> Admin Panel
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'admin-users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-person-gear me-1"></i> Accounts
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'admin-students' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/students">
                            <i class="bi bi-people me-1"></i> Students
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'admin-companies' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/companies">
                            <i class="bi bi-building me-1"></i> Companies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'admin-jobs' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/jobs">
                            <i class="bi bi-briefcase me-1"></i> Manage Jobs
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${activePage == 'admin-applications' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/applications">
                            <i class="bi bi-card-checklist me-1"></i> Applications
                        </a>
                    </li>
                </c:if>
            </ul>

            <!-- Auth Controls -->
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <span class="badge ${sessionScope.currentUser.role == 'ADMIN' ? 'bg-danger' : (sessionScope.currentUser.role == 'COMPANY_HR' ? 'bg-success' : 'bg-primary')} badge-pill">
                                    ${sessionScope.currentUser.role == 'COMPANY_HR' ? 'HR RECRUITER' : sessionScope.currentUser.role}
                                </span>
                                <span class="fw-bold">${sessionScope.currentUser.fullName}</span>
                                <c:if test="${not empty sessionScope.currentUser.companyName}">
                                    <span class="badge bg-light text-dark border d-none d-lg-inline-block">${sessionScope.currentUser.companyName}</span>
                                </c:if>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0" aria-labelledby="userDropdown">
                                <c:if test="${sessionScope.currentUser.role == 'STUDENT'}">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/student/profile">
                                            <i class="bi bi-person-circle me-2 text-primary"></i> My Profile
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/student/applications">
                                            <i class="bi bi-file-earmark-check me-2 text-primary"></i> My Applications
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <c:if test="${sessionScope.currentUser.role == 'COMPANY_HR'}">
                                    <li class="dropdown-header text-uppercase text-muted small fw-bold">
                                        <i class="bi bi-building me-1"></i> ${sessionScope.currentUser.companyName != null ? sessionScope.currentUser.companyName : 'Company Portal'}
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/recruiter/dashboard">
                                            <i class="bi bi-speedometer2 me-2 text-success"></i> HR Dashboard
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/recruiter/jobs">
                                            <i class="bi bi-briefcase me-2 text-success"></i> Manage Job Drives
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/recruiter/applications">
                                            <i class="bi bi-people me-2 text-success"></i> Applicant Candidates
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/recruiter/company">
                                            <i class="bi bi-building-gear me-2 text-success"></i> Company Profile &amp; Settings
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                </c:if>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i> Sign Out
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item me-2">
                            <a class="btn btn-outline-primary btn-sm px-3" href="${pageContext.request.contextPath}/login">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary btn-sm px-3" href="${pageContext.request.contextPath}/register">
                                <i class="bi bi-person-plus me-1"></i> Student Register
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

