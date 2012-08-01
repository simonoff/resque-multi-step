module Resque
  module Plugins
    class MultiStepTask
      module AtomicCounters
        def counter(name)
          class_eval <<-INCR
            def increment_#{name}
              retryable(:tries => 5, :on => [TimeoutError, Errno::EAGAIN]) do
                redis.incr('#{name}')
              end
            end
            INCR

          class_eval <<-GETTER
            def #{name}
              retryable(:tries => 5, :on => [TimeoutError, Errno::EAGAIN]) do
                redis.get('#{name}').to_i
              end
            end
            GETTER
        end
      end
    end
  end
end
