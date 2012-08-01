module Resque
  module Plugins
    class MultiStepTask
      # in the case that all normal jobs have completed before the job group
      # is finalized, the job group will never receive the hook to enter
      # finalizataion.  To avoid this, an AssureFinalization job will be added
      # to the queue for the sole purposed of initiating finalization for certain.
      class AssureFinalization
        def self.perform(task_id)
          MultiStepTask.find(task_id).maybe_finalize
        rescue NoSuchMultiStepTask
          # Eat the exception, finalization has already occurred via a normal job
        end
      end
    end
  end
end
