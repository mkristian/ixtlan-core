module Ixtlan
  module Core
    module ConfigurationManager
      
      def self.included(model)
        model.send :include, Slf4r::Logger
        model.after_save :fire_on_change
        raise "configuration class must have instance method" unless model.respond_to? :instance
        model.class_eval do
          class << self
            alias :instance_old :instance
            def instance
              Thread.current[:ixtlan_configuration] ||= instance_old
            end
            def clear_instance
              Thread.current[:ixtlan_configuration] = nil
            end
          end

          private
          def self.registry
            @registry ||= {}
          end
        end
      end
      
      def register(name, &block)
        raise "need block" unless block
        logger.info{"register config for: #{name}"}
        registry[name.to_sym] = block
      end
      
      def fire_on_change
        registry.each do |name, callback|
          logger.debug{ "configure #{name}" }
          callback.call(self)
        end
      end              
      
      private
      
      def registry
        self.class.registry
      end
    end
  end
end
