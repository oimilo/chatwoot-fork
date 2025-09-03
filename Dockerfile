FROM chatwoot/chatwoot:latest

# Install dependencies for Railway
RUN apk add --no-cache multirun postgresql-client

# Copy enterprise folder and configurations
COPY enterprise /app/enterprise
COPY config/initializers/01_force_enterprise.rb /app/config/initializers/01_force_enterprise.rb

# Set Enterprise environment variables
ENV CW_EDITION=ee \
    INSTALLATION_PRICING_PLAN=enterprise \
    INSTALLATION_PRICING_PLAN_QUANTITY=999999 \
    DISABLE_TELEMETRY=true \
    CHATWOOT_HUB_URL=http://localhost:9999 \
    RAILS_ENV=production \
    NODE_ENV=production \
    INSTALLATION_ENV=docker

# Copy startup script
COPY --chmod=755 start.sh ./

WORKDIR /app

ENTRYPOINT ["/bin/sh"]
CMD ["start.sh"]