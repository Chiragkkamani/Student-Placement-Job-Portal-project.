package com.ajt.portal.util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

public final class FileUploadUtil {

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5 MB
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".pdf", ".docx", ".doc");

    private FileUploadUtil() {
    }

    /**
     * Validates and saves an uploaded resume Part to disk.
     * Returns the relative path to be stored in the database.
     */
    public static String saveResume(Part part, String baseUploadDir) throws IOException, IllegalArgumentException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        if (part.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("File size exceeds 5MB limit.");
        }

        String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String fileExt = "";
        int dotIndex = submittedFileName.lastIndexOf('.');
        if (dotIndex >= 0) {
            fileExt = submittedFileName.substring(dotIndex).toLowerCase();
        }

        if (!ALLOWED_EXTENSIONS.contains(fileExt)) {
            throw new IllegalArgumentException("Invalid file format. Only PDF, DOCX, and DOC files are permitted.");
        }

        // Generate sanitized unique file name
        String uniqueFileName = "resume_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8) + fileExt;

        File uploadDirFile = new File(baseUploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs();
        }

        Path destinationPath = Paths.get(baseUploadDir, uniqueFileName);
        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, destinationPath, StandardCopyOption.REPLACE_EXISTING);
        }

        return "uploads/resumes/" + uniqueFileName;
    }
}

