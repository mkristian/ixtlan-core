module Rails
  module Generators
    class ModelGenerator < NamedBase #metagenerator
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
      hook_for :orm, :required => true

      if defined? Resty
        hook_for :resty, :type => :boolean, :default => true
      end
    end
  end
end
