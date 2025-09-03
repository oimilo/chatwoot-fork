# Force Enterprise Edition - More aggressive approach
Rails.application.config.after_initialize do
  # Force ChatwootApp to always return enterprise
  ChatwootApp.singleton_class.send(:define_method, :enterprise?) { true }
  
  # Force ChatwootHub pricing_plan
  ChatwootHub.singleton_class.send(:define_method, :pricing_plan) { 'enterprise' }
  ChatwootHub.singleton_class.send(:define_method, :pricing_plan_quantity) { 999999 }
  
  # Log to confirm
  Rails.logger.info "🚀 ENTERPRISE FORCED: ChatwootApp.enterprise? = true"
  Rails.logger.info "🚀 PRICING PLAN FORCED: ChatwootHub.pricing_plan = enterprise"
end