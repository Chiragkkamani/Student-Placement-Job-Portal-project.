package com.ajt.portal.servlet.admin;

import com.ajt.portal.model.Company;
import com.ajt.portal.service.CompanyService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCompanyServlet", urlPatterns = {"/admin/companies"})
public class AdminCompanyServlet extends HttpServlet {

    private final CompanyService companyService = new CompanyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        List<Company> companies = companyService.getAllCompanies(search);

        request.setAttribute("companies", companies);
        request.setAttribute("search", search);
        request.getRequestDispatcher("/WEB-INF/views/admin/companies.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                String companyName = request.getParameter("companyName");
                String industry = request.getParameter("industry");
                String location = request.getParameter("location");
                String website = request.getParameter("website");
                String contactEmail = request.getParameter("contactEmail");

                Company c = new Company(companyName, industry, location, website, contactEmail);
                companyService.createCompany(c);
                session.setAttribute("flashSuccess", "Company '" + companyName + "' added successfully.");

            } else if ("edit".equalsIgnoreCase(action)) {
                int companyId = Integer.parseInt(request.getParameter("companyId"));
                String companyName = request.getParameter("companyName");
                String industry = request.getParameter("industry");
                String location = request.getParameter("location");
                String website = request.getParameter("website");
                String contactEmail = request.getParameter("contactEmail");

                Company c = new Company(companyName, industry, location, website, contactEmail);
                c.setCompanyId(companyId);
                companyService.updateCompany(c);
                session.setAttribute("flashSuccess", "Company details updated successfully.");

            } else if ("delete".equalsIgnoreCase(action)) {
                int companyId = Integer.parseInt(request.getParameter("companyId"));
                companyService.deleteCompany(companyId);
                session.setAttribute("flashSuccess", "Company deleted successfully.");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("flashError", e.getMessage());
        } catch (Exception e) {
            session.setAttribute("flashError", "Action failed: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/companies");
    }
}

