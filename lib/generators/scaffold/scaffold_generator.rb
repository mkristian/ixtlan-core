require 'rails/generators/rails/resource/resource_generator'

module Rails
  module Generators
    class ScaffoldGenerator < ResourceGenerator #metagenerator
      remove_hook_for :resource_controller
      remove_class_option :actions

      class_option :singleton, :type => :boolean, :default => false

      hook_for :scaffold_controller, :required => true, :in => :scaffold_controller
      hook_for :stylesheets 

      if defined? Resty
        hook_for :resty, :type => :boolean, :default => true
      end

      if defined? ::Ixtlan::Guard
        hook_for :guard, :type => :boolean, :default => true
      end

      def add_resource_route
        return if options[:actions].present?
        route_config =  class_path.collect{|namespace| "namespace :#{namespace} do " }.join(" ")
        if options[:singleton]
          route_config << "resource :#{file_name}"
        else
          route_config << "resources :#{file_name.pluralize}"
        end
        route_config << " end" * class_path.size
        route route_config
      end
    end
  end
end
