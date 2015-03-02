class SoldTask < ActiveRecord::Base
	belongs_to :task
	belongs_to :user

	validates :user, presence: true
	validates :task, presence: true
	validates :user_id, presence: true
	validates :task_id, presence: true, uniqueness: true
end
