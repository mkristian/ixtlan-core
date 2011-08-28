module Ixtlan
  module Core
    module XContentTypeHeaders

      protected

      def x_content_type_headers(mode = nil)
        case mode || self.class.instance_variable_get(:@_x_content_type_headers) || Rails.configuration.x_content_type_headers || :nosniff
        when :nosniff
          response.headers["X-Content-Type-Options"] = "nosniff"
        when :off
        else
          warn "allowed values for x_content_type_headers are :nosniff, :off"
        end
      end
    
      def self.included(base)
        base.class_eval do
          def self.x_content_type_headers(mode)
            if(mode)
              @_x_content_type_headers = mode.to_sym
            else
              @_x_content_type_headers = nil
            end
          end
        end
      end
    end
  end
end
