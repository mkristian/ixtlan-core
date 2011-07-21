require 'rails/generators/named_base'
module Ixtlan
  module Generators
    class Base < Rails::Generators::Base

      argument :name, :type => :string, :required => false

      protected
      def generator_name
        raise "please overwrite generator_name"
      end

      public
      def create
        args = []
        if name
          args << ARGV.shift
        else
          args << "configuration"
        end

        if defined? ::Ixtlan::Errors
          args << "errors_keep_dump:integer"
          args << "errors_dir:string"
          args << "errors_from:string"
          args << "errors_to:string"
        end

        if defined? ::Ixtlan::Sessions
          args << "idle_session_timeout:integer"
        end

        if defined? ::Ixtlan::Audit
          args << "audit_keep_log:integer"
        end
        
        args += ARGV[0, 10000] || []
        
        args << "--singleton"

        generate generator_name, *args
      end
    end
  end
end
