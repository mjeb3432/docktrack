#!/bin/bash

echo "=== DocTrack Deploy Script ==="
echo ""

# Check if flyctl is installed
if command -v flyctl &> /dev/null; then
    echo "✓ flyctl is installed"
    flyctl version
else
    echo "✗ flyctl not found"
    echo ""
    echo "Please install flyctl:"
    echo "  macOS: brew install flyctl"
    echo "  Linux: curl -L https://fly.io/install.sh | sh"
    echo "  Windows (PowerShell): iwr https://fly.io/install.ps1 -useb | iex"
    echo ""
    echo "Or download from: https://fly.io/docs/getting-started/installing-flyctl/"
    exit 1
fi

echo ""
echo "=== Deploying DocTrack ==="
echo ""

# Login if not already
if [ -z "$FLY_API_TOKEN" ]; then
    echo " Logging in to Fly.io..."
    flyctl auth login
fi

# Create app
echo " Creating Fly.io app..."
flyctl launch --name docktrack --region iad --no-deploy

# Add PostgreSQL
echo " Setting up PostgreSQL database..."
flyctl services create postgres --version 15

# Deploy
echo " Deploying application..."
flyctl deploy

echo ""
echo "=== Deploy Complete ==="
echo "Your app is live at: https://docktrack.fly.dev"
