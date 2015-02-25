class Task < ActiveRecord::Base
  belongs_to :user
  
  has_many :task_comments, dependent: :destroy
  has_many :comments, through: :task_comments



  extend Enumerize

  enumerize :status, in: [:negotiations, :assigned_meeting, :waiting_estimate, :waiting_specification]
end
