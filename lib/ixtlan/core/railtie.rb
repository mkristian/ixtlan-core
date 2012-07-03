require 'ixtlan/core/extra_headers'
require 'ixtlan/core/cache_headers'
require 'ixtlan/core/x_frame_headers'
require 'ixtlan/core/x_content_type_headers'
require 'ixtlan/core/x_xss_protection_headers'
require 'ixtlan/core/active_record'
require 'ixtlan/core/data_mapper'
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
                %w(edit show _form)
              else
                available_views_old
              end
            end
            
          end
        end
      end
    end

    class Railtie < Rails::Railtie

      gmethod = config.respond_to?(:generators)? :generators : :app_generators
      config.send(gmethod) do |config|
        
        config.templates << File.expand_path('../../../generators/rails', __FILE__)

      end

      config.before_configuration do |app|
        app.config.class.class_eval do
          attr_accessor :x_frame_headers, :x_content_type_headers, :x_xss_protection_headers
        end
      end

      config.before_initialize do |app|
        app.config.configuration_manager = Configuration::Manager.new

        ::ActionController::Base.send(:include, Ixtlan::Core::ExtraHeaders)
        ::ActionController::Base.send(:include, Ixtlan::Core::XFrameHeaders)
        ::ActionController::Base.send(:include, Ixtlan::Core::XContentTypeHeaders)
        ::ActionController::Base.send(:include, Ixtlan::Core::XXssProtectionHeaders)
        ::ActionController::Base.send(:include, Ixtlan::Core::CacheHeaders)

        app.config.middleware.use(Ixtlan::Core::ConfigurationRack, app.config.configuration_manager)
      end

      config.after_initialize do |app|
        app.config.configuration_manager.setup(app.config.configuration_model) if app.config.respond_to? :configuration_model
        
        if defined? ::DataMapper

          ::DataMapper::Model.append_inclusions(Ixtlan::Core::DataMapper)

        elsif defined? ::ActiveRecord

          ::ActiveRecord::Base.send(:include, 
                                    Ixtlan::Core::ActiveRecord)

        end
      end
    end
  end
end
