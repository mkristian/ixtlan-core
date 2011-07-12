module Ixtlan
  module Core
    module OptimisticDataMapper

      def self.included(base)
        base.class_eval do
          def optimistic_find(updated_at, *args)
            updated_at = new(:updated_at => updated_at).updated_at
            # TODO make it work with different PKs
            first(:id => args[0], :updated_at => updated_at)
          end
        end
      end
    end
  end
end
