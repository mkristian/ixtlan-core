require 'ixtlan/core/extra_headers'
require 'ixtlan/core/cache_headers'
require 'ixtlan/core/x_frame_headers'
require 'ixtlan/core/x_content_type_headers'
require 'ixtlan/core/x_xss_protection_headers'
require 'ixtlan/core/optimistic_active_record'
require 'ixtlan/core/optimistic_data_mapper'
require 'ixtlan/core/configuration_rack'
require 'ixtlan/core/configuration_manager'
module Ixtlan
  module Core

    module Singleton
      
      def self.included(base)
        base.class_eval do
          class_option :singleton, :type => :boolean, :default => false

          if self.class.to_s =~  /ScaffoldGenerator$/
          
            protected
            alias :available_views_old :available_views
            def available_views
              if options[:singleton]
                %w(new create edit show destroy _form)
              else
                available_views_old
              end
            end
            
          end
        end
      end
    end

    class Railtie < Rails::Railtie
      config.generators do |config|
        
        config.templates << File.expand_path('../../../generators/rails', __FILE__)

      end

      config.before_configuration do |app|
        app.config.class.class_eval do
          attr_accessor :x_frame_headers, :x_content_type_headers, :x_xss_protection_headers
        end
      end

      config.before_initialize do |app|
        app.config.class.class_eval do
          attr_accessor :configuration_model
          def configuration_model=(clazz)
            clazz.send(:include, Ixtlan::Core::ConfigurationManager) #unless clazz.kind_of?(Ixtlan::Core::ConfigurationManager)
            @configuration_model = clazz
          end
        end
        ::ActionController::Base.send(:include, Ixtlan::Core::ExtraHeaders)
        ::ActionController::Base.send(:include, Ixtlan::Core::XFrameHeaders)
        ::ActionController::Base.send(:include, Ixtlan::Core::XContentTypeHeaders)
        ::ActionController::Base.send(:include, Ixtlan::Core::XXssProtectionHeaders)
        ::ActionController::Base.send(:include, Ixtlan::Core::CacheHeaders)

        app.config.middleware.use Ixtlan::Core::ConfigurationRack
      end
      config.after_initialize do |app|
        if defined? DataMapper

          ::DataMapper::Resource.send(:include, 
                                      Ixtlan::Core::OptimisticDataMapper)

        elsif defined? ActiveRecord

          ::ActiveRecord::Base.send(:include, 
                                    Ixtlan::Core::OptimisticActiveRecord)

        end
      end
    end
  end
end
