module AttrChecked
  module V1
    def add_checked_attribute clazz, attr
      code = %{
        class #{clazz}
          def #{attr.to_s}
            @#{attr.to_s}
          end

          def #{attr.to_s}= value
            raise ArgumentError unless value
            @#{attr.to_s} = value
          end
        end
      }

      eval code
    end
  end

  module V2
    def add_checked_attribute attr
      self.class_eval do
        define_method attr.to_s do
          instance_variable_get "@#{attr}"
        end

        define_method "#{attr.to_s}=" do |value|
          raise ArgumentError unless value
          #@attr.to_s = value
          instance_variable_set "@#{attr}", value
        end
      end
    end
  end

  module V3
    def add_checked_attribute attr, &block
      self.class_eval do
        define_method attr.to_s do
          instance_variable_get "@#{attr}"
        end

        define_method "#{attr.to_s}=" do |value|
          if block_given?
            raise ArgumentError unless block.call(value)
          else
            raise ArgumentError unless value
          end
          instance_variable_set "@#{attr}", value
        end
      end
    end
  end

  module V4
    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def add_checked_attribute attr, &block
        define_method attr.to_s do
          instance_variable_get "@#{attr}"
        end

        define_method "#{attr.to_s}=" do |value|
          if block_given?
            raise ArgumentError unless block.call(value)
          else
            raise ArgumentError unless value
          end
          instance_variable_set "@#{attr}", value
        end
      end
    end
  end

end
