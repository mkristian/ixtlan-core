require 'rails/generators/resource_helpers'
require 'rails/generators/named_base'

module ScaffoldController
  module Generators
    class ScaffoldControllerGenerator < ::Rails::Generators::NamedBase
      include ::Rails::Generators::ResourceHelpers

      check_class_collision :suffix => "Controller"

      class_option :orm, :banner => "NAME", :type => :string, :required => true,
                         :desc => "ORM to generate the controller for"

      class_option :singleton, :type => :boolean, :default => false
      class_option :optimistic, :type => :boolean, :default => false
      class_option :timestamps, :type => :boolean, :default => true

      def create_controller_files
        if options[:singleton]
          template 'singleton_controller.rb', File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
        else
          template 'controller.rb', File.join('app/controllers', class_path, "#{controller_file_name}_controller.rb")
        end
      end
      
      hook_for :template_engine, :test_framework, :as => :scaffold, :in => :rails

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, :as => :scaffold, :in => :rails do |invoked|
        invoke invoked, [ controller_name ]
      end
    end
  end
end
