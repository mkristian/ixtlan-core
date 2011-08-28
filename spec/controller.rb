require 'ixtlan/core/extra_headers'
require 'ixtlan/core/cache_headers'
require 'ixtlan/core/x_frame_headers'
require 'ixtlan/core/x_content_type_headers'
require 'ixtlan/core/x_xss_protection_headers'

class Controller
  
  def render(*args, &block)
    @render = args if args.size > 0
    @render
  end
  def send_file(*args, &block)
    @send_file = args if args.size > 0
    @send_file
  end
  def send_data(*args, &block)
    @send_data = args if args.size > 0
    @send_data
  end

  include Ixtlan::Core::ExtraHeaders
  include Ixtlan::Core::XFrameHeaders
  include Ixtlan::Core::XContentTypeHeaders
  include Ixtlan::Core::XXssProtectionHeaders
  include Ixtlan::Core::CacheHeaders

  def response
    unless @response
      @response = Object.new

      def @response.headers
        @headers ||= {}
      end
      def @response.status(st = nil)
        @status = st if st
        @status
      end
    end
    @response
  end

  def request
    unless @request
      @request = Object.new
      def @request.method(m = nil)
        @method = m if m
        @method
      end
    end
    @request
  end

end

class ControllerWithUser < Controller

  def initialize(user = nil, status = 200, method = :get)
    @user = user
    request.method method
    response.status status
  end
  def current_user
    @user
  end

end

class Rails

  class Config
    attr_accessor :x_content_type_headers, :x_frame_headers , :x_xss_protection_headers, :cache_headers
  end

  def self.configuration
    @config ||= Config.new
  end
end
