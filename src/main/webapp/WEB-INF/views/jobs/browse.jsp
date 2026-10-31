<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Browse Job Drives" />
<c:set var="activePage" value="jobs" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />
<jsp:include page="../common/alerts.jsp" />

<div class="container py-4">
    <!-- Search and Filter Header -->
    <div class="custom-card p-4 mb-4">
        <form action="${pageContext.request.contextPath}/jobs" method="get">
            <div class="row g-3">
                <div class="col-lg-4 col-md-6">
                    <label class="form-label small text-muted">Keywords</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light text-muted"><i class="bi bi-search"></i></span>
                        <input type="text" name="q" class="form-control" placeholder="Title, skills, or company..."
                               value="${query}">
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <label class="form-label small text-muted">Eligible Branch</label>
                    <select name="branch" class="form-select">
                        <option value="" ${empty selectedBranch ? 'selected' : ''}>All Branches</option>
                        <option value="Computer Science" ${selectedBranch == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                        <option value="Information Technology" ${selectedBranch == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                        <option value="Electronics & Comm." ${selectedBranch == 'Electronics & Comm.' ? 'selected' : ''}>Electronics &amp; Comm.</option>
                        <option value="Mechanical Engineering" ${selectedBranch == 'Mechanical Engineering' ? 'selected' : ''}>Mechanical Engineering</option>
                    </select>
                </div>
                <div class="col-lg-3 col-md-6">
                    <label class="form-label small text-muted">Location</label>
                    <input type="text" name="location" class="form-control" placeholder="e.g. Bengaluru, Pune"
                           value="${selectedLocation}">
                </div>
                <div class="col-lg-2 col-md-6">
                    <label class="form-label small text-muted">Sort By</label>
                    <select name="sortBy" class="form-select">
                        <option value="latest" ${selectedSort == 'latest' ? 'selected' : ''}>Latest First</option>
                        <option value="deadline" ${selectedSort == 'deadline' ? 'selected' : ''}>Deadline Approaching</option>
                        <option value="cgpa" ${selectedSort == 'cgpa' ? 'selected' : ''}>Min CGPA Required</option>
                    </select>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                <div class="d-flex gap-3 align-items-center">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="status" id="statusActive" value="ACTIVE"
                               ${selectedStatus == 'ACTIVE' || empty selectedStatus ? 'checked' : ''}>
                        <label class="form-check-label small" for="statusActive">Active Only</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="status" id="statusAll" value="All"
                               ${selectedStatus == 'All' ? 'checked' : ''}>
                        <label class="form-check-label small" for="statusAll">All Openings</label>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline-secondary btn-sm">
                        Reset Filters
                    </a>
                    <button type="submit" class="btn btn-primary btn-sm px-3">
                        <i class="bi bi-filter me-1"></i> Apply Filters
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Results Header -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">
            Available Recruitment Drives 
            <span class="badge bg-primary-subtle text-primary ms-1">${jobs.size()} found</span>
        </h5>
    </div>

    <!-- Job Cards Grid -->
    <div class="row g-4" id="jobsGrid">
        <c:choose>
            <c:when test="${not empty jobs}">
                <c:forEach var="job" items="${jobs}" varStatus="status">
                    <div class="col-lg-4 col-md-6 job-card-item ${status.index >= 6 ? 'd-none' : ''}" data-job-index="${status.index}">
                        <div class="custom-card job-card h-100 p-4 d-flex flex-column ${!job.active ? 'closed' : ''}">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="badge bg-light text-primary border badge-pill">
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

                            <!-- Criteria Box -->
                            <div class="bg-light p-3 rounded-3 mb-3 small">
                                <div class="d-flex justify-content-between mb-1">
                                    <span class="text-muted"><i class="bi bi-geo-alt me-1"></i> Location:</span>
                                    <span class="fw-semibold text-dark">${job.location}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-1">
                                    <span class="text-muted"><i class="bi bi-award me-1"></i> Min CGPA:</span>
                                    <span class="fw-semibold text-dark">${job.minimumCgpa}</span>
                                </div>
                                <div class="d-flex justify-content-between mb-1">
                                    <span class="text-muted"><i class="bi bi-mortarboard me-1"></i> Branch:</span>
                                    <span class="fw-semibold text-dark">${job.eligibleBranch}</span>
                                </div>
                                <div class="d-flex justify-content-between">
                                    <span class="text-muted"><i class="bi bi-calendar-event me-1"></i> Deadline:</span>
                                    <span class="fw-semibold ${job.expired ? 'text-danger' : 'text-primary'}">
                                        ${job.deadline}
                                    </span>
                                </div>
                            </div>

                            <!-- Student Status Pill -->
                            <c:if test="${not empty studentProfile}">
                                <div class="mb-3">
                                    <c:choose>
                                        <c:when test="${job.isEligible(studentProfile)}">
                                            <span class="badge bg-success-subtle text-success badge-pill w-100 text-center py-2">
                                                <i class="bi bi-check-circle me-1"></i> You meet all academic eligibility criteria
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger-subtle text-danger badge-pill w-100 text-center py-2">
                                                <i class="bi bi-exclamation-triangle me-1"></i> Does not match your branch or CGPA
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>

                            <div class="mt-auto">
                                <a href="${pageContext.request.contextPath}/jobs/details?id=${job.jobId}"
                                   class="btn btn-primary w-100 btn-sm py-2">
                                    View Job Details
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Page-by-Page Navigation (6 Jobs Per Page) -->
                <c:if test="${totalJobsCount > 6}">
                    <div class="col-12 my-4" id="paginationControls">
                        <div class="custom-card p-3 shadow-sm border d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                            <!-- Left: Status Display -->
                            <div class="text-muted small">
                                Showing jobs <strong id="lblRange" class="text-dark">1 - 6</strong> of <strong class="text-primary">${totalJobsCount}</strong> total
                                <span class="badge bg-light text-dark border ms-2">Page <span id="lblPageNumber">1</span> of ${totalPages}</span>
                            </div>

                            <!-- Middle: Page Number Buttons -->
                            <nav aria-label="Job page pagination">
                                <ul class="pagination pagination-sm mb-0 align-items-center">
                                    <li class="page-item" id="navItemPrev">
                                        <button type="button" class="btn btn-outline-secondary btn-sm rounded-pill px-3 me-1" 
                                                id="btnPrevPage" onclick="goToPage(currentPageNumber - 1)" disabled>
                                            <i class="bi bi-chevron-left me-1"></i> Prev 6
                                        </button>
                                    </li>
                                    <c:forEach var="p" begin="1" end="${totalPages}">
                                        <li class="page-item mx-1">
                                            <button type="button" class="btn btn-sm ${p == 1 ? 'btn-primary' : 'btn-outline-secondary'} page-pill rounded-circle"
                                                    id="pageBtn_${p}" style="width: 36px; height: 36px; padding: 0; line-height: 36px;"
                                                    onclick="goToPage(${p})">
                                                ${p}
                                            </button>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item" id="navItemNext">
                                        <button type="button" class="btn btn-outline-primary btn-sm rounded-pill px-3 ms-1" 
                                                id="btnNextPage" onclick="goToPage(currentPageNumber + 1)">
                                            Next 6 <i class="bi bi-arrow-down-circle ms-1"></i>
                                        </button>
                                    </li>
                                </ul>
                            </nav>

                            <!-- Right: Next 6 Down Arrow Button -->
                            <div>
                                <button type="button" class="btn btn-primary btn-sm rounded-pill px-3 d-inline-flex align-items-center gap-2 shadow-sm"
                                        id="btnNextBottom" onclick="goToPage(currentPageNumber + 1)">
                                    <span>Next 6 Jobs</span>
                                    <i class="bi bi-arrow-down-circle-fill"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="custom-card p-5 text-center text-muted">
                        <i class="bi bi-search fs-1 text-secondary mb-3 d-block"></i>
                        <h5>No Job Openings Matched Your Search</h5>
                        <p class="small mb-3">Try adjusting your filters or search keywords to find open campus opportunities.</p>
                        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline-primary btn-sm">
                            Clear All Filters
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    let currentPageNumber = 1;
    const pageSize = 6;
    const totalJobs = ${not empty totalJobsCount ? totalJobsCount : 0};
    const totalPages = ${not empty totalPages ? totalPages : 1};

    function goToPage(targetPage) {
        if (targetPage < 1 || targetPage > totalPages) return;

        currentPageNumber = targetPage;
        const startIndex = (currentPageNumber - 1) * pageSize;
        const endIndex = startIndex + pageSize;

        // Hide all cards, then reveal ONLY the 6 cards for this specific page
        const allCards = document.querySelectorAll('.job-card-item');
        allCards.forEach(function(card) {
            const cardIndex = parseInt(card.getAttribute('data-job-index'));
            if (cardIndex >= startIndex && cardIndex < endIndex) {
                card.classList.remove('d-none');
                card.style.opacity = '0';
                card.style.transform = 'translateY(12px)';
                card.style.transition = 'opacity 0.25s ease, transform 0.25s ease';
                setTimeout(function() {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, 40);
            } else {
                card.classList.add('d-none');
            }
        });

        // Update indicator text
        const shownEnd = Math.min(endIndex, totalJobs);
        const lblRange = document.getElementById('lblRange');
        if (lblRange) {
            lblRange.textContent = (startIndex + 1) + ' - ' + shownEnd;
        }

        const lblPage = document.getElementById('lblPageNumber');
        if (lblPage) {
            lblPage.textContent = currentPageNumber;
        }

        // Update page buttons active state
        for (let p = 1; p <= totalPages; p++) {
            const btn = document.getElementById('pageBtn_' + p);
            if (btn) {
                if (p === currentPageNumber) {
                    btn.classList.remove('btn-outline-secondary');
                    btn.classList.add('btn-primary');
                } else {
                    btn.classList.remove('btn-primary');
                    btn.classList.add('btn-outline-secondary');
                }
            }
        }

        // Update Prev / Next buttons state
        const btnPrev = document.getElementById('btnPrevPage');
        if (btnPrev) {
            btnPrev.disabled = (currentPageNumber === 1);
        }

        const btnNext = document.getElementById('btnNextPage');
        const btnNextBottom = document.getElementById('btnNextBottom');
        const isLastPage = (currentPageNumber === totalPages);

        if (btnNext) {
            btnNext.disabled = isLastPage;
        }

        if (btnNextBottom) {
            if (isLastPage) {
                btnNextBottom.disabled = true;
                btnNextBottom.classList.remove('btn-primary');
                btnNextBottom.classList.add('btn-secondary');
                btnNextBottom.innerHTML = '<span>End of Jobs</span> <i class="bi bi-check2"></i>';
            } else {
                btnNextBottom.disabled = false;
                btnNextBottom.classList.remove('btn-secondary');
                btnNextBottom.classList.add('btn-primary');
                btnNextBottom.innerHTML = '<span>Next 6 Jobs</span> <i class="bi bi-arrow-down-circle-fill"></i>';
            }
        }

        // Scroll smoothly to top of the jobs grid so the new 6 jobs are at the top of the screen
        const grid = document.getElementById('jobsGrid');
        if (grid) {
            grid.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }
</script>

<jsp:include page="../common/footer.jsp" />

