package com.ajt.portal.service;

import com.ajt.portal.dao.ApplicationDAO;
import com.ajt.portal.dao.ApplicationStatusHistoryDAO;
import com.ajt.portal.dao.JobDAO;
import com.ajt.portal.dao.StudentDAO;
import com.ajt.portal.model.Application;
import com.ajt.portal.model.Job;
import com.ajt.portal.model.Student;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ApplicationServiceUnitTest {

    @Mock
    private ApplicationDAO applicationDAO;

    @Mock
    private ApplicationStatusHistoryDAO historyDAO;

    @Mock
    private JobDAO jobDAO;

    @Mock
    private StudentDAO studentDAO;

    private ApplicationService applicationService;

    @BeforeEach
    public void setUp() {
        applicationService = new ApplicationService(applicationDAO, historyDAO, jobDAO, studentDAO);
    }

    @Test
    public void testRejectApplicationWhenStudentCgpaBelowRequirement() throws SQLException {
        Student student = new Student();
        student.setStudentId(1);
        student.setCgpa(new BigDecimal("6.50"));
        student.setBranch("Computer Science");

        Job job = new Job();
        job.setJobId(10);
        job.setMinimumCgpa(new BigDecimal("7.50"));
        job.setEligibleBranch("Computer Science");
        job.setDeadline(Date.valueOf(LocalDate.now().plusDays(5)));
        job.setJobStatus(Job.STATUS_ACTIVE);

        when(studentDAO.findById(1)).thenReturn(student);
        when(jobDAO.findById(10)).thenReturn(job);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
            applicationService.applyForJob(1, 10, "Looking forward")
        );
        assertTrue(ex.getMessage().contains("CGPA"));
    }

    @Test
    public void testRejectApplicationWhenJobClosed() throws SQLException {
        Student student = new Student();
        student.setStudentId(2);
        student.setCgpa(new BigDecimal("8.50"));
        student.setBranch("Information Technology");

        Job job = new Job();
        job.setJobId(11);
        job.setJobStatus(Job.STATUS_CLOSED);
        job.setDeadline(Date.valueOf(LocalDate.now().plusDays(5)));

        when(studentDAO.findById(2)).thenReturn(student);
        when(jobDAO.findById(11)).thenReturn(job);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
            applicationService.applyForJob(2, 11, null)
        );
        assertTrue(ex.getMessage().contains("closed"));
    }

    @Test
    public void testRejectDuplicateApplication() throws SQLException {
        Student student = new Student();
        student.setStudentId(3);
        student.setCgpa(new BigDecimal("9.00"));
        student.setBranch("Computer Science");

        Job job = new Job();
        job.setJobId(12);
        job.setJobStatus(Job.STATUS_ACTIVE);
        job.setDeadline(Date.valueOf(LocalDate.now().plusDays(5)));

        Application existingApp = new Application();
        existingApp.setApplicationId(100);

        when(studentDAO.findById(3)).thenReturn(student);
        when(jobDAO.findById(12)).thenReturn(job);
        when(applicationDAO.findByStudentAndJob(3, 12)).thenReturn(existingApp);

        IllegalStateException ex = assertThrows(IllegalStateException.class, () ->
            applicationService.applyForJob(3, 12, null)
        );
        assertTrue(ex.getMessage().contains("already applied"));
    }

    @Test
    public void testHrCannotUpdateAnotherCompanyApplication() throws SQLException {
        // Application belongs to Company 2, but Recruiter is from Company 1
        when(applicationDAO.findByIdAndCompany(50, 1)).thenReturn(null);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () ->
            applicationService.updateApplicationStatusForCompany(50, 1, "SHORTLISTED", "Notes", 27)
        );
        assertTrue(ex.getMessage().contains("unauthorized"));
    }
}

