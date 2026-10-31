package com.ajt.portal.util;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

public class ValidationUtilTest {

    @Test
    public void testValidEmail() {
        assertTrue(ValidationUtil.isValidEmail("student@university.edu"));
        assertTrue(ValidationUtil.isValidEmail("john.doe@company.com"));
        assertFalse(ValidationUtil.isValidEmail("invalid-email"));
        assertFalse(ValidationUtil.isValidEmail("@nodomain.com"));
        assertFalse(ValidationUtil.isValidEmail(null));
        assertFalse(ValidationUtil.isValidEmail("   "));
    }

    @Test
    public void testValidPhone() {
        assertTrue(ValidationUtil.isValidPhone("+91 9876543210"));
        assertTrue(ValidationUtil.isValidPhone("9876543210"));
        assertTrue(ValidationUtil.isValidPhone("(079) 1234567"));
        assertFalse(ValidationUtil.isValidPhone("123")); // too short
        assertFalse(ValidationUtil.isValidPhone("abc-phone"));
        assertFalse(ValidationUtil.isValidPhone(null));
    }

    @Test
    public void testValidCgpa() {
        assertTrue(ValidationUtil.isValidCgpa(new BigDecimal("8.50")));
        assertTrue(ValidationUtil.isValidCgpa(BigDecimal.ZERO));
        assertTrue(ValidationUtil.isValidCgpa(new BigDecimal("10.00")));
        assertFalse(ValidationUtil.isValidCgpa(new BigDecimal("-1.00")));
        assertFalse(ValidationUtil.isValidCgpa(new BigDecimal("10.01")));
        assertFalse(ValidationUtil.isValidCgpa(null));
    }

    @Test
    public void testSanitize() {
        assertEquals("&lt;script&gt;alert(1)&lt;/script&gt;", ValidationUtil.sanitize("<script>alert(1)</script>"));
        assertEquals("Clean Text", ValidationUtil.sanitize("  Clean Text  "));
        assertEquals("", ValidationUtil.sanitize(null));
    }
}

