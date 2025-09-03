# Force Enterprise Edition
# This must run before other initializers

# Override the enterprise? method to always return true
module ChatwootApp
  def self.enterprise?
    true
  end
  
  def self.extensions
    %w[enterprise]
  end
end

# Override ChatwootHub to always return enterprise
module ChatwootHub
  def self.pricing_plan
    'enterprise'
  end
  
  def self.pricing_plan_quantity
    999999
  end
end

# Ensure enterprise folder exists
enterprise_path = Rails.root.join('enterprise')
unless File.exist?(enterprise_path)
  FileUtils.mkdir_p(enterprise_path)
  File.write(enterprise_path.join('.gitkeep'), 'Enterprise mode enabled')
end

Rails.logger.info "🚀 ENTERPRISE MODE FORCED: ChatwootApp.enterprise? = #{ChatwootApp.enterprise?}"
Rails.logger.info "🚀 PRICING PLAN FORCED: ChatwootHub.pricing_plan = #{ChatwootHub.pricing_plan}"