module Ixtlan
  module Core
    class ConfigurationRack
      def initialize(app)
        @app = app
      end
      
      def call(env)
        manager = Rails.application.config.configuration_manager
        # configure all registered components with current config
        manager.configure if manager
        result = @app.call(env)
        manager.cleanup if manager
        result
      end
      
    end
  end
end
