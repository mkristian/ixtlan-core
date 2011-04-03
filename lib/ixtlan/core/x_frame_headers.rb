module Ixtlan
  module Core
    module XFrameHeaders

      protected

      def x_frame_headers
        case self.class.instance_variable_get(:@_x_frame_mode) || Rails.configuration.x_frame_headers
        when :deny
          response.headers["X-FRAME-OPTIONS"] = "DENY"
        when :sameorigin
          response.headers["X-FRAME-OPTIONS"] = "SAMEORIGIN"
        end
      end

      def self.included(base)
        base.class_eval do
          def self.x_frame_headers(mode)
            if(mode)
              @_x_frame_mode = mode.to_sym
            else
              @_x_frame_mode = nil
            end
          end
        end
      end
    end
  end
end
