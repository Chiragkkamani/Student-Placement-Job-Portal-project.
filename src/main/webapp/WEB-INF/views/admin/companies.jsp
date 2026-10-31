<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

            <c:set var="pageTitle" value="Manage Companies" />
            <c:set var="activePage" value="admin-companies" />
            <jsp:include page="../common/header.jsp" />
            <jsp:include page="../common/navbar.jsp" />
            <jsp:include page="../common/alerts.jsp" />

            <div class="container py-4">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h4 class="fw-bold mb-1">Recruiter Organizations</h4>
                        <p class="text-muted small mb-0">Manage participating campus hiring partners and company
                            contacts</p>
                    </div>
                    <button type="button" class="btn btn-primary btn-sm d-inline-flex align-items-center gap-1"
                        data-bs-toggle="modal" data-bs-target="#addCompanyModal">
                        <i class="bi bi-plus-lg me-1"></i> Add New Company
                    </button>
                </div>

                <!-- Search Bar -->
                <div class="custom-card p-3 mb-4">
                    <form action="${pageContext.request.contextPath}/admin/companies" method="get"
                        class="row g-2 align-items-center">
                        <div class="col-md-9">
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                                <input type="text" name="search" class="form-control"
                                    placeholder="Search companies by name, industry, or location..." value="${search}">
                            </div>
                        </div>
                        <div class="col-md-3 d-flex gap-2">
                            <button type="submit" class="btn btn-primary flex-grow-1">Search</button>
                            <a href="${pageContext.request.contextPath}/admin/companies"
                                class="btn btn-outline-secondary">Reset</a>
                        </div>
                    </form>
                </div>

                <!-- Companies Table Card -->
                <div class="custom-card p-4">
                    <div class="table-responsive">
                        <table class="table custom-table align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Company Name</th>
                                    <th>Industry Sector</th>
                                    <th>Location</th>
                                    <th>Contact Email</th>
                                    <th>Active Drives</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty companies}">
                                        <c:forEach var="c" items="${companies}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-dark">${c.companyName}</div>
                                                    <c:if test="${not empty c.website}">
                                                        <a href="${c.website}" target="_blank"
                                                            class="small text-muted text-decoration-none">
                                                            <i class="bi bi-link-45deg"></i> Website
                                                        </a>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span class="badge bg-light text-primary border badge-pill">
                                                        ${c.industry}
                                                    </span>
                                                </td>
                                                <td class="small text-muted">
                                                    <i class="bi bi-geo-alt me-1"></i> ${c.location}
                                                </td>
                                                <td class="small text-muted">${c.contactEmail}</td>
                                                <td>
                                                    <span
                                                        class="badge bg-secondary-subtle text-secondary font-monospace">
                                                        ${c.jobCount} drives
                                                    </span>
                                                </td>
                                                <td class="text-end">
                                                    <div class="btn-group btn-group-sm">
                                                        <!-- Edit Trigger -->
                                                        <button type="button" class="btn btn-outline-primary"
                                                            data-bs-toggle="modal" data-bs-target="#editCompanyModal"
                                                            data-id="${c.companyId}" data-name="${c.companyName}"
                                                            data-industry="${c.industry}" data-location="${c.location}"
                                                            data-website="${c.website}" data-email="${c.contactEmail}"
                                                            title="Edit Company Details">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>

                                                        <!-- Delete Company -->
                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/companies"
                                                            method="post" class="d-inline"
                                                            onsubmit="return confirm('Are you sure you want to delete this company? All associated job drives will also be removed.');">
                                                            <input type="hidden" name="csrfToken"
                                                                value="${sessionScope.CSRF_TOKEN}">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="companyId"
                                                                value="${c.companyId}">
                                                            <button type="submit" class="btn btn-outline-danger"
                                                                title="Delete Company">
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
                                            <td colspan="6" class="text-center py-4 text-muted">
                                                No companies registered yet. Click "Add New Company" to register a
                                                recruiter.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Modal: Add Company -->
            <div class="modal fade" id="addCompanyModal" tabindex="-1" aria-labelledby="addCompanyModalLabel"
                aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/admin/companies" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                            <input type="hidden" name="action" value="add">

                            <div class="modal-header">
                                <h5 class="modal-title fw-bold" id="addCompanyModalLabel">Add Campus Recruiter Partner
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Company Name <span class="text-danger">*</span></label>
                                    <input type="text" name="companyName" class="form-control" required
                                        placeholder="e.g. Google India">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Industry Sector <span class="text-danger">*</span></label>
                                    <input type="text" name="industry" class="form-control" required
                                        placeholder="e.g. Cloud Computing & AI">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Location <span class="text-danger">*</span></label>
                                    <input type="text" name="location" class="form-control" required
                                        placeholder="e.g. Bengaluru, India">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Corporate Website</label>
                                    <input type="url" name="website" class="form-control"
                                        placeholder="https://company.com">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Contact / HR Email <span
                                            class="text-danger">*</span></label>
                                    <input type="email" name="contactEmail" class="form-control" required
                                        placeholder="recruitment@company.com">
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save Company</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Modal: Edit Company -->
            <div class="modal fade" id="editCompanyModal" tabindex="-1" aria-labelledby="editCompanyModalLabel"
                aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form action="${pageContext.request.contextPath}/admin/companies" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.CSRF_TOKEN}">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="companyId" id="editCompanyId">

                            <div class="modal-header">
                                <h5 class="modal-title fw-bold" id="editCompanyModalLabel">Edit Company Profile</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label class="form-label">Company Name <span class="text-danger">*</span></label>
                                    <input type="text" name="companyName" id="editCompanyName" class="form-control"
                                        required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Industry Sector <span class="text-danger">*</span></label>
                                    <input type="text" name="industry" id="editIndustry" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Location <span class="text-danger">*</span></label>
                                    <input type="text" name="location" id="editLocation" class="form-control" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Corporate Website</label>
                                    <input type="url" name="website" id="editWebsite" class="form-control">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Contact / HR Email <span
                                            class="text-danger">*</span></label>
                                    <input type="email" name="contactEmail" id="editContactEmail" class="form-control"
                                        required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">Update Company</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <jsp:include page="../common/footer.jsp" />