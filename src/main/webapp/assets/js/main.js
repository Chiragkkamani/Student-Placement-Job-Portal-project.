/**
 * Student Placement & Job Portal - Main Client Script
 */

document.addEventListener('DOMContentLoaded', function () {

    // Auto-dismiss alerts after 5 seconds safely
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            try {
                if (typeof bootstrap !== 'undefined' && bootstrap.Alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                } else {
                    alert.remove();
                }
            } catch (e) {
                alert.remove();
            }
        }, 5000);
    });

    // File input validation (Max 5MB, format check)
    const fileInputs = document.querySelectorAll('input[type="file"][data-max-size]');
    fileInputs.forEach(function (input) {
        input.addEventListener('change', function () {
            const maxBytes = parseInt(this.getAttribute('data-max-size')) || (5 * 1024 * 1024);
            if (this.files && this.files[0]) {
                const file = this.files[0];
                if (file.size > maxBytes) {
                    alert('File size exceeds the 5MB limit. Please select a smaller file.');
                    this.value = '';
                }
            }
        });
    });

    // Edit Company Modal Handler
    const editCompanyModal = document.getElementById('editCompanyModal');
    if (editCompanyModal) {
        editCompanyModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            document.getElementById('editCompanyId').value = button.getAttribute('data-id') || '';
            document.getElementById('editCompanyName').value = button.getAttribute('data-name') || '';
            document.getElementById('editIndustry').value = button.getAttribute('data-industry') || '';
            document.getElementById('editLocation').value = button.getAttribute('data-location') || '';
            document.getElementById('editWebsite').value = button.getAttribute('data-website') || '';
            document.getElementById('editContactEmail').value = button.getAttribute('data-email') || '';
        });
    }

    // Edit Job Modal Handler
    const editJobModal = document.getElementById('editJobModal');
    if (editJobModal) {
        editJobModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            document.getElementById('editJobId').value = button.getAttribute('data-id') || '';
            document.getElementById('editCompanyId').value = button.getAttribute('data-company-id') || '';
            document.getElementById('editJobTitle').value = button.getAttribute('data-title') || '';
            document.getElementById('editDescription').value = button.getAttribute('data-description') || '';
            document.getElementById('editJobLocation').value = button.getAttribute('data-location') || '';
            document.getElementById('editMinimumCgpa').value = button.getAttribute('data-min-cgpa') || '';
            document.getElementById('editEligibleBranch').value = button.getAttribute('data-branch') || '';
            document.getElementById('editDeadline').value = button.getAttribute('data-deadline') || '';
            document.getElementById('editJobStatus').value = button.getAttribute('data-status') || 'ACTIVE';
        });
    }

    // Update Application Status Modal Handler
    const updateStatusModal = document.getElementById('updateStatusModal');
    if (updateStatusModal) {
        updateStatusModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            document.getElementById('modalAppId').value = button.getAttribute('data-id') || '';
            document.getElementById('modalStudentName').textContent = button.getAttribute('data-student') || '';
            document.getElementById('modalJobTitle').textContent = button.getAttribute('data-job') || '';
            document.getElementById('modalNewStatus').value = button.getAttribute('data-status') || 'APPLIED';
            document.getElementById('modalRemarks').value = button.getAttribute('data-remarks') || '';
        });
    }

    // View Application Status History Modal Handler
    const viewHistoryModal = document.getElementById('viewHistoryModal');
    if (viewHistoryModal) {
        viewHistoryModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            const appId = button.getAttribute('data-id');
            const historyTimeline = document.getElementById('historyTimeline');
            historyTimeline.innerHTML = '<div class="text-center py-3"><div class="spinner-border text-primary" role="status"></div><p class="mt-2 text-muted">Loading audit log...</p></div>';

            fetch('applications?action=history&appId=' + appId)
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    if (!data || data.length === 0) {
                        historyTimeline.innerHTML = '<p class="text-muted text-center py-3">No previous status transitions recorded.</p>';
                        return;
                    }
                    var html = '<ul class="timeline">';
                    data.forEach(function (item) {
                        var prevText = item.previousStatus ? 'from <span class="badge bg-secondary">' + item.previousStatus + '</span> ' : '';
                        html += '<li class="timeline-item">' +
                            '<div class="fw-bold">Status changed ' + prevText + 'to <span class="badge bg-primary">' + item.newStatus + '</span></div>' +
                            '<div class="timeline-date">By ' + (item.changedByName || 'System') + ' on ' + item.timestamp + '</div>' +
                            '</li>';
                    });
                    html += '</ul>';
                    historyTimeline.innerHTML = html;
                })
                .catch(function () {
                    historyTimeline.innerHTML = '<p class="text-danger text-center py-3">Failed to load status history.</p>';
                });
        });
    }

    // Default +30 Days Deadline for Add Job modal
    const addDeadlineInput = document.getElementById('addDeadline');
    if (addDeadlineInput && !addDeadlineInput.value) {
        const nextMonth = new Date();
        nextMonth.setDate(nextMonth.getDate() + 30);
        addDeadlineInput.value = nextMonth.toISOString().split('T')[0];
    }

    // Auto-open Add Job Modal if requested via URL
    if (window.location.search.indexOf('action=new') !== -1 || window.location.hash === '#addJobModal') {
        const jobModalEl = document.getElementById('addJobModal');
        if (jobModalEl && typeof bootstrap !== 'undefined' && bootstrap.Modal) {
            bootstrap.Modal.getOrCreateInstance(jobModalEl).show();
        }
    }

    // Auto-open Add Company Modal if requested via URL
    if (window.location.search.indexOf('action=new-company') !== -1 || window.location.hash === '#addCompanyModal') {
        const companyModalEl = document.getElementById('addCompanyModal');
        if (companyModalEl && typeof bootstrap !== 'undefined' && bootstrap.Modal) {
            bootstrap.Modal.getOrCreateInstance(companyModalEl).show();
        }
    }
});

