FROM chatwoot/chatwoot:latest

# Copy enterprise folder to enable enterprise mode
COPY enterprise /app/enterprise

# Set environment variables for the hack
ENV CW_EDITION=ee \
    DISABLE_TELEMETRY=true \
    CHATWOOT_HUB_URL=http://localhost:9999 \
    INSTALLATION_PRICING_PLAN=enterprise \
    DISABLE_ENTERPRISE=false \
    RAILS_ENV=production \
    NODE_ENV=production

# Ensure enterprise folder exists
RUN mkdir -p /app/enterprise && \
    echo "Enterprise mode enabled" > /app/enterprise/.gitkeep

WORKDIR /app

# Railway uses the PORT environment variable
EXPOSE 3000

# Use the official Chatwoot entrypoint
ENTRYPOINT ["docker/entrypoints/rails.sh"]
CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]