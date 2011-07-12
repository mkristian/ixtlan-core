module Ixtlan
  module Core
    module OptimisticActiveRecord

      def self.included(base)
        base.class_eval do
          def self.optimistic_find(updated_at, *args)
            updated_at_date = new(:updated_at => updated_at).updated_at
            # try different ways to use the date
            first(:conditions => ["id = ? and updated_at = ?", args[0], updated_at_date]) || first(:conditions => ["id = ? and updated_at = ?", args[0], updated_at])
            # TODO make it work with different PKs
          end
        end
      end
    end
  end
end
