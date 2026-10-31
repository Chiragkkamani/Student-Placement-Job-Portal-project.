# Student Placement & Job Portal

An enterprise full-stack web application designed and built for the **Advanced Java Technologies (AJT)** university curriculum. The application bridges college students with placement and recruitment opportunities while giving placement administrators full control over students, companies, job listings, and application lifecycle workflows.

---

## 1. Architectural Overview & MVC Pattern

The portal strictly follows the **Model-View-Controller (MVC)** enterprise architecture using Jakarta EE standards:

```
[ Browser / Client ]
        │  ▲
        │  │ HTTP (HTML5, Bootstrap 5, JS)
        ▼  │
[ Controller Layer (Jakarta Servlets) ]
  ├── Authentication & Role Authorization Filters
  ├── Session Management & CSRF Validation
  └── Controller Servlets (Login, Register, Jobs, Profile, Admin)
        │  ▲
        ▼  │
[ Service Layer (Business Logic & Validation) ]
  ├── Eligibility Engine (CGPA, Branch, Expiration Check)
  ├── Security & BCrypt Password Hashing
  └── Transactional State Transition Managers
        │  ▲
        ▼  │
[ DAO Layer (Data Access Object / JDBC) ]
  ├── PreparedStatement Queries
  ├── HikariCP Connection Pooling
  └── Automatic Transaction Rollback/Commit
        │  ▲
        ▼  │
[ Relational Database (MySQL 8.x) ]
  └── placement_portal (Users, Students, Companies, Jobs, Applications, History)
```

---

## 2. Technology Stack

- **Frontend:** HTML5, CSS3, Bootstrap 5.3, Bootstrap Icons, JavaScript (Vanilla ES6+).
- **Presentation Layer:** JSP (JavaServer Pages), JSTL 3.0 (Jakarta Standard Tag Library), and Expression Language (EL 5.0).
- **Backend / Web Layer:** Core Java 17+, Jakarta Servlet API 6.0 (Tomcat 10.1 compatible).
- **Database Connectivity:** JDBC using MySQL Connector/J 8.3 and HikariCP 5.1 connection pool.
- **Database:** MySQL 8.x (`placement_portal`).
- **Server:** Apache Tomcat 10.1.x.
- **Security:** BCrypt password hashing (`org.mindrot:jbcrypt`), CSRF protection, session fixation mitigation (`request.changeSessionId()`), and role-based filters.
- **Build Tool:** Apache Maven 3.9+.

---

## 3. Database Schema Design

The application utilizes a relational database named `placement_portal` defined in `database.sql`:

1. `users`: Stores user identity, login email, BCrypt password hash, system role (`ADMIN`, `STUDENT`), and account status (`ACTIVE`, `INACTIVE`).
2. `students`: Stores academic profile linked to `users`, including unique `enrollment_number`, `branch`, `semester`, aggregate `cgpa`, contact `phone`, and relative `resume_path`.
3. `companies`: Stores recruiter organizations, industry sectors, locations, corporate websites, and contact emails.
4. `jobs`: Stores campus recruitment drives with company foreign key, job title, description, location, `minimum_cgpa`, `eligible_branch`, application `deadline`, and `job_status` (`ACTIVE`, `CLOSED`).
5. `applications`: Stores student job submissions with a **unique constraint** on `(student_id, job_id)` to prevent duplicate submissions. Tracks `application_status` (`APPLIED`, `SHORTLISTED`, `REJECTED`, `SELECTED`) and reviewer remarks.
6. `application_status_history`: Complete audit log tracking every status transition (`previous_status` -> `new_status`), timestamp, and the admin user who made the change.

---

## 4. Key Application Features

### For Students:
- **Registration & Authentication:** Secure registration with real-time academic validation (semester 1-8, CGPA 0.00-10.00).
- **Personal Dashboard:** Live counters of submitted, shortlisted, and selected applications; recent submissions table; and automatically recommended jobs matching the student's branch and CGPA.
- **Job Discovery & Search:** Browse campus drives with keyword search, location filtering, branch filtering, CGPA threshold filter, and deadline sorting.
- **Automatic Eligibility Check:** Instant evaluation against recruiter criteria. If a student's CGPA is below the requirement or their branch is not eligible, clear warnings are displayed and applications are blocked.
- **Profile & Resume Management:** Edit contact details and upload resumes (PDF/DOCX up to 5MB) with secure storage and preview.
- **Application Tracking:** Track application stages from `APPLIED` to `SHORTLISTED` and `SELECTED` along with recruiter remarks.

### For Administrators:
- **Placement Dashboard:** Real-time statistics on registered students, hiring partners, active drives, total applications, and a live application pipeline breakdown.
- **Manage Students:** Search student profiles, review academic performance, view uploaded resumes, toggle account activation statuses, or delete records.
- **Manage Companies:** Complete CRUD operations for recruiter partners with drive count tracking.
- **Manage Jobs:** Post, update, reactivate, or close job drives with customizable CGPA and branch requirements.
- **Application Review & Audit History:** Filter applications by status or job drive, update candidate statuses with interview remarks, and view full status history logs via an AJAX modal.

---

## 5. Prerequisites & Environment Setup

### Prerequisites:
1. **Java Development Kit (JDK):** Version 17 or higher.
2. **Apache Maven:** Version 3.8 or higher.
3. **MySQL Server:** Version 8.0 or higher.
4. **Apache Tomcat:** Version 10.1.x (Jakarta EE 10 compatible).

### Step 1: Initialize MySQL Database
1. Open MySQL CLI or MySQL Workbench:
   ```bash
   mysql -u root -p
   ```
2. Execute the database script:
   ```sql
   source /path/to/placement-portal/database.sql;
   ```
   *(Or import `database.sql` directly into your MySQL client).*

### Step 2: Configure Environment Variables
You can configure database credentials through environment variables or by editing `src/main/resources/portal.properties` or creating a `.env` file in the project root:

```ini
# Database Connection
DB_HOST=localhost
DB_PORT=3306
DB_NAME=placement_portal
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_POOL_SIZE=10

# Safe First Administrator Initialization (auto-created on startup if not present)
INITIAL_ADMIN_EMAIL=admin@placement.edu
INITIAL_ADMIN_PASSWORD=Admin@123
INITIAL_ADMIN_NAME=Placement Administrator
```

---

## 6. How to Build and Deploy

### Option A: Using the Automated Script (Windows)
Double-click `build.bat` in the project root directory. It will compile the source code, run all unit tests, and package `target/placement-portal.war`.

### Option B: Using Maven CLI
Open PowerShell or Command Prompt in the project folder:
```powershell
# Set Java 17 and Maven path if not in system PATH
$env:JAVA_HOME = "$HOME\.gemini\antigravity\tools\jdk-17"
$env:PATH = "$env:JAVA_HOME\bin;$HOME\.gemini\antigravity\tools\maven\bin;$env:PATH"

# Clean, run tests, and package WAR
mvn clean package
```

### Deploying to Apache Tomcat 10.1:
1. Locate the generated WAR file at:
   `target/placement-portal.war`
2. Copy `placement-portal.war` into your Tomcat installation directory:
   `$TOMCAT_HOME/webapps/placement-portal.war`
3. Start Apache Tomcat:
   - On Windows: `%TOMCAT_HOME%\bin\startup.bat`
   - On Linux/macOS: `$TOMCAT_HOME/bin/startup.sh`
4. Access the application in your browser at:
   ```
   http://localhost:8080/placement-portal/
   ```

---

## 7. Demo Accounts & Credentials

The database script automatically seeds verified sample accounts (passwords securely hashed using BCrypt):

| Role | Email / Admin ID | Password | Description |
| :--- | :--- | :--- | :--- |
| **Administrator (Primary)** | `chiragadmin` | `chirag@123` | Full access to Admin Console, Manage Accounts, Companies, Jobs, Applications |
| **Administrator (Alt)** | `admin@placement.edu` | `chirag@123` | Full access to Admin Console & Management |
| **Student (CS)** | `aarav.sharma@student.edu` | `Password@123` | Computer Science, CGPA 8.75, Sem 8 (Shortlisted for Google) |
| **Student (IT)** | `diya.patel@student.edu` | `Password@123` | Information Technology, CGPA 9.20, Sem 8 (Selected for Microsoft) |
| **Student (EC)** | `rohan.verma@student.edu` | `Password@123` | Electronics & Comm., CGPA 7.40, Sem 8 (Applied for AWS) |
| **Student (ME)** | `ananya.iyer@student.edu` | `Password@123` | Mechanical Engineering, CGPA 8.10, Sem 8 |

---

## 8. Admin Features & Account Management

Administrators can navigate to `/admin/users` or click **"Accounts"** in the top navigation bar to:
1. **Add Other Accounts**: Click **"+ Add New Account"** to create additional Administrator or Student accounts directly.
2. **Assign Roles**: Designate accounts as `ADMIN` or `STUDENT`.
3. **Toggle Status**: Activate or Deactivate any account with a single click.
4. **Reset Passwords**: Securely reset credentials for any user account.
5. **Delete Accounts**: Remove accounts with built-in safety controls preventing self-deletion.

---

## 8. Test Cases & Verification Guide

| Test Case | Steps to Test | Expected Result |
| :--- | :--- | :--- |
| **1. Student Registration** | Go to `/register`, fill out form with CGPA 8.5, Sem 8, CS branch. | Account created, redirected to `/login` with success alert. |
| **2. Duplicate Email Check** | Attempt to register again with `aarav.sharma@student.edu`. | Form rejected with server-side error "Email is already registered". |
| **3. Session Fixation Defense** | Sign in as student, inspect session cookie before and after login. | `JSESSIONID` is regenerated upon successful authentication. |
| **4. Student CGPA Eligibility** | Sign in as Rohan (CGPA 7.40) and try to apply for Microsoft (Min CGPA 8.50). | Application blocked with message "Your CGPA does not meet the minimum requirement". |
| **5. Duplicate Application Check** | Sign in as Aarav and open Google Cloud Engineer (already applied). | Button replaced with green "Application Submitted" banner. |
| **6. Closed Job Application** | Try to apply for Job ID 6 (Closed Drive). | Blocked with "This job opening is closed". |
| **7. Admin Job Management** | Sign in as Admin, go to `/admin/jobs`, add a new job opening. | Job appears on public `/jobs` page immediately. |
| **8. Status Transition Audit** | In `/admin/applications`, change an application from `APPLIED` to `SHORTLISTED` with remarks. Click "Audit History". | Audit log displays previous status, new status, timestamp, and admin name. |
| **9. Role-Based Access Control** | Sign in as a student and attempt to navigate to `/admin/dashboard`. | Request intercepted, 403 Access Denied page rendered. |
| **10. Resume Upload & Security** | In `/student/profile`, upload a `.pdf` resume (&lt; 5MB). Click "View Current File". | Resume streams securely via `/resume/download`. |

