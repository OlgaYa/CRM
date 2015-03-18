class Task < ActiveRecord::Base
  after_create :update_status

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
          attributes = task.attributes.values_at(*fields)
          attributes.map! do |val|
            if val.is_a? String 
              val = val.gsub(',',' ')
            else
              val
            end 
          end
          csv << attributes
    		end
  	  end
    end

    private

      def update_status
        self.update_attribute(:status, :negotiations)
      end
end
