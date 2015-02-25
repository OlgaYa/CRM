class TaskComment < ActiveRecord::Base
  belongs_to :comment
  belongs_to :task
end
