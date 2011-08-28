module Ixtlan
  module Core
    module XFrameHeaders

      protected

      def x_frame_headers(mode = nil)
        case mode || self.class.instance_variable_get(:@_x_frame_headers) || Rails.configuration.x_frame_headers || :deny
        when :deny
          response.headers["X-Frame-Options"] = "DENY"
        when :sameorigin
          response.headers["X-Frame-Options"] = "SAMEORIGIN"
        when :off
        else
          warn "allowed values for x_frame_headers are :deny, :sameorigin, :off"
        end
      end
    
      def self.included(base)
        base.class_eval do
          def self.x_frame_headers(mode)
            if(mode)
              @_x_frame_headers = mode.to_sym
            else
              @_x_frame_headers = nil
            end
          end
        end
      end
    end
  end
end
