require 'rails/generators/erb'
require 'rails/generators/resource_helpers'

module Erb
  module Generators
    class ScaffoldGenerator < Base
      include Rails::Generators::ResourceHelpers

      class_option :optimistic, :type => :boolean, :default => false
      class_option :singleton, :type => :boolean, :default => false
      class_option :timestamps, :type => :boolean, :default => true

      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_root_folder
        empty_directory File.join("app/views", controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          template filename, File.join("app/views", controller_file_path, filename)
        end
      end

    protected

      def available_views
        if options[:singleton]
          %w(edit show _form)
        else
          %w(index edit show new _form)
        end
      end
    end
  end
end
