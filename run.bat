@echo off
echo ===============================================================================
echo Starting Student Placement and Job Portal on Apache Tomcat 10.1
echo ===============================================================================

set "JAVA_HOME=%USERPROFILE%\.gemini\antigravity\tools\jdk-17"
set "CATALINA_HOME=%USERPROFILE%\.gemini\antigravity\tools\tomcat-10.1"
set "PATH=%JAVA_HOME%\bin;%CATALINA_HOME%\bin;%USERPROFILE%\.gemini\antigravity\tools\maven\bin;%PATH%"

echo Deploying placement-portal.war to Tomcat...
copy /Y "target\placement-portal.war" "%CATALINA_HOME%\webapps\placement-portal.war"

echo.
echo ===============================================================================
echo Application URL: http://localhost:8080/placement-portal/
echo Default Admin:   admin@placement.edu / Admin@123
echo Default Student: aarav.sharma@student.edu / Password@123
echo Press Ctrl+C in this terminal window to stop the server.
echo ===============================================================================
echo.

call "%CATALINA_HOME%\bin\catalina.bat" run

