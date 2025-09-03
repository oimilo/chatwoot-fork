FROM chatwoot/chatwoot:latest

# Copy enterprise folder to enable enterprise mode
COPY enterprise /app/enterprise

# Set environment variables for the hack
ENV CW_EDITION=ee \
    DISABLE_TELEMETRY=true \
    CHATWOOT_HUB_URL=http://localhost:9999 \
    INSTALLATION_PRICING_PLAN=enterprise \
    DISABLE_ENTERPRISE=false \
    RAILS_ENV=production

# Ensure enterprise folder exists
RUN mkdir -p /app/enterprise && \
    echo "Enterprise mode enabled" > /app/enterprise/.gitkeep

WORKDIR /app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]