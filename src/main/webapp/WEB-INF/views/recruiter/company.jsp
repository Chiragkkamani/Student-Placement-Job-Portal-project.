<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Company Profile &amp; Settings - ${company.companyName}" />
<c:set var="activePage" value="recruiter-company" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <!-- Header -->
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <div class="d-flex align-items-center gap-2 mb-1">
                <h4 class="fw-bold mb-0">${company.companyName} Profile Settings</h4>
                <span class="badge bg-success-subtle text-success border border-success-subtle">
                    <i class="bi bi-building me-1"></i> Recruiter Organization
                </span>
            </div>
            <p class="text-muted small mb-0">View and update corporate profile information, recruitment headquarters, and contact details</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-speedometer2 me-1"></i> HR Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/recruiter/jobs" class="btn btn-outline-success btn-sm">
                <i class="bi bi-briefcase me-1"></i> Manage Job Drives
            </a>
        </div>
    </div>

    <!-- Quick Stats Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="custom-card p-3 d-flex align-items-center gap-3">
                <div class="stat-icon blue">
                    <i class="bi bi-briefcase-fill"></i>
                </div>
                <div>
                    <h4 class="fw-bold mb-0">${totalJobs}</h4>
                    <span class="text-muted small">Total Drives Posted</span>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="custom-card p-3 d-flex align-items-center gap-3">
                <div class="stat-icon green">
                    <i class="bi bi-check-circle-fill"></i>
                </div>
                <div>
                    <h4 class="fw-bold mb-0">${activeJobs}</h4>
                    <span class="text-muted small">Active Drives Open</span>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="custom-card p-3 d-flex align-items-center gap-3">
                <div class="stat-icon orange">
                    <i class="bi bi-people-fill"></i>
                </div>
                <div>
                    <h4 class="fw-bold mb-0">${totalApplicants}</h4>
                    <span class="text-muted small">Candidate Applications</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Company Details Edit Form Card -->
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="custom-card p-4">
                <div class="d-flex align-items-center gap-3 pb-3 mb-4 border-bottom">
                    <div class="stat-icon green" style="width: 50px; height: 50px; font-size: 22px;">
                        <i class="bi bi-pencil-square"></i>
                    </div>
                    <div>
                        <h5 class="fw-bold mb-0">Edit Organization Information</h5>
                        <p class="text-muted small mb-0">Changes saved here are visible to students browsing your campus job drives</p>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/recruiter/company" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">

                    <div class="row g-3">
                        <!-- Company Name -->
                        <div class="col-md-6">
                            <label for="companyName" class="form-label fw-semibold">Company / Corporate Name <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-building"></i></span>
                                <input type="text" class="form-control" id="companyName" name="companyName" 
                                       value="${company.companyName}" required placeholder="e.g. Google Cloud">
                            </div>
                            <small class="text-muted">Primary recruiter organization name</small>
                        </div>

                        <!-- Industry -->
                        <div class="col-md-6">
                            <label for="industry" class="form-label fw-semibold">Industry Sector <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-briefcase"></i></span>
                                <input type="text" class="form-control" id="industry" name="industry" 
                                       value="${company.industry}" required placeholder="e.g. Information Technology &amp; Cloud">
                            </div>
                            <small class="text-muted">Domain / business sector</small>
                        </div>

                        <!-- Location -->
                        <div class="col-md-6">
                            <label for="location" class="form-label fw-semibold">Headquarters / Primary Office <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-geo-alt"></i></span>
                                <input type="text" class="form-control" id="location" name="location" 
                                       value="${company.location}" required placeholder="e.g. Bengaluru, India">
                            </div>
                            <small class="text-muted">City, State / Region, Country</small>
                        </div>

                        <!-- Contact Email -->
                        <div class="col-md-6">
                            <label for="contactEmail" class="form-label fw-semibold">Recruiter Contact Email <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="contactEmail" name="contactEmail" 
                                       value="${company.contactEmail}" required placeholder="e.g. careers@google.com">
                            </div>
                            <small class="text-muted">Official corporate contact for placement queries</small>
                        </div>

                        <!-- Website -->
                        <div class="col-12">
                            <label for="website" class="form-label fw-semibold">Official Career Website</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-globe"></i></span>
                                <input type="url" class="form-control" id="website" name="website" 
                                       value="${company.website}" placeholder="e.g. https://cloud.google.com">
                            </div>
                            <small class="text-muted">Public URL where students can research your company profile</small>
                        </div>
                    </div>

                    <!-- Security Isolation Note -->
                    <div class="p-3 bg-light rounded-3 mt-4 border d-flex align-items-center gap-2">
                        <i class="bi bi-shield-check text-success fs-5"></i>
                        <span class="small text-muted">
                            <strong>Scoped Multi-Tenant Security:</strong> You are updating the profile strictly for <strong>${company.companyName}</strong> (ID: #${company.companyId}). Other organizations' records cannot be accessed or altered.
                        </span>
                    </div>

                    <!-- Actions -->
                    <div class="mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/recruiter/dashboard" class="btn btn-outline-secondary px-3">
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-success px-4 fw-semibold">
                            <i class="bi bi-check-circle-fill me-1"></i> Save Company Details
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
