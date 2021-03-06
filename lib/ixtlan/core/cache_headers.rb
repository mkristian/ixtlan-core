module Ixtlan
  module Core
    module CacheHeaders

      protected

      # Date: <ServercurrentDate>
      # Expires: Fri, 01 Jan 1990 00:00:00 GMT
      # Pragma: no-cache
      # Cache-control: no-cache, must-revalidate
      def no_caching(no_store = true)
        if cacheable_response?
          response.headers["Date"] = timestamp
          response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
          response.headers["Pragma"] = "no-cache"
          response.headers["Cache-Control"] = "no-cache, must-revalidate" + (", no-store" if no_store).to_s
        end
      end

      # Date: <ServercurrentDate>
      # Expires: Fri, 01 Jan 1990 00:00:00 GMT
      # Cache-control: private, max-age=<1dayInSeconds>
      def only_browser_can_cache(no_store = false, max_age_in_seconds = 0)
        if cacheable_response?
          response.headers["Date"] = timestamp
          response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 UTC"
          response.headers["Cache-Control"] = "private, max-age=#{max_age_in_seconds}" + (", no-store" if no_store).to_s
        end
      end

      # Date: <ServercurrentDate>
      # Expires: <ServerCurrentDate + 1month>
      # Cache-control: public, max-age=<1month>
      def allow_browser_and_proxy_to_cache(no_store = false, max_age_in_seconds = 0)
        if cacheable_response?
          now = Time.now
          response.headers["Date"] = timestamp(now)
          response.headers["Expires"] = timestamp(now + max_age_in_seconds)
          response.headers["Cache-Control"] = "public, max-age=#{max_age_in_seconds}" + (", no-store" if no_store).to_s
        end
      end

      def cache_headers(mode = nil)
        if respond_to?(:current_user) && send(:current_user)
          mode ||= self.class.instance_variable_get(:@_cache_headers)
          case mode
          when :private
            no_caching(self.class.instance_variable_get(:@no_store))
          when :protected
            only_browser_can_cache(self.class.instance_variable_get(:@no_store))
          when :public
            allow_browser_and_proxy_to_cache(self.class.instance_variable_get(:@no_store))
          when :off
          else
            send mode if mode
          end
        end
      end

      def self.included(base)
        base.class_eval do
          def self.cache_headers(mode = nil, no_store = true)
            if(mode)
              @_cache_headers = mode.to_sym
            end
            @no_store = no_store
          end
        end
      end

      private
      def cacheable_response?
        request.method.to_s.downcase == "get" &&
          [200, 203, 206, 300, 301].member?(response.status)
      end

      def timestamp(now = Time.now)
        now.utc.strftime "%a, %d %b %Y %H:%M:%S %Z"
      end
    end
  end
end
