package com.ajt.portal.service;

import com.ajt.portal.dao.StudentDAO;
import com.ajt.portal.dao.UserDAO;
import com.ajt.portal.model.User;
import com.ajt.portal.util.PasswordUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

public class UserServiceTest {

    private UserDAO mockUserDao;
    private StudentDAO mockStudentDao;
    private UserService userService;

    @BeforeEach
    public void setUp() {
        mockUserDao = Mockito.mock(UserDAO.class);
        mockStudentDao = Mockito.mock(StudentDAO.class);
        userService = new UserService(mockUserDao, mockStudentDao);
    }

    @Test
    public void testAuthenticateWithChiragAdminId() throws SQLException {
        User admin = new User();
        admin.setUserId(6);
        admin.setFullName("Chirag Administrator");
        admin.setEmail("chiragadmin");
        admin.setRole(User.ROLE_ADMIN);
        admin.setAccountStatus(User.STATUS_ACTIVE);
        admin.setPasswordHash(PasswordUtil.hashPassword("chirag@123"));

        when(mockUserDao.findByEmailOrUsername("chiragadmin")).thenReturn(admin);

        User authenticated = userService.authenticate("chiragadmin", "chirag@123");
        assertNotNull(authenticated);
        assertEquals("Chirag Administrator", authenticated.getFullName());
        assertTrue(authenticated.isAdmin());

        // Invalid password test
        User failed = userService.authenticate("chiragadmin", "wrongpass");
        assertNull(failed);
    }

    @Test
    public void testAdminCreatesAccount() throws SQLException {
        when(mockUserDao.findByEmail(anyString())).thenReturn(null);
        when(mockUserDao.create(any(User.class))).thenReturn(10);

        User created = userService.createAccountByAdmin("New Staff", "staff@placement.edu", "StaffPass@123", User.ROLE_ADMIN, User.STATUS_ACTIVE);
        assertNotNull(created);
        assertEquals("staff@placement.edu", created.getEmail());
        assertEquals(User.ROLE_ADMIN, created.getRole());
        verify(mockUserDao, times(1)).create(any(User.class));
    }

    @Test
    public void testUpdatePasswordValidation() throws SQLException {
        when(mockUserDao.updatePassword(eq(6), anyString())).thenReturn(true);

        boolean updated = userService.updatePassword(6, "chirag@123");
        assertTrue(updated);

        assertThrows(IllegalArgumentException.class, () -> {
            userService.updatePassword(6, "123"); // too short
        });
    }
}

