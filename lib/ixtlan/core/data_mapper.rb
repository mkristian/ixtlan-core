module Ixtlan
  module Core
    module DataMapper

      def self.included(base)        
        warn 'deprecated: use ixtlan-optimistic instead'
        base.class_eval do
          
          def self.optimistic_get(updated_at, *args)
            if updated_at
              updated_at_date = new(:updated_at => updated_at).updated_at
              # TODO make it work with different PKs
              first(:id => args[0], :updated_at.gte => updated_at_date - 0.0005, :updated_at.lte => updated_at_date + 0.0005)
            end
          end
        end

      end

    end
  end
end
