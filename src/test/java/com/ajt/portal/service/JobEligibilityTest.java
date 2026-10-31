package com.ajt.portal.service;

import com.ajt.portal.model.Job;
import com.ajt.portal.model.Student;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

public class JobEligibilityTest {

    @Test
    public void testStudentEligibilityMatching() {
        Job job = new Job();
        job.setMinimumCgpa(new BigDecimal("7.50"));
        job.setEligibleBranch("Computer Science");
        job.setDeadline(Date.valueOf(LocalDate.now().plusDays(10)));
        job.setJobStatus(Job.STATUS_ACTIVE);

        Student eligibleStudent = new Student();
        eligibleStudent.setCgpa(new BigDecimal("8.20"));
        eligibleStudent.setBranch("Computer Science");

        assertTrue(job.isEligible(eligibleStudent));

        Student lowCgpaStudent = new Student();
        lowCgpaStudent.setCgpa(new BigDecimal("7.20"));
        lowCgpaStudent.setBranch("Computer Science");

        assertFalse(job.isEligible(lowCgpaStudent));

        Student wrongBranchStudent = new Student();
        wrongBranchStudent.setCgpa(new BigDecimal("9.00"));
        wrongBranchStudent.setBranch("Mechanical Engineering");

        assertFalse(job.isEligible(wrongBranchStudent));
    }

    @Test
    public void testAllBranchesEligibility() {
        Job job = new Job();
        job.setMinimumCgpa(new BigDecimal("6.00"));
        job.setEligibleBranch("All Branches");

        Student student = new Student();
        student.setCgpa(new BigDecimal("6.50"));
        student.setBranch("Mechanical Engineering");

        assertTrue(job.isEligible(student));
    }

    @Test
    public void testJobExpiration() {
        Job expiredJob = new Job();
        expiredJob.setDeadline(Date.valueOf(LocalDate.now().minusDays(1)));
        assertTrue(expiredJob.isExpired());

        Job activeJob = new Job();
        activeJob.setDeadline(Date.valueOf(LocalDate.now().plusDays(5)));
        assertFalse(activeJob.isExpired());
    }
}

