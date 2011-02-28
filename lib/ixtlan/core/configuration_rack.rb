module Ixtlan
  module Core
    class ConfigurationRack
      def initialize(app)
        @app = app
      end
      
      def call(env)
        model = Rails.application.config.configuration_model
        # configure all registered components with current config
        model.instance.fire_on_change if model
        result = @app.call(env)
        model.clear_instance if model
        result
      end
      
    end
  end
end
