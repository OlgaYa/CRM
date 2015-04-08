class Comment < ActiveRecord::Base
  belongs_to :user
  
  has_one :table_comment, dependent: :destroy
  has_one :table, through: :table_comments

  # REMOVE
  # has_one :task_comment, dependent: :destroy
  # has_one :task, through: :task_comments


  validates :body, presence: true
  validates :datetime, presence: true
  validates :user_id, presence: true
end
