package com.ajt.portal.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class PasswordUtilTest {

    @Test
    public void testHashAndVerify() {
        String plain = "Admin@123";
        String hashed = PasswordUtil.hashPassword(plain);

        assertNotNull(hashed);
        assertTrue(hashed.startsWith("$2a$") || hashed.startsWith("$2b$"));
        assertTrue(PasswordUtil.checkPassword(plain, hashed));
        assertFalse(PasswordUtil.checkPassword("WrongPassword", hashed));
    }

    @Test
    public void testEmptyPassword() {
        assertThrows(IllegalArgumentException.class, () -> PasswordUtil.hashPassword(""));
        assertThrows(IllegalArgumentException.class, () -> PasswordUtil.hashPassword(null));
        assertFalse(PasswordUtil.checkPassword(null, "hash"));
        assertFalse(PasswordUtil.checkPassword("pass", null));
    }
}

