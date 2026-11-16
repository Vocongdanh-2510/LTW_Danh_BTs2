@echo off
set "JAVA_HOME=C:\Program Files\Java\jdk-27.0.1.0.3"
if not exist "%JAVA_HOME%" set "JAVA_HOME=C:\Program Files\Java\latest"
if not exist "%JAVA_HOME%" set "JAVA_HOME=C:\Program Files\Java\jdk-21.0.12"

set "CATALINA_HOME=C:\Tomcat11\apache-tomcat-11.0.27"
if not exist "%CATALINA_HOME%" set "CATALINA_HOME=C:\Users\Lenovo\Downloads\apache-tomcat-10.1.59"

set "PATH=%JAVA_HOME%\bin;%PATH%"

set "POM_PATH=BaiHocDauTien\pom.xml"
if not exist "%POM_PATH%" set "POM_PATH=LTW_Danh_BTs2-main\BaiHocDauTien\pom.xml"
if not exist "%POM_PATH%" set "POM_PATH=24110010-VoCongDanh-Btltw\BaiHocDauTien\pom.xml"

set "WAR_PATH=BaiHocDauTien\target\BaiHocDauTien-1.0.war"
if not exist "%WAR_PATH%" set "WAR_PATH=LTW_Danh_BTs2-main\BaiHocDauTien\target\BaiHocDauTien-1.0.war"

echo [1/3] Build tren STS / Eclipse hoac dung lenh Maven...
echo [2/3] Neu co file WAR: Copy vao Tomcat...
if exist "%WAR_PATH%" copy /Y "%WAR_PATH%" "%CATALINA_HOME%\webapps\BaiHocDauTien.war"

echo [3/3] Khoi dong Tomcat...
start "" "%CATALINA_HOME%\bin\startup.bat"

echo.
echo ==========================================================
echo >>> KHOI DONG TOMCAT SERVER THANH CONG! <<<
echo Mo trinh duyet truy cap:
echo -> Dang nhap:     http://localhost:8080/BaiHocDauTien/login
echo -> Dang ky (OTP): http://localhost:8080/BaiHocDauTien/register
echo -> Quen mat khau: http://localhost:8080/BaiHocDauTien/forgot-password
echo -> Categories:    http://localhost:8080/BaiHocDauTien/admin/categories
echo ==========================================================
