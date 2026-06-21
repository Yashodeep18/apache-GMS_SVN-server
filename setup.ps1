# SVN Server Setup Script for Windows

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Apache SVN Server - Local Setup Script  " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Check if Docker is running
docker info > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker is not running. Please start Docker Desktop and run this script again."
    exit 1
}

Write-Host "Step 1: Building and starting the SVN server container..." -ForegroundColor Green
docker-compose up --build -d

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build or start the Docker container."
    exit 1
}

Write-Host "`nStep 2: Checking server status..." -ForegroundColor Green
Start-Sleep -Seconds 3
docker ps --filter name=svn-server

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "  SVN Server is now Running!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Access URLs:"
Write-Host "  * Web Access:        https://localhost:8443/svn/" -ForegroundColor Yellow
Write-Host "  * SVN Checkout URL:  https://localhost:8443/svn/myproject" -ForegroundColor Yellow
Write-Host "`nCredentials:"
Write-Host "  * Username: demo" -ForegroundColor Yellow
Write-Host "  * Password: demo" -ForegroundColor Yellow
Write-Host "`nQuick Management Commands:"
Write-Host "  * Create a new repository:" -ForegroundColor White
Write-Host "    docker exec -it svn-server svnadmin create /var/svn/repos/NEW_REPO" -ForegroundColor DarkGray
Write-Host "    docker exec -it svn-server chown -R www-data:www-data /var/svn/repos/NEW_REPO" -ForegroundColor DarkGray
Write-Host "  * Add a new user:" -ForegroundColor White
Write-Host "    docker exec -it svn-server htpasswd -m /var/svn/dav_svn.htpasswd NEW_USER" -ForegroundColor DarkGray
Write-Host "  * Stop the server:" -ForegroundColor White
Write-Host "    docker-compose down" -ForegroundColor DarkGray
Write-Host "==========================================" -ForegroundColor Cyan
