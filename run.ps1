$env:JAVA_HOME = "C:\Program Files\Java\jdk-27.0.1.0.3"
if (-not (Test-Path $env:JAVA_HOME)) { $env:JAVA_HOME = "C:\Program Files\Java\latest" }
$env:CATALINA_HOME = "C:\Tomcat11\apache-tomcat-11.0.27"
if (-not (Test-Path $env:CATALINA_HOME)) { $env:CATALINA_HOME = "C:\Users\Lenovo\Downloads\apache-tomcat-10.1.59" }
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

$pomPath = if (Test-Path "BaiHocDauTien\pom.xml") { "BaiHocDauTien\pom.xml" } else { "LTW_Danh_BTs2-main\BaiHocDauTien\pom.xml" }
$warPath = if (Test-Path "BaiHocDauTien\target\BaiHocDauTien-1.0.war") { "BaiHocDauTien\target\BaiHocDauTien-1.0.war" } else { "LTW_Danh_BTs2-main\BaiHocDauTien\target\BaiHocDauTien-1.0.war" }

if (Test-Path $warPath) {
    Write-Host "[1/2] Copy file WAR vao Tomcat..." -ForegroundColor Cyan
    Copy-Item $warPath "$env:CATALINA_HOME\webapps\BaiHocDauTien.war" -Force
}

Write-Host "[2/2] Khoi dong Tomcat Server..." -ForegroundColor Cyan
if (Test-Path "$env:CATALINA_HOME\bin\startup.bat") {
    Start-Process "$env:CATALINA_HOME\bin\startup.bat"
    Start-Sleep -Seconds 3
    Start-Process "http://localhost:8080/BaiHocDauTien/home"
}

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host ">>> KHOI DONG TOMCAT SERVER THANH CONG! <<<" -ForegroundColor Green
Write-Host "Mo trinh duyet truy cap cac link sau:" -ForegroundColor Yellow
Write-Host "👉 Trang chu (Top 10 Video):   http://localhost:8080/BaiHocDauTien/home" -ForegroundColor Yellow
Write-Host "👉 Danh sach Video (6sp/trang): http://localhost:8080/BaiHocDauTien/video" -ForegroundColor Yellow
Write-Host "👉 Quan ly CRUD Video (Admin):  http://localhost:8080/BaiHocDauTien/admin/videos" -ForegroundColor Yellow
Write-Host "👉 Categories (Admin):          http://localhost:8080/BaiHocDauTien/admin/categories" -ForegroundColor Yellow
Write-Host "👉 Dang nhap:                   http://localhost:8080/BaiHocDauTien/login" -ForegroundColor Yellow
Write-Host "👉 Dang ky (OTP):               http://localhost:8080/BaiHocDauTien/register" -ForegroundColor Yellow
Write-Host "👉 Quen mat khau:               http://localhost:8080/BaiHocDauTien/forgot-password" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Green
