-- =============================================================================
-- Placement Portal Universal Schema & Seed (MySQL & H2 Compatible)
-- =============================================================================

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'STUDENT',
    account_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    enrollment_number VARCHAR(30) NOT NULL UNIQUE,
    branch VARCHAR(50) NOT NULL,
    semester INT NOT NULL,
    cgpa DECIMAL(3, 2) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    resume_path VARCHAR(255) DEFAULT NULL,
    CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(120) NOT NULL UNIQUE,
    industry VARCHAR(80) NOT NULL,
    location VARCHAR(100) NOT NULL,
    website VARCHAR(255) DEFAULT NULL,
    contact_email VARCHAR(120) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE users ADD COLUMN IF NOT EXISTS company_id INT DEFAULT NULL;

CREATE TABLE IF NOT EXISTS jobs (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    company_id INT NOT NULL,
    job_title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(100) NOT NULL,
    minimum_cgpa DECIMAL(3, 2) NOT NULL DEFAULT 0.00,
    eligible_branch VARCHAR(100) NOT NULL DEFAULT 'All Branches',
    deadline DATE NOT NULL,
    job_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_jobs_company FOREIGN KEY (company_id) REFERENCES companies (company_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT NOT NULL,
    student_id INT NOT NULL,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    application_status VARCHAR(20) NOT NULL DEFAULT 'APPLIED',
    remarks VARCHAR(255) DEFAULT 'Application submitted',
    CONSTRAINT fk_apps_job FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE,
    CONSTRAINT fk_apps_student FOREIGN KEY (student_id) REFERENCES students (student_id) ON DELETE CASCADE,
    CONSTRAINT uq_student_job UNIQUE (student_id, job_id)
);

CREATE TABLE IF NOT EXISTS application_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    previous_status VARCHAR(20) DEFAULT NULL,
    new_status VARCHAR(20) NOT NULL,
    changed_by INT DEFAULT NULL,
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_history_app FOREIGN KEY (application_id) REFERENCES applications (application_id) ON DELETE CASCADE
);

-- Initial Users (Password: chirag@123 for Admin / Password@123 for Students)
-- Hash for chirag@123: $2a$10$O73KViZ3fUTOfY3mPd4vfeZc6c4bZhnGqI8udNldVIkpvg4ircGem
-- Hash for Password@123: $2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe
MERGE INTO users (full_name, email, password_hash, role, account_status, company_id) KEY(email) VALUES
('Placement Administrator', 'admin@placement.edu', '$2a$10$O73KViZ3fUTOfY3mPd4vfeZc6c4bZhnGqI8udNldVIkpvg4ircGem', 'ADMIN', 'ACTIVE', NULL),
('Aarav Sharma', 'aarav.sharma@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Diya Patel', 'diya.patel@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Rohan Verma', 'rohan.verma@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Ananya Iyer', 'ananya.iyer@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Chirag Administrator', 'chiragadmin', '$2a$10$O73KViZ3fUTOfY3mPd4vfeZc6c4bZhnGqI8udNldVIkpvg4ircGem', 'ADMIN', 'ACTIVE', NULL),
('Aditya Sengupta', 'aditya.sengupta@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Pooja Nair', 'pooja.nair@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Gurpreet Singh', 'gurpreet.singh@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Sneha Kulkarni', 'sneha.kulkarni@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Karthik Venkatesh', 'karthik.venkatesh@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Tanvi Deshmukh', 'tanvi.deshmukh@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Harshvardhan Rathore', 'harsh.rathore@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Rhea Bhattacharya', 'rhea.bhattacharya@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Sai Krishna Teja', 'sai.krishna@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Meera Nambiar', 'meera.nambiar@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Abhishek Mishra', 'abhishek.mishra@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Neha Choudhary', 'neha.choudhary@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Vikramaditya Rao', 'vikram.rao@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Shruti Majumdar', 'shruti.majumdar@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Manish Chawla', 'manish.chawla@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Kavya Hegde', 'kavya.hegde@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Tsering Angmo', 'tsering.angmo@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Pranav Trivedi', 'pranav.trivedi@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Deepika Reddy', 'deepika.reddy@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Mohammad Zubair', 'mohammad.zubair@student.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'STUDENT', 'ACTIVE', NULL),
('Priya Sharma', 'google.hr@placement.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'COMPANY_HR', 'ACTIVE', 1),
('Google Cloud HR', 'googlehr', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'COMPANY_HR', 'ACTIVE', 1),
('Vikram Malhotra', 'tcs.hr@placement.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'COMPANY_HR', 'ACTIVE', 4),
('TCS Recruiter', 'tcshr', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'COMPANY_HR', 'ACTIVE', 4),
('Sneha Kapadia', 'ms.hr@placement.edu', '$2a$10$/IUf2j6/ZYHYWB/DTeZkC.jPiJURAIYtTWOXdTG/0TRAFm9zwSPEe', 'COMPANY_HR', 'ACTIVE', 2);

-- Initial Students (24 Total from Across India)
INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024CS0101', 'Computer Science', 8, 8.75, '+91 9876543210', 'uploads/resumes/aarav_resume.pdf'
FROM users u WHERE u.email = 'aarav.sharma@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024CS0101');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024IT0202', 'Information Technology', 8, 9.20, '+91 9876543211', 'uploads/resumes/diya_resume.pdf'
FROM users u WHERE u.email = 'diya.patel@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024IT0202');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024EC0303', 'Electronics & Comm.', 8, 7.40, '+91 9876543212', NULL
FROM users u WHERE u.email = 'rohan.verma@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024EC0303');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024ME0404', 'Mechanical Engineering', 8, 8.10, '+91 9876543213', NULL
FROM users u WHERE u.email = 'ananya.iyer@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024ME0404');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024CS0105', 'Computer Science', 8, 9.15, '+91 9830123456', 'uploads/resumes/aditya_resume.pdf'
FROM users u WHERE u.email = 'aditya.sengupta@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024CS0105');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024IT0206', 'Information Technology', 8, 8.90, '+91 9447123456', 'uploads/resumes/pooja_resume.pdf'
FROM users u WHERE u.email = 'pooja.nair@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024IT0206');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024ME0407', 'Mechanical Engineering', 8, 7.85, '+91 9814123456', NULL
FROM users u WHERE u.email = 'gurpreet.singh@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024ME0407');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024CS0108', 'Computer Science', 8, 9.45, '+91 9822123456', 'uploads/resumes/sneha_resume.pdf'
FROM users u WHERE u.email = 'sneha.kulkarni@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024CS0108');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024EC0309', 'Electronics & Comm.', 8, 8.60, '+91 9840123456', 'uploads/resumes/karthik_resume.pdf'
FROM users u WHERE u.email = 'karthik.venkatesh@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024EC0309');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024IT0210', 'Information Technology', 8, 8.35, '+91 9765123456', NULL
FROM users u WHERE u.email = 'tanvi.deshmukh@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024IT0210');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024ME0411', 'Mechanical Engineering', 8, 7.50, '+91 9414123456', NULL
FROM users u WHERE u.email = 'harsh.rathore@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024ME0411');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024CS0112', 'Computer Science', 8, 9.05, '+91 9435123456', 'uploads/resumes/rhea_resume.pdf'
FROM users u WHERE u.email = 'rhea.bhattacharya@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024CS0112');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024EC0313', 'Electronics & Comm.', 8, 8.40, '+91 9848123456', 'uploads/resumes/sai_resume.pdf'
FROM users u WHERE u.email = 'sai.krishna@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024EC0313');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024CS0114', 'Computer Science', 8, 9.30, '+91 9446123456', 'uploads/resumes/meera_resume.pdf'
FROM users u WHERE u.email = 'meera.nambiar@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024CS0114');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024IT0215', 'Information Technology', 8, 7.95, '+91 9450123456', NULL
FROM users u WHERE u.email = 'abhishek.mishra@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024IT0215');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024CS0116', 'Computer Science', 8, 8.70, '+91 9431123456', 'uploads/resumes/neha_resume.pdf'
FROM users u WHERE u.email = 'neha.choudhary@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024CS0116');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024ME0417', 'Mechanical Engineering', 8, 8.20, '+91 9880123456', 'uploads/resumes/vikram_resume.pdf'
FROM users u WHERE u.email = 'vikram.rao@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024ME0417');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024EC0318', 'Electronics & Comm.', 8, 8.15, '+91 9437123456', NULL
FROM users u WHERE u.email = 'shruti.majumdar@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024EC0318');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024CS0119', 'Computer Science', 8, 9.60, '+91 9811123456', 'uploads/resumes/manish_resume.pdf'
FROM users u WHERE u.email = 'manish.chawla@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024CS0119');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024IT0220', 'Information Technology', 8, 8.85, '+91 9845123456', 'uploads/resumes/kavya_resume.pdf'
FROM users u WHERE u.email = 'kavya.hegde@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024IT0220');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024EC0321', 'Electronics & Comm.', 8, 8.00, '+91 9419123456', NULL
FROM users u WHERE u.email = 'tsering.angmo@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024EC0321');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024ME0422', 'Mechanical Engineering', 8, 7.65, '+91 9825123456', NULL
FROM users u WHERE u.email = 'pranav.trivedi@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024ME0422');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024CS0123', 'Computer Science', 8, 9.25, '+91 9849123456', 'uploads/resumes/deepika_resume.pdf'
FROM users u WHERE u.email = 'deepika.reddy@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024CS0123');

INSERT INTO students (user_id, enrollment_number, branch, semester, cgpa, phone, resume_path)
SELECT u.user_id, 'EN2024IT0224', 'Information Technology', 8, 8.55, '+91 9419123457', 'uploads/resumes/zubair_resume.pdf'
FROM users u WHERE u.email = 'mohammad.zubair@student.edu'
AND NOT EXISTS (SELECT 1 FROM students s WHERE s.enrollment_number = 'EN2024IT0224');

-- Initial Companies
MERGE INTO companies (company_id, company_name, industry, location, website, contact_email) KEY(company_name) VALUES
(1, 'Google Cloud', 'Information Technology & Cloud', 'Bengaluru, India', 'https://cloud.google.com', 'careers@google.com'),
(2, 'Microsoft Corporation', 'Software & AI Systems', 'Hyderabad, India', 'https://careers.microsoft.com', 'recruitment@microsoft.com'),
(3, 'Amazon Web Services', 'Cloud Computing & Logistics', 'Bengaluru, India', 'https://amazon.jobs', 'aws-hiring@amazon.com'),
(4, 'Tata Consultancy Services', 'IT Services & Consulting', 'Mumbai, India', 'https://tcs.com/careers', 'campus@tcs.com'),
(5, 'Infosys Technologies', 'Digital Services & Consulting', 'Pune, India', 'https://infosys.com/careers', 'freshers@infosys.com'),
(6, 'Cisco Systems', 'Networking & Cloud Security', 'Bengaluru, India', 'https://cisco.com/careers', 'university-recruiting@cisco.com'),
(7, 'Oracle Corporation', 'Cloud Database & Enterprise Systems', 'Hyderabad, India', 'https://oracle.com/careers', 'campus-india@oracle.com'),
(8, 'IBM India', 'Cognitive & Hybrid Cloud', 'Gurugram, India', 'https://ibm.com/employment', 'talent-india@ibm.com'),
(9, 'Goldman Sachs', 'Financial Technology & Engineering', 'Bengaluru, India', 'https://goldmansachs.com/careers', 'campusrecruiting@gs.com'),
(10, 'Intel Technology', 'Semiconductor & Embedded Systems', 'Bengaluru, India', 'https://intel.com/jobs', 'student-careers@intel.com');

-- Initial Jobs (26 Total Openings)
MERGE INTO jobs (job_id, company_id, job_title, description, location, minimum_cgpa, eligible_branch, deadline, job_status) KEY(job_id) VALUES
(1, 1, 'Associate Cloud Engineer', 'Design, develop, and scale enterprise cloud solutions using Google Cloud Platform, Kubernetes, and Go/Java microservices.', 'Bengaluru, India', 8.00, 'Computer Science', '2026-12-31', 'ACTIVE'),
(2, 2, 'Software Development Engineer - Backend', 'Develop resilient high-throughput backend services using Core Java, Spring, and Azure cloud infrastructure.', 'Hyderabad, India', 8.50, 'All Branches', '2026-11-30', 'ACTIVE'),
(3, 3, 'Systems Support & DevOps Associate', 'Build CI/CD automation pipelines, monitor AWS cloud infrastructure, and troubleshoot production deployment pipelines.', 'Bengaluru, India', 7.00, 'All Branches', '2026-12-15', 'ACTIVE'),
(4, 4, 'Associate Software Engineer (Digital)', 'Full-stack software engineering position focusing on Enterprise Java, RESTful APIs, and modern front-end frameworks.', 'Mumbai, India', 6.50, 'All Branches', '2026-11-20', 'ACTIVE'),
(5, 5, 'Specialist Programmer', 'High-complexity software design, competitive programming, and backend architectural development.', 'Pune, India', 7.50, 'Information Technology', '2026-12-10', 'ACTIVE'),
(6, 1, 'Cloud Data Analytics Intern (Closed)', 'Analyze big data streams with Apache Beam and BigQuery. Application window is closed for evaluation.', 'Bengaluru, India', 8.00, 'Computer Science', '2026-01-15', 'CLOSED'),
(7, 2, 'Frontend Software Development Engineer', 'Build intuitive, high-performance web applications using React, TypeScript, and modern enterprise microfrontends.', 'Hyderabad, India', 7.50, 'All Branches', '2026-12-20', 'ACTIVE'),
(8, 1, 'Cloud Security Specialist', 'Safeguard Google Cloud infrastructure, design identity access management policies, and implement threat mitigation protocols.', 'Bengaluru, India', 8.20, 'Computer Science', '2026-12-18', 'ACTIVE'),
(9, 3, 'Full Stack Java & Cloud Developer', 'Design resilient distributed applications using AWS Lambda, Spring Boot, DynamoDB, and modern frontend frameworks.', 'Bengaluru, India', 7.00, 'Computer Science', '2026-12-25', 'ACTIVE'),
(10, 7, 'Enterprise Data Pipeline Engineer', 'Architect high-throughput data integration pipelines and autonomous database systems on Oracle Cloud Infrastructure.', 'Hyderabad, India', 7.50, 'All Branches', '2026-12-12', 'ACTIVE'),
(11, 6, 'Network Software & Protocols Engineer', 'Develop next-generation SDN routing, switching firmware, and telemetry analytics using C++ and Python.', 'Bengaluru, India', 7.20, 'Information Technology', '2026-12-22', 'ACTIVE'),
(12, 1, 'Site Reliability Engineer (SRE)', 'Automate cloud reliability, monitoring, disaster recovery workflows, and distributed container orchestration.', 'Bengaluru, India', 8.00, 'All Branches', '2026-12-28', 'ACTIVE'),
(13, 9, 'Quantitative Analyst & Platform Developer', 'Implement algorithmic pricing models, low-latency financial trading microservices, and mathematical simulations.', 'Bengaluru, India', 8.50, 'All Branches', '2026-12-15', 'ACTIVE'),
(14, 10, 'Embedded Firmware & Systems Engineer', 'Develop board-support packages, RTOS device drivers, and low-level firmware for next-gen silicon processors.', 'Bengaluru, India', 7.80, 'Electronics & Comm.', '2026-12-24', 'ACTIVE'),
(15, 4, 'Enterprise Systems & Automation Analyst', 'Optimize mission-critical enterprise workflows, robotic process automation (RPA), and enterprise cloud integration.', 'Mumbai, India', 6.50, 'All Branches', '2026-12-05', 'ACTIVE'),
(16, 8, 'Artificial Intelligence & ML Specialist', 'Build generative AI applications, retrieval-augmented generation pipelines, and model deployment architectures.', 'Gurugram, India', 8.25, 'Computer Science', '2026-12-31', 'ACTIVE'),
(17, 5, 'Core Java Microservices Engineer', 'Modernize monolithic applications into event-driven microservices using Kafka, Docker, and Jakarta EE standards.', 'Pune, India', 7.00, 'All Branches', '2026-12-18', 'ACTIVE'),
(18, 6, 'Cybersecurity Operations & Threat Analyst', 'Monitor network security events, conduct vulnerability assessments, and implement zero-trust network architectures.', 'Bengaluru, India', 7.50, 'Information Technology', '2026-12-14', 'ACTIVE'),
(19, 7, 'Cloud Database Infrastructure Specialist', 'Tune high-performance SQL query engines, configure high-availability clusters, and manage autonomous databases.', 'Hyderabad, India', 7.00, 'All Branches', '2026-12-29', 'ACTIVE'),
(20, 2, 'Mobile Applications Developer', 'Design cross-platform native mobile applications with modern UI/UX patterns, offline caching, and biometric auth.', 'Hyderabad, India', 7.50, 'Computer Science', '2026-12-16', 'ACTIVE'),
(21, 10, 'Robotics & Hardware Automation Engineer', 'Develop automated industrial hardware testbeds, computer vision tracking, and motion control systems.', 'Bengaluru, India', 7.50, 'Mechanical Engineering', '2026-12-21', 'ACTIVE'),
(22, 3, 'Big Data & Analytics Solutions Architect', 'Implement streaming analytics solutions using Apache Spark, Kafka, and cloud data warehousing platforms.', 'Bengaluru, India', 8.00, 'Computer Science', '2026-12-27', 'ACTIVE'),
(23, 9, 'Financial Software & Core Banking Developer', 'Design high-frequency distributed ledger technologies, transactional APIs, and risk monitoring pipelines.', 'Bengaluru, India', 8.20, 'Information Technology', '2026-12-19', 'ACTIVE'),
(24, 8, 'Cognitive Computing & NLP Intern', 'Research natural language processing algorithms, evaluate LLM capabilities, and prepare training datasets.', 'Gurugram, India', 7.80, 'All Branches', '2026-12-11', 'ACTIVE'),
(25, 10, 'Hardware Verification & VLSI Engineer', 'Execute digital design verification, SystemVerilog testbenches, and UVM validation for advanced microchips.', 'Bengaluru, India', 7.60, 'Electronics & Comm.', '2026-12-23', 'ACTIVE'),
(26, 4, 'Automotive Embedded Systems Engineer', 'Program automotive microcontrollers, CAN bus communications, and real-time electronic control unit (ECU) software.', 'Pune, India', 6.80, 'Mechanical Engineering', '2026-12-30', 'ACTIVE');

-- Initial Applications
INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 1, s.student_id, 'SHORTLISTED', 'Candidate shortlisted for technical coding interview round.'
FROM students s WHERE s.enrollment_number = 'EN2024CS0101'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 1 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 2, s.student_id, 'SELECTED', 'Candidate selected after final partner interview. Offer letter released.'
FROM students s WHERE s.enrollment_number = 'EN2024IT0202'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 2 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 3, s.student_id, 'APPLIED', 'Application under preliminary recruiter review.'
FROM students s WHERE s.enrollment_number = 'EN2024EC0303'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 3 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 4, s.student_id, 'APPLIED', 'Application submitted successfully.'
FROM students s WHERE s.enrollment_number = 'EN2024CS0101'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 4 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 1, s.student_id, 'SHORTLISTED', 'High CGPA candidate. Qualified for Round 2 Technical Interview.'
FROM students s WHERE s.enrollment_number = 'EN2024CS0105'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 1 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 2, s.student_id, 'SELECTED', 'Excellent coding assessment score. Final offer released (CTC: 24 LPA).'
FROM students s WHERE s.enrollment_number = 'EN2024CS0108'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 2 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 7, s.student_id, 'APPLIED', 'Application under review by technical hiring manager.'
FROM students s WHERE s.enrollment_number = 'EN2024IT0206'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 7 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 8, s.student_id, 'SHORTLISTED', 'Cleared preliminary cybersecurity screening round.'
FROM students s WHERE s.enrollment_number = 'EN2024CS0112'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 8 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 9, s.student_id, 'APPLIED', 'Application submitted for Full Stack Cloud position.'
FROM students s WHERE s.enrollment_number = 'EN2024CS0114'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 9 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 10, s.student_id, 'SELECTED', 'Selected for Oracle Cloud Infrastructure engineering team.'
FROM students s WHERE s.enrollment_number = 'EN2024IT0210'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 10 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 11, s.student_id, 'INTERVIEW_SCHEDULED', 'Technical Interview scheduled for next week.'
FROM students s WHERE s.enrollment_number = 'EN2024EC0309'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 11 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 13, s.student_id, 'SELECTED', 'Offered Quantitative Developer role at Goldman Sachs.'
FROM students s WHERE s.enrollment_number = 'EN2024CS0119'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 13 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 14, s.student_id, 'SHORTLISTED', 'Shortlisted for Intel Hardware test round.'
FROM students s WHERE s.enrollment_number = 'EN2024EC0318'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 14 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 16, s.student_id, 'APPLIED', 'Application submitted for AI/ML Specialist opening.'
FROM students s WHERE s.enrollment_number = 'EN2024CS0123'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 16 AND a.student_id = s.student_id);

INSERT INTO applications (job_id, student_id, application_status, remarks)
SELECT 23, s.student_id, 'SHORTLISTED', 'Shortlisted based on IT and Distributed Systems coursework.'
FROM students s WHERE s.enrollment_number = 'EN2024IT0224'
AND NOT EXISTS (SELECT 1 FROM applications a WHERE a.job_id = 23 AND a.student_id = s.student_id);

