@echo off
echo ===============================================================================
echo Student Placement and Job Portal - Maven Build Script
echo ===============================================================================

set "JAVA_HOME=%USERPROFILE%\.gemini\antigravity\tools\jdk-17"
set "PATH=%JAVA_HOME%\bin;%USERPROFILE%\.gemini\antigravity\tools\maven\bin;%PATH%"

echo Using Java:
java -version

echo Using Maven:
call mvn -version

echo.
echo Building placement-portal.war...
call mvn clean package -DskipTests=false

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ===============================================================================
    echo BUILD SUCCESS!
    echo WAR File generated at: target\placement-portal.war
    echo To deploy: Copy target\placement-portal.war to your Tomcat 10.1 'webapps' folder.
    echo ===============================================================================
) else (
    echo.
    echo [ERROR] Build failed. Please inspect the output above.
)

pause

