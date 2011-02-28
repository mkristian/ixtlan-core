require 'ixtlan/core/cache_headers'
require 'ixtlan/core/configuration_rack'
require 'ixtlan/core/configuration_manager'

module Ixtlan
  module Core
    class Railtie < Rails::Railtie
      config.generators do
        require 'rails/generators'
        
        templates = File.expand_path('../../../generators/rails/templates', __FILE__)
        
        require 'rails/generators/erb/scaffold/scaffold_generator'
        Erb::Generators::ScaffoldGenerator.source_paths.insert(0, templates)
        Erb::Generators::ScaffoldGenerator.class_option :singleton, :type => :boolean, :default => false
        Erb::Generators::ScaffoldGenerator.class_eval do
          
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

        require 'rails/generators/active_record/model/model_generator'
        ActiveRecord::Generators::ModelGenerator.source_paths.insert(0, templates)
        ActiveRecord::Generators::ModelGenerator.class_option :singleton, :type => :boolean, :default => false
      end

      config.before_configuration do |app|
        app.config.class.class_eval do
          attr_accessor :configuration_model
          def configuration_model=(clazz)
            clazz.send(:include, Ixtlan::Core::ConfigurationManager) #unless clazz.kind_of?(Ixtlan::Core::ConfigurationManager)
            @configuration_model = clazz
          end
        end
        ::ActionController::Base.send(:include, Ixtlan::Core::CacheHeaders)
        app.config.middleware.use Ixtlan::Core::ConfigurationRack
      end
    end
  end
end
