module Ixtlan
  module Core
    module ExtraHeaders

      def self.included(base)
        base.class_eval do
          alias :render_old :render
          def render(*args, &block)
            _extra_header(*args)
            render_old(*args, &block)
          end
          alias :send_file_old :send_file
          def send_file(*args)
            _extra_header(*args)
            send_file_old(*args)
          end
          alias :send_data_old :send_data
          def send_data(*args)
            _extra_header(*args)
            send_file_old(*args)
          end
          private
          def _extra_header(*args)
            opt = (args[0].is_a?(Hash) ? args[0] : args[1]) || {}
p opt
            cache_headers(opt[:cache_headers])
            x_frame_headers(opt[:x_frame_headers])
            x_content_type_headers(opt[:x_content_type_headers])
            x_xss_protection_headers(opt[:x_xss_protection_headers])
          end
        end
      end
    end
  end
end
