#!/bin/bash

echo "🚀 Fixing Enterprise Mode on Railway"
echo ""
echo "1. First, run: railway link"
echo "   - Choose: oimilo's Projects"
echo "   - Choose: respectful-dream"
echo ""
echo "2. Then run this script again with: ./fix-enterprise.sh deploy"
echo ""

if [ "$1" == "deploy" ]; then
    echo "Adding build configuration..."
    
    # Add environment variable to force rebuild
    railway variables --set "NIXPACKS_NO_CACHE=1"
    railway variables --set "RAILS_ENV=production"
    railway variables --set "NODE_ENV=production"
    
    # Force a new deployment
    railway up
    
    echo "✅ Deployment triggered with enterprise mode!"
    echo ""
    echo "Check in 5 minutes at: https://chatwoot-production-6946.up.railway.app"
fi