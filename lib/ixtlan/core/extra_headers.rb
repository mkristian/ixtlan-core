module Ixtlan
  module Core
    module ExtraHeaders

      def self.included(base)
        base.class_eval do
          alias :render_old :render
          def render(*args, &block)
            cache_headers
            x_frame_headers
            render_old(*args, &block)
          end
          alias :send_file_old :send_file
          def send_file(*args)
            cache_headers
            x_frame_headers
            send_file_old(*args)
          end
          alias :send_data_old :send_data
          def send_data(*args)
            cache_headers
            x_frame_headers
            send_file_old(*args)
          end
        end
      end
    end
  end
end
