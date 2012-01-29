module Ixtlan
  module Core
    module Configuration
      module Module
        def self.included(model)
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
          end
        end
      end
      
      class Manager
	
	begin
          require 'slf4r'
          include Slf4r::Logger
	rescue LoadError
          require 'logger'
          def logger
            @logger ||= Logger.new(STDERR)
          end
        end            

        private

        def self.registry
          @registry ||= {}
        end
        
        def registry
          self.class.registry
        end

        def model
          unless @model
            if @model_name
              @model = @model_name.constantize
            else
              @model = (::Configuration rescue nil)
            end
            @model.send :include, Module unless @model.respond_to? :clear_instance if @model
          end
          @model
        end

        public

        def setup(model_name)
          if model_name
            @model_name = model_name.to_s.classify
          end
        end

        def register(name, &block)
          raise "need block" unless block
          logger.info{"register config for: #{name}"}
          registry[name.to_sym] = block
        end
        
        def cleanup
          model.clear_instance if @model
        end

        def configure
          registry.each do |name, callback|
            logger.debug{ "configure #{name}" }
            callback.call(model.instance)
          end
        end
      end
    end
  end
end
