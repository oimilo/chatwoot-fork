FROM chatwoot/chatwoot:latest

# Copy enterprise folder to enable enterprise mode
COPY enterprise /app/enterprise

# No start script for now

# Set environment variables for enterprise mode
ENV CW_EDITION=ee \
    DISABLE_TELEMETRY=true \
    CHATWOOT_HUB_URL=http://localhost:9999 \
    INSTALLATION_PRICING_PLAN=enterprise \
    RAILS_ENV=production \
    NODE_ENV=production

# Ensure enterprise folder exists
RUN mkdir -p /app/enterprise && \
    echo "Enterprise mode enabled" > /app/enterprise/.gitkeep

WORKDIR /app

# Railway uses the PORT environment variable
EXPOSE 3000

# Use direct command without external script
CMD sh -c "echo 'Waiting for database...' && \
    while ! pg_isready -h \${PGHOST} -p \${PGPORT}; do sleep 1; done && \
    echo 'Database ready' && \
    bundle exec rails db:chatwoot_prepare || bundle exec rails db:prepare && \
    bundle exec rails db:migrate && \
    echo 'Setting Enterprise Configuration...' && \
    bundle exec rails runner 'load Rails.root.join(\"db/seeds/enterprise_config.rb\")' || true && \
    echo 'Upgrading to Enterprise...' && \
    bundle exec rails enterprise:upgrade || true && \
    echo 'Starting Rails...' && \
    bundle exec rails s -b 0.0.0.0 -p \${PORT:-3000}"