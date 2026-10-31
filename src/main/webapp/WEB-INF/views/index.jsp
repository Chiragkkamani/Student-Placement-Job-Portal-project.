<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Campus Placement & Career Portal" />
<c:set var="activePage" value="home" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />
<jsp:include page="common/alerts.jsp" />

<!-- Hero Section -->
<section class="hero-section">
    <div class="container position-relative" style="z-index: 2;">
        <div class="row align-items-center g-5">
            <div class="col-lg-7">
                <span class="badge bg-light text-primary fw-bold px-3 py-2 rounded-pill mb-3">
                    <i class="bi bi-stars me-1"></i> Campus Recruitment Season 2026
                </span>
                <h1 class="hero-title mb-3">
                    Connecting Ambitious Students with Top Employers
                </h1>
                <p class="hero-subtitle mb-4">
                    Explore curated campus recruitment drives, verify your academic eligibility, apply with one click, and track your interview stages in real time.
                </p>

                <!-- Search Bar -->
                <form action="${pageContext.request.contextPath}/jobs" method="get" class="p-2 bg-white rounded-3 shadow-lg">
                    <div class="row g-2 align-items-center">
                        <div class="col-md-5">
                            <div class="input-group">
                                <span class="input-group-text bg-transparent border-0 text-muted"><i class="bi bi-search"></i></span>
                                <input type="text" name="q" class="form-control border-0 shadow-none ps-0" placeholder="Job title, skills, or company...">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="input-group">
                                <span class="input-group-text bg-transparent border-0 text-muted"><i class="bi bi-geo-alt"></i></span>
                                <input type="text" name="location" class="form-control border-0 shadow-none ps-0" placeholder="Location...">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary w-100 py-2">
                                Search Jobs
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <div class="col-lg-5 d-none d-lg-block">
                <div class="bg-white p-4 rounded-4 shadow-lg text-dark">
                    <div class="d-flex align-items-center mb-3">
                        <div class="stat-icon blue me-3">
                            <i class="bi bi-mortarboard-fill"></i>
                        </div>
                        <div>
                            <h6 class="mb-0 fw-bold">Student Portal Gateway</h6>
                            <small class="text-muted">Fast &amp; Verified Placements</small>
                        </div>
                    </div>
                    <hr>
                    <ul class="list-unstyled small mb-4">
                        <li class="d-flex align-items-center mb-2">
                            <i class="bi bi-check-circle-fill text-success me-2"></i> Real-time CGPA &amp; branch eligibility matching
                        </li>
                        <li class="d-flex align-items-center mb-2">
                            <i class="bi bi-check-circle-fill text-success me-2"></i> Direct resume submission &amp; tracking
                        </li>
                        <li class="d-flex align-items-center mb-2">
                            <i class="bi bi-check-circle-fill text-success me-2"></i> Transparent multi-stage interview updates
                        </li>
                    </ul>
                    <c:choose>
                        <c:when test="${empty sessionScope.currentUser}">
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">
                                    <i class="bi bi-person-plus me-1"></i> Create Student Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary">
                                    <i class="bi bi-box-arrow-in-right me-1"></i> Student / Admin Sign In
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-grid">
                                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary">
                                    <i class="bi bi-speedometer2 me-1"></i> Go to My Dashboard
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Stats Counters -->
<section class="py-5 bg-white border-bottom">
    <div class="container">
        <div class="row g-4 text-center">
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <div class="fs-1 fw-bold text-primary mb-1">${totalJobs != null ? totalJobs : 12}+</div>
                    <div class="text-muted fw-semibold small text-uppercase">Active Job Drives</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <div class="fs-1 fw-bold text-success mb-1">${totalStudents != null ? totalStudents : 150}+</div>
                    <div class="text-muted fw-semibold small text-uppercase">Registered Students</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <div class="fs-1 fw-bold text-warning mb-1">${totalCompanies != null ? totalCompanies : 25}+</div>
                    <div class="text-muted fw-semibold small text-uppercase">Partner Companies</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="p-3">
                    <div class="fs-1 fw-bold text-info mb-1">94.8%</div>
                    <div class="text-muted fw-semibold small text-uppercase">Placement Rate</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Featured Jobs -->
<section class="py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Featured Campus Job Openings</h3>
                <p class="text-muted mb-0">Browse latest opportunities open for upcoming campus drives</p>
            </div>
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline-primary">
                View All Jobs <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <c:choose>
                <c:when test="${not empty featuredJobs}">
                    <c:forEach var="job" items="${featuredJobs}">
                        <div class="col-md-6 col-lg-4">
                            <div class="custom-card job-card h-100 p-4 d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge bg-primary-subtle text-primary badge-pill">
                                        ${job.companyIndustry}
                                    </span>
                                    <span class="badge ${job.active ? 'bg-success' : 'bg-secondary'} badge-pill">
                                        ${job.jobStatus}
                                    </span>
                                </div>

                                <h5 class="job-title mb-1">${job.jobTitle}</h5>
                                <div class="company-name mb-3">
                                    <i class="bi bi-building me-1"></i> ${job.companyName}
                                </div>

                                <p class="text-muted small mb-3 flex-grow-1">
                                    <c:choose>
                                        <c:when test="${job.description.length() > 110}">
                                            ${job.description.substring(0, 110)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${job.description}
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <div class="bg-light p-3 rounded-3 mb-3 small">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-muted"><i class="bi bi-geo-alt me-1"></i> Location:</span>
                                        <span class="fw-semibold text-dark">${job.location}</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-muted"><i class="bi bi-award me-1"></i> Min CGPA:</span>
                                        <span class="fw-semibold text-dark">${job.minimumCgpa}</span>
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span class="text-muted"><i class="bi bi-calendar-event me-1"></i> Deadline:</span>
                                        <span class="fw-semibold text-danger">${job.deadline}</span>
                                    </div>
                                </div>

                                <div class="mt-auto">
                                    <a href="${pageContext.request.contextPath}/jobs/details?id=${job.jobId}"
                                       class="btn btn-primary w-100 btn-sm py-2">
                                        View Details &amp; Apply
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="alert alert-info text-center p-4">
                            <i class="bi bi-info-circle fs-3 d-block mb-2"></i>
                            No active job drives at this moment. Please check back soon or browse all listings.
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</section>

<!-- How It Works Section -->
<section class="py-5 bg-white border-top border-bottom">
    <div class="container">
        <div class="text-center max-w-700 mx-auto mb-5">
            <h3 class="fw-bold mb-2">How Campus Placement Works</h3>
            <p class="text-muted">A streamlined, end-to-end process from registration to job offer.</p>
        </div>

        <div class="row g-4 text-center">
            <div class="col-md-3">
                <div class="p-4 rounded-3 h-100 border">
                    <div class="stat-icon blue mx-auto mb-3">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <h5 class="fw-bold mb-2">1. Register Profile</h5>
                    <p class="text-muted small mb-0">Create your student account with enrollment, branch, CGPA, and resume.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 rounded-3 h-100 border">
                    <div class="stat-icon yellow mx-auto mb-3">
                        <i class="bi bi-funnel"></i>
                    </div>
                    <h5 class="fw-bold mb-2">2. Match Eligibility</h5>
                    <p class="text-muted small mb-0">The system checks your CGPA and branch against recruiter criteria automatically.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 rounded-3 h-100 border">
                    <div class="stat-icon green mx-auto mb-3">
                        <i class="bi bi-send-check"></i>
                    </div>
                    <h5 class="fw-bold mb-2">3. 1-Click Application</h5>
                    <p class="text-muted small mb-0">Apply directly before the deadline with your uploaded resume and remarks.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 rounded-3 h-100 border">
                    <div class="stat-icon blue mx-auto mb-3">
                        <i class="bi bi-check2-circle"></i>
                    </div>
                    <h5 class="fw-bold mb-2">4. Track &amp; Selection</h5>
                    <p class="text-muted small mb-0">Stay informed across Applied, Shortlisted, and Selected status stages.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="common/footer.jsp" />

