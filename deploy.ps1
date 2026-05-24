#!/bin/bash

Write-Host "=== DocTrack Deploy to Fly.io ===" -ForegroundColor Cyan
Write-Host ""

# Check if flyctl is installed
try {
    $flyctl = Get-Command flyctl -ErrorAction Stop
    Write-Host "✓ flyctl is installed:" -ForegroundColor Green
    flyctl version
} catch {
    Write-Host "✗ flyctl not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install flyctl by running:" -ForegroundColor Yellow
    Write-Host "  iwr https://fly.io/install.ps1 -useb | iex"
    Write-Host ""
    Write-Host "Or download from: https://fly.io/docs/getting-started/installing-flyctl/" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After installing, run this script again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "=== Deploying DocTrack ===" -ForegroundColor Cyan
Write-Host ""

# Login if not already authenticated
if ([string]::IsNullOrEmpty($env:FLY_API_TOKEN)) {
    Write-Host "Logging in to Fly.io..." -ForegroundColor Yellow
    flyctl auth login
}

# Launch new app
Write-Host "Creating Fly.io app..." -ForegroundColor Yellow
flyctl launch --name docktrack --region iad --no-deploy

# Add PostgreSQL database
Write-Host "Setting up PostgreSQL database..." -ForegroundColor Yellow
flyctl services create postgres --version 15

# Deploy the application
Write-Host "Deploying application..." -ForegroundColor Yellow
flyctl deploy

Write-Host ""
Write-Host "=== Deploy Complete ===" -ForegroundColor Green
Write-Host "Your app is live at: https://docktrack.fly.dev" -ForegroundColor Cyan
Write-Host ""
