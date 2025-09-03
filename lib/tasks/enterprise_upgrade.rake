namespace :enterprise do
  desc "Upgrade all accounts to enterprise"
  task upgrade: :environment do
    puts "🚀 Upgrading to Enterprise Edition..."
    
    # Set installation config
    InstallationConfig.find_or_create_by(name: 'INSTALLATION_PRICING_PLAN').update!(
      value: 'enterprise',
      locked: true
    )
    
    InstallationConfig.find_or_create_by(name: 'CW_EDITION').update!(
      value: 'ee', 
      locked: true
    )
    
    # Update all accounts
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
    
    # Update super admins
    SuperAdmin.find_each do |admin|
      puts "✅ SuperAdmin #{admin.email} configured"
    end
    
    puts "✅ Enterprise Edition activated!"
    puts "✅ ChatwootApp.enterprise? = #{ChatwootApp.enterprise?}"
    puts "✅ Pricing plan: #{ChatwootHub.pricing_plan}"
  end
end