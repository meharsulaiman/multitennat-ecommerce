# ==========================================
# Docker Health Check Script
# ==========================================
# Check health of all services
# ==========================================

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Docker Services Health Check" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
try {
    docker ps > $null 2>&1
} catch {
    Write-Host "[ERROR] Docker is not running!" -ForegroundColor Red
    exit 1
}

# Check container status
Write-Host "Container Status:" -ForegroundColor Yellow
docker-compose ps

Write-Host ""

# Check MongoDB health
Write-Host "MongoDB Health:" -ForegroundColor Yellow
$mongoHealth = docker-compose exec -T mongodb mongosh --eval "db.adminCommand('ping')" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "[OK] MongoDB is healthy" -ForegroundColor Green
} else {
    Write-Host "[ERROR] MongoDB is not responding" -ForegroundColor Red
}

Write-Host ""

# Check App health
Write-Host "Application Health:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/health" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Application is healthy" -ForegroundColor Green
        $health = $response.Content | ConvertFrom-Json
        Write-Host "  Status: $($health.status)" -ForegroundColor Gray
        Write-Host "  Environment: $($health.environment)" -ForegroundColor Gray
        Write-Host "  Uptime: $([math]::Round($health.uptime, 2)) seconds" -ForegroundColor Gray
    } else {
        Write-Host "[WARNING] Application returned status: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[ERROR] Application is not responding" -ForegroundColor Red
}

Write-Host ""

# Check Mongo Express
Write-Host "Mongo Express Health:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Mongo Express is healthy" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Mongo Express returned status: $($response.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[WARNING] Mongo Express is not responding" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Health Check Complete" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
