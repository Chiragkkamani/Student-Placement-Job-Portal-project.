package com.ajt.portal.util;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.regex.Pattern;

public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,63}$"
    );

    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^[+]?[0-9\\s\\-()]{7,20}$"
    );

    private ValidationUtil() {
    }

    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    public static boolean isValidLength(String str, int min, int max) {
        if (str == null) return min == 0;
        int len = str.trim().length();
        return len >= min && len <= max;
    }

    public static boolean isValidEmail(String email) {
        if (!isNotEmpty(email)) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (!isNotEmpty(phone)) return false;
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isValidCgpa(BigDecimal cgpa) {
        if (cgpa == null) return false;
        return cgpa.compareTo(BigDecimal.ZERO) >= 0 && cgpa.compareTo(BigDecimal.valueOf(10.00)) <= 0;
    }

    public static boolean isValidCgpaString(String cgpaStr) {
        if (!isNotEmpty(cgpaStr)) return false;
        try {
            BigDecimal cgpa = new BigDecimal(cgpaStr.trim());
            return isValidCgpa(cgpa);
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static boolean isValidFutureDate(String dateStr) {
        if (!isNotEmpty(dateStr)) return false;
        try {
            LocalDate date = LocalDate.parse(dateStr.trim());
            return !date.isBefore(LocalDate.now());
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    public static String sanitize(String input) {
        if (input == null) return "";
        return input.trim()
            .replace("<", "&lt;")
            .replace(">", "&gt;");
    }
}

