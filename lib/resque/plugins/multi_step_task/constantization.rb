module Resque
  module Plugins
    class MultiStepTask
      module Constantization
        # Courtesy ActiveSupport (Ruby on Rails)
        if defined?(::ActiveSupport::Inflector.constantize)
          def constantize(camel_cased_word)
            ::ActiveSupport::Inflector.constantize(camel_cased_word)
          end
        else
          if Module.method(:const_get).arity == 1
            def constantize(camel_cased_word)
              names = camel_cased_word.split('::')
              names.shift if names.empty? || names.first.empty?

              constant = Object
              names.each do |name|
                constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
              end
              constant
            end
          else
            def constantize(camel_cased_word) #:nodoc:
              names = camel_cased_word.split('::')
              names.shift if names.empty? || names.first.empty?

              constant = Object
              names.each do |name|
                constant = constant.const_defined?(name, false) ? constant.const_get(name) : constant.const_missing(name)
              end
              constant
            end
          end
        end
      end
    end
  end
end

