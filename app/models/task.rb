class Task < ActiveRecord::Base
  after_create :update_status

  belongs_to :user
  
  has_many :task_comments, dependent: :destroy
  has_many :comments, through: :task_comments
  
  has_one :sold_task,  dependent: :destroy
  has_many :messages, dependent: :destroy

  belongs_to :source
  has_many :links
  belongs_to :status

  scope :join_statuses, -> { joins("INNER JOIN statuses ON tasks.status_id = statuses.id") }
  scope :where_status_not_sold_or_declined, -> { where("statuses.name <> 'sold' AND statuses.name <> 'declined'") }
  scope :by_date, -> { order("date ASC NULLS FIRST, created_at DESC") }

  # extend Enumerize

  # enumerize :status, in: [:negotiations, :assigned_meeting, :waiting_estimate, :waiting_specification, :sold, :declined]

    def self.to_csv(options = {}, fields = ['name', 'email', 'status', 'date'])
        CSV.generate(options) do |csv|
        csv << fields
        all.each do |task|
          attributes = task.attributes.values_at(*fields)
          if fields.include?('user_id')
            i = fields.index('user_id')
            user = User.find(attributes[i].to_i)
            attributes[i] = "#{user.first_name} #{user.last_name}"
          end
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
        id = Status.find_by(name: 'negotiations').id
        self.update_attribute(:status_id, id)
      end
end
