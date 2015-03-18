class Task < ActiveRecord::Base
  belongs_to :user
  
  has_many :task_comments, dependent: :destroy
  has_many :comments, through: :task_comments
  
  has_one :sold_task,  dependent: :destroy
  has_many :messages, dependent: :destroy

  extend Enumerize

  enumerize :status, in: [:negotiations, :assigned_meeting, :waiting_estimate, :waiting_specification, :sold, :declined]

    def self.to_csv(options = {}, fields = ['name', 'email', 'status', 'date'])
      CSV.generate(options) do |csv|
		  csv << fields
      all.each do |task|
	      csv << task.attributes.values_at(*fields)
  		end
	  end
	end
end
