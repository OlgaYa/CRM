class Plan < ActiveRecord::Base
  has_many :options_for_plan, dependent: :destroy

  validates :date_from, presence: true
  validates :date_to, presence: true
  validates :count, presence: true

  def self.all_sale
    all.where(for_type: 'sale')
  end

  def self.all_candidate
    all.where(for_type: 'candidate')
  end

  def find_percentage
    date_start = self.date_from.at_beginning_of_week
    date_end = self.date_to.at_end_of_week
    inform = Statistic.where(:week => date_start..date_end)
    users, statuses, levels, specializations  = ["User", "Status", "Level", "Specialization"].collect do|k|
     self.options_for_plan.where(option_type: k).blank? ? [0] : self.options_for_plan.where(option_type: k).pluck(:option_id)
    end
    inform_count = 0
    users.each do |u|
      select_user = u.zero? ? "" : "user_id = #{u}"
      statuses.each do |st|
        select_status = st.zero? ? "status_id = #{Status.default_status(self.for_type)}" : "status_id = #{st}"
        levels.each do |l|
          select_level = l.zero? ? "" : "level_id = #{l}"
          specializations.each do |sp|
            select_specialization = sp.zero? ? "" : "specialization_id = #{sp}"
            inform_count +=  inform.where(select_user).where(select_status).where(select_level).where(select_specialization).sum(:count)
          end
        end
      end
    end

    self.percentage = inform_count.to_f / self.count * 100
    self.save

  end 
end
