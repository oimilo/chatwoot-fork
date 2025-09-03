#!/bin/sh

set -e

echo "🚀 Starting Chatwoot Enterprise Edition..."

echo "Waiting for database..."
while ! pg_isready -h ${POSTGRES_HOST:-postgres} -p ${POSTGRES_PORT:-5432}; do sleep 0.25; done; 
echo "Database is now available"

echo "Setting up database..."
bundle exec rails db:chatwoot_prepare
bundle exec rails db:migrate

echo "Forcing Enterprise configuration..."
bundle exec rails runner "
  # Force Enterprise in InstallationConfig
  ['INSTALLATION_PRICING_PLAN', 'CW_EDITION', 'INSTALLATION_PRICING_PLAN_QUANTITY'].each do |key|
    config = InstallationConfig.find_or_initialize_by(name: key)
    config.value = case key
      when 'INSTALLATION_PRICING_PLAN' then 'enterprise'
      when 'CW_EDITION' then 'ee'
      when 'INSTALLATION_PRICING_PLAN_QUANTITY' then 999999
    end
    config.locked = true
    config.save!
    puts \"✅ #{key} = #{config.value}\"
  end
  
  # Update account to Enterprise
  account = Account.first
  if account
    attrs = account.custom_attributes || {}
    attrs['pricing_plan'] = 'enterprise'
    attrs['plan_name'] = 'Enterprise'
    attrs['subscribed_quantity'] = 999999
    account.custom_attributes = attrs
    account.save!
    puts \"✅ Account #{account.name} set to Enterprise\"
  end
"

echo "🎯 Enterprise Edition configured!"

# Start both sidekiq and rails server
multirun \
    "bundle exec sidekiq -C config/sidekiq.yml" \
    "bundle exec rails s -b 0.0.0.0 -p ${PORT:-3000}"

false