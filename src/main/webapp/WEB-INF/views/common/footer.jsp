<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="footer mt-auto">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="text-white mb-3">
                    <i class="bi bi-mortarboard-fill text-primary me-2"></i>Campus Placement Portal
                </h5>
                <p class="text-secondary small mb-3">
                    Advanced Java Technologies (AJT) Enterprise Web Application. Connecting promising talent with global opportunities through automated recruitment management.
                </p>
                <div class="d-flex gap-2">
                    <span class="badge bg-secondary">Jakarta Servlet 6.0</span>
                    <span class="badge bg-secondary">Tomcat 10.1</span>
                    <span class="badge bg-secondary">MySQL 8</span>
                </div>
            </div>
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white mb-3">Quick Links</h6>
                <ul class="list-unstyled small mb-0">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/jobs">Browse Jobs</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/login">Sign In</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/register">Student Register</a></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Recruitment Branches</h6>
                <ul class="list-unstyled small mb-0">
                    <li class="mb-2"><span class="text-secondary">Computer Science &amp; Engg.</span></li>
                    <li class="mb-2"><span class="text-secondary">Information Technology</span></li>
                    <li class="mb-2"><span class="text-secondary">Electronics &amp; Communication</span></li>
                    <li class="mb-2"><span class="text-secondary">Mechanical Engineering</span></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Placement Cell Support</h6>
                <p class="text-secondary small mb-2">
                    <i class="bi bi-geo-alt me-2 text-primary"></i>Atmanirbhar Chirag Scheme Placement Cell, Block A
                </p>
                <p class="text-secondary small mb-2">
                    <i class="bi bi-envelope me-2 text-primary"></i>placement@chiragscheme.edu
                </p>
                <p class="text-secondary small mb-0">
                    <i class="bi bi-telephone me-2 text-primary"></i>+91 (0) 79 1234 5678
                </p>
            </div>
        </div>
        <hr class="my-4">
        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center small text-secondary">
            <div>&copy; 2026 Student Placement &amp; Job Portal. All Rights Reserved.</div>
            <div>Built for Advanced Java Technologies Enterprise Project</div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 Bundle JS (Includes Popper) - Local First with CDN Fallback -->
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
<script>
    if (typeof bootstrap === 'undefined') {
        var cdnScript = document.createElement('script');
        cdnScript.src = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js';
        cdnScript.crossOrigin = 'anonymous';
        document.head.appendChild(cdnScript);
    }
</script>

<!-- Custom JS -->
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>

