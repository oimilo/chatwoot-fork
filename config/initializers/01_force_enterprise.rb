# Force Enterprise Edition - Override methods directly
Rails.application.config.after_initialize do
  # Override ChatwootApp
  module ChatwootApp
    class << self
      def enterprise?
        true
      end
    end
  end

  # Override ChatwootHub
  module ChatwootHub  
    class << self
      def pricing_plan
        'enterprise'
      end
      
      def pricing_plan_quantity
        999999
      end
    end
  end

  Rails.logger.info "🚀 ENTERPRISE FORCED AT BOOT"
  Rails.logger.info "🚀 ChatwootApp.enterprise? = #{ChatwootApp.enterprise?}"
  Rails.logger.info "🚀 ChatwootHub.pricing_plan = #{ChatwootHub.pricing_plan}"
end