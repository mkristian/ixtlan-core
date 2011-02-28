require 'rails/generators/base'
module Ixtlan
  module Generators
    class SetupGenerator < Rails::Generators::Base

      source_root File.expand_path('../templates', __FILE__)

      def create_preinitializer_files
        template 'preinitializer.rb', File.join('config', "preinitializer.rb")
        template 'gitignore', File.join('config', ".gitignore")
        template 'production.yml.example', File.join('config', "production.yml.example")
        template 'database.yml.example', File.join('config', "database.yml.example")
      end
      
      def create_initializer_file
        template 'initializer.rb', File.join('config', "initializers", "ixtlan.rb")
      end
    
      # TODO make only if template-engine is ERB
      def error_templates
        if defined? Ixtlan::Errors
          views_dir = File.join('app', 'views', 'errors')
          ['error', 'error_with_session', 'stale'].each do |f|
            file = "#{f}.html.erb"
            template file, File.join(views_dir, file)
          end
        end
      end

      def create_application_layout_file
        if defined? Ixtlan::Sessions
          layout = File.join('app', 'views', 'layouts', 'application.html.erb')
          template 'application_layout.html.erb', layout
        end
      end
    end
  end
end
