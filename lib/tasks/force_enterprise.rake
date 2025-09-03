namespace :enterprise do
  desc "Force enterprise mode in database"
  task force: :environment do
    puts "🚀 Forcing Enterprise Mode..."
    
    # Force installation config
    begin
      config = InstallationConfig.find_or_initialize_by(name: 'INSTALLATION_PRICING_PLAN')
      config.value = 'enterprise'
      config.locked = true
      config.save!
      puts "✅ INSTALLATION_PRICING_PLAN = enterprise"
    rescue => e
      puts "⚠️ Error setting INSTALLATION_PRICING_PLAN: #{e.message}"
    end
    
    begin
      config = InstallationConfig.find_or_initialize_by(name: 'CW_EDITION')
      config.value = 'ee'
      config.locked = true
      config.save!
      puts "✅ CW_EDITION = ee"
    rescue => e
      puts "⚠️ Error setting CW_EDITION: #{e.message}"
    end
    
    # Force all accounts to enterprise
    Account.find_each do |account|
      attrs = account.custom_attributes || {}
      attrs['pricing_plan'] = 'enterprise'
      attrs['plan_name'] = 'Enterprise'
      attrs['subscribed_quantity'] = 999999
      account.custom_attributes = attrs
      account.save!
      puts "✅ Account ##{account.id} (#{account.name}) set to Enterprise"
    end
    
    # Force super admin user
    user = User.find_by(email: 'bonitoemail@gmail.com')
    if user
      user.update!(super_admin: true) if !user.super_admin?
      puts "✅ User #{user.email} is super admin"
    end
    
    puts "✅ Enterprise Edition FORCED!"
    puts "   ChatwootApp.enterprise? = #{ChatwootApp.enterprise?}"
    puts "   ChatwootHub.pricing_plan = #{ChatwootHub.pricing_plan}"
  end
end