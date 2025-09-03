FROM chatwoot/chatwoot:latest

# Copy enterprise folder structure to enable enterprise mode
COPY enterprise /app/enterprise

# Set environment variables for enterprise mode as per HACK_COMPLETO.md
ENV CW_EDITION=ee \
    DISABLE_TELEMETRY=true \
    CHATWOOT_HUB_URL=http://localhost:9999 \
    RAILS_ENV=production \
    NODE_ENV=production

WORKDIR /app

# Railway uses the PORT environment variable
EXPOSE 3000

# Startup command with enterprise setup
CMD bundle exec rails db:chatwoot_prepare && \
    bundle exec rails runner "InstallationConfig.find_or_create_by(name: 'INSTALLATION_PRICING_PLAN').update!(value: 'enterprise', locked: true)" && \
    bundle exec rails runner "InstallationConfig.find_or_create_by(name: 'CW_EDITION').update!(value: 'ee', locked: true)" && \
    bundle exec rails s -b 0.0.0.0 -p ${PORT:-3000}