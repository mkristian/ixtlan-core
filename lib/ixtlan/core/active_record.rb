module Ixtlan
  module Core
    module ActiveRecord

      def self.included(base)
        warn 'deprecated: use ixtlan-optimistic instead'
        base.class_eval do

          def self.optimistic_find(updated_at, *args)
            if updated_at  
              dummy = self.new
              dummy.updated_at = updated_at
              updated_at_date = dummy.updated_at
              # try different ways to use the date
              # TODO maybe there is a nicer way ??
              first(:conditions => ["id = ? and updated_at <= ? and updated_at >= ?", args[0], updated_at_date + 0.0005, updated_at_date - 0.0005])
              # TODO make it work with different PKs
            end
          end

        end
      end
    end
  end
end
