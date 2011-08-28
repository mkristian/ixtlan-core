module Ixtlan
  module Core
    module XXssProtectionHeaders

      protected

      def x_xss_protection_headers(mode = nil)
        case mode || self.class.instance_variable_get(:@_x_xss_protection_headers) || Rails.configuration.x_xss_protection_headers || :block
        when :disabled
          response.headers["X-XSS-Protection"] = "0"
        when :block
          response.headers["X-XSS-Protection"] = "1; mode=block"
        when :off
        else
          warn "allowed values for x_xss_protection_headers are :nocheck, :block, :off"
        end
      end
    
      def self.included(base)
        base.class_eval do
          def self.x_xss_protection_headers(mode)
            if(mode)
              @_x_xss_protection_headers = mode.to_sym
            else
              @_x_xss_protection_headers = nil
            end
          end
        end
      end
    end
  end
end
