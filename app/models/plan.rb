class Plan < ActiveRecord::Base
  has_many :options_for_plan, dependent: :destroy

  validates :first_day_in_month, presence: true,  :uniqueness => { :scope => :for_type }
  validates :count, presence: true

  def self.all_sale
    all.where(for_type: 'sale')
  end

  def self.all_candidate
    all.where(for_type: 'candidate')
  end

  def find_percentage
    statuses, levels, specializations  = ["Status", "Level", "Specialization"].collect do|k|
      options_for_plan.where(option_type: k).blank? ? all_resourse(k) :
                                          options_for_plan.where(option_type: k,
                                                                status: "active").pluck(:option_id)
    end
    inform_count = Table.where(:updated_at => first_day_in_month..first_day_in_month.try(:end_of_month))
                  .where(status_id: statuses)
                  .where(level_id: levels)
                  .where(specialization_id: specializations).count

    self.percentage = inform_count.to_f / self.count * 100
    self.save
  end 

  def all_resourse(resours)
    resours.constantize.all.pluck(:id) << nil
  end

  def count_in_current_day(date, type = nil)
    statuses, levels, specializations  = ["Status", "Level", "Specialization"].collect do|k|
      options_for_plan.where(option_type: k).blank? ? all_resourse(k) :
                                          options_for_plan.where(option_type: k,
                                                                status: "active").pluck(:option_id)
    end
    inform_count = Table.where(["updated_at >= ? AND updated_at <= ?", date.beginning_of_day, date.end_of_day])
                  .where(status_id: statuses)
                  .where(level_id: levels)
                  .where(specialization_id: specializations).count

    inform_count = Table.where(["updated_at >= ? AND updated_at <= ?", date.beginning_of_day, date.end_of_day])
                        .where(type: type.to_s.downcase.capitalize).count if type.present?
    inform_count
  end
end
