#!/usr/bin/env ruby
# Script para configurar Chatwoot como Enterprise

# Configurar INSTALLATION_PRICING_PLAN
config = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN')
config.value = 'enterprise'
config.locked = true
config.save!
puts "✅ INSTALLATION_PRICING_PLAN = enterprise"

# Configurar CW_EDITION
config = InstallationConfig.find_or_initialize_by(name: 'CW_EDITION')
config.value = 'ee'
config.locked = true
config.save!
puts "✅ CW_EDITION = ee"

# Configurar INSTALLATION_PRICING_PLAN_QUANTITY
config = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN_QUANTITY')
config.value = 999999
config.locked = true
config.save!
puts "✅ INSTALLATION_PRICING_PLAN_QUANTITY = 999999"

# Atualizar todas as contas
Account.find_each do |account|
  attrs = account.custom_attributes || {}
  attrs['pricing_plan'] = 'enterprise'
  attrs['plan_name'] = 'Enterprise'
  attrs['subscribed_quantity'] = 999999
  account.custom_attributes = attrs
  account.save!
  puts "✅ Account ##{account.id} (#{account.name}) set to Enterprise"
end

# Marcar usuário como admin
user = User.find_by(email: 'bonitoemail@gmail.com')
if user
  attrs = user.custom_attributes || {}
  attrs['is_admin'] = true
  user.custom_attributes = attrs
  user.save!
  puts "✅ User #{user.email} marked as admin"
end

puts "🚀 Enterprise Edition configuration complete!"