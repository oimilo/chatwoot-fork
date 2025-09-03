# Set enterprise configuration
puts "🚀 Setting Enterprise Configuration..."

# Set installation config
InstallationConfig.find_or_create_by(name: 'INSTALLATION_PRICING_PLAN').update!(
  value: 'enterprise',
  locked: true
)

InstallationConfig.find_or_create_by(name: 'INSTALLATION_PRICING_PLAN_QUANTITY').update!(
  value: '999999',
  locked: true
)

InstallationConfig.find_or_create_by(name: 'CW_EDITION').update!(
  value: 'ee',
  locked: true
)

puts "✅ Enterprise configuration set!"
puts "   - INSTALLATION_PRICING_PLAN: enterprise"
puts "   - INSTALLATION_PRICING_PLAN_QUANTITY: 999999"
puts "   - CW_EDITION: ee"

# Update all existing accounts to enterprise
Account.find_each do |account|
  account.update!(
    custom_attributes: (account.custom_attributes || {}).merge(
      'pricing_plan' => 'enterprise',
      'plan_name' => 'Enterprise',
      'subscribed_quantity' => 999999
    )
  )
  puts "✅ Account ##{account.id} (#{account.name}) upgraded to Enterprise"
end

puts "✅ All accounts upgraded to Enterprise Edition!"