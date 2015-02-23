class Comment < ActiveRecord::Base
  belongs_to :user
  has_one :task_comment, dependent: :destroy
  has_one :task, through: :task_comments
end
