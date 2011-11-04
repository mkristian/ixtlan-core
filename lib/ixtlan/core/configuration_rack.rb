module Ixtlan
  module Core
    class ConfigurationRack
      def initialize(app, config_manager)
        @app = app
        @manager = config_manager
      end
      
      def call(env)
        # configure all registered components with current config
        @manager.configure
        result = @app.call(env)
        @manager.cleanup
        result
      end
      
    end
  end
end
