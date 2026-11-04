package com.ajt.portal.servlet.admin;

import com.ajt.portal.model.Student;
import com.ajt.portal.model.User;
import com.ajt.portal.service.StudentService;
import com.ajt.portal.service.UserService;
import com.ajt.portal.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users"})
public class AdminUserServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final StudentService studentService = new StudentService();
    private final com.ajt.portal.service.CompanyService companyService = new com.ajt.portal.service.CompanyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roleFilter = request.getParameter("role");
        String search = request.getParameter("search");

        List<User> allUsers = userService.getAllUsers();
        List<User> filteredList = new ArrayList<>();

        int totalUsers = allUsers.size();
        int adminCount = 0;
        int studentCount = 0;
        int companyHrCount = 0;
        int activeCount = 0;

        for (User u : allUsers) {
            if (User.ROLE_ADMIN.equalsIgnoreCase(u.getRole())) {
                adminCount++;
            } else if (User.ROLE_STUDENT.equalsIgnoreCase(u.getRole())) {
                studentCount++;
            } else if (User.ROLE_COMPANY_HR.equalsIgnoreCase(u.getRole())) {
                companyHrCount++;
            }
            if (User.STATUS_ACTIVE.equalsIgnoreCase(u.getAccountStatus())) {
                activeCount++;
            }

            boolean matchesRole = (roleFilter == null || roleFilter.trim().isEmpty() || "ALL".equalsIgnoreCase(roleFilter)
                    || u.getRole().equalsIgnoreCase(roleFilter.trim()));

            boolean matchesSearch = true;
            if (search != null && !search.trim().isEmpty()) {
                String q = search.trim().toLowerCase();
                matchesSearch = (u.getFullName() != null && u.getFullName().toLowerCase().contains(q))
                        || (u.getEmail() != null && u.getEmail().toLowerCase().contains(q));
            }

            if (matchesRole && matchesSearch) {
                filteredList.add(u);
            }
        }

        request.setAttribute("users", filteredList);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("adminCount", adminCount);
        request.setAttribute("studentCount", studentCount);
        request.setAttribute("companyHrCount", companyHrCount);
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("selectedRole", roleFilter);
        request.setAttribute("search", search);
        request.setAttribute("companies", companyService.getAllCompanies(null));
        request.setAttribute("activePage", "admin-users");

        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        String action = request.getParameter("action");

        try {
            if ("create".equalsIgnoreCase(action)) {
                String fullName = request.getParameter("fullName");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String role = request.getParameter("role");
                String status = request.getParameter("status");

                if (!ValidationUtil.isNotEmpty(fullName) || !ValidationUtil.isNotEmpty(email) || !ValidationUtil.isNotEmpty(password)) {
                    throw new IllegalArgumentException("Full name, email/username, and password are required.");
                }

                if (User.ROLE_STUDENT.equalsIgnoreCase(role)) {
                    String enrollment = request.getParameter("enrollmentNumber");
                    String branch = request.getParameter("branch");
                    String semesterStr = request.getParameter("semester");
                    String cgpaStr = request.getParameter("cgpa");
                    String phone = request.getParameter("phone");

                    // If student fields provided, create user and student profile atomically
                    if (ValidationUtil.isNotEmpty(enrollment) && ValidationUtil.isNotEmpty(branch)) {
                        User user = new User();
                        user.setFullName(fullName);
                        user.setEmail(email);

                        Student student = new Student();
                        student.setEnrollmentNumber(enrollment);
                        student.setBranch(branch);
                        student.setSemester(ValidationUtil.isNotEmpty(semesterStr) ? Integer.parseInt(semesterStr) : 1);
                        student.setCgpa(ValidationUtil.isNotEmpty(cgpaStr) ? new BigDecimal(cgpaStr) : BigDecimal.ZERO);
                        student.setPhone(ValidationUtil.isNotEmpty(phone) ? phone : "+91 0000000000");

                        userService.registerStudent(user, student, password);
                        session.setAttribute("flashSuccess", "Student account and profile successfully created for " + fullName + ".");
                    } else {
                        userService.createAccountByAdmin(fullName, email, password, role, status);
                        session.setAttribute("flashSuccess", "Student user account successfully created for " + fullName + ".");
                    }
                } else if (User.ROLE_COMPANY_HR.equalsIgnoreCase(role)) {
                    String companyIdStr = request.getParameter("companyId");
                    if (companyIdStr == null || companyIdStr.trim().isEmpty()) {
                        throw new IllegalArgumentException("Please select a company for the Company HR account.");
                    }
                    int companyId = Integer.parseInt(companyIdStr.trim());
                    userService.createAccountByAdmin(fullName, email, password, User.ROLE_COMPANY_HR, status, companyId);
                    session.setAttribute("flashSuccess", "Company HR recruiter account successfully created for " + fullName + " (" + email + ").");
                } else {
                    // Create Admin account
                    userService.createAccountByAdmin(fullName, email, password, User.ROLE_ADMIN, status, null);
                    session.setAttribute("flashSuccess", "Administrator account successfully created for " + fullName + " (" + email + ").");
                }

            } else if ("toggleStatus".equalsIgnoreCase(action)) {
                int targetUserId = Integer.parseInt(request.getParameter("userId"));
                if (currentUser != null && currentUser.getUserId() == targetUserId) {
                    throw new IllegalStateException("Security restriction: You cannot deactivate your own active session account.");
                }

                String currentStatus = request.getParameter("currentStatus");
                String newStatus = User.STATUS_ACTIVE.equalsIgnoreCase(currentStatus) ? User.STATUS_INACTIVE : User.STATUS_ACTIVE;

                userService.updateUserStatus(targetUserId, newStatus);
                session.setAttribute("flashSuccess", "Account status updated to " + newStatus + ".");

            } else if ("resetPassword".equalsIgnoreCase(action)) {
                int targetUserId = Integer.parseInt(request.getParameter("userId"));
                String newPassword = request.getParameter("newPassword");

                userService.updatePassword(targetUserId, newPassword);
                session.setAttribute("flashSuccess", "Password successfully updated.");

            } else if ("delete".equalsIgnoreCase(action)) {
                int targetUserId = Integer.parseInt(request.getParameter("userId"));
                if (currentUser != null && currentUser.getUserId() == targetUserId) {
                    throw new IllegalStateException("Security restriction: You cannot delete your own logged-in admin account.");
                }

                userService.deleteUser(targetUserId);
                session.setAttribute("flashSuccess", "User account successfully removed.");
            }

        } catch (Exception e) {
            session.setAttribute("flashError", "Account operation failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}

