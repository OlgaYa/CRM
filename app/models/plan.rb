# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  date_from  :date
#  date_to    :date
#  for_type   :string           default("sale")
#  count      :integer          default(0)
#  percentage :integer          default(0)
#

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
    date_start = date_from.at_beginning_of_week
    date_end = date_to.at_end_of_week
    users, statuses, levels, specializations  = ["User", "Status", "Level", "Specialization"].collect do|k|
     options_for_plan.where(option_type: k).blank? ? all_resourse(k) : options_for_plan.where(option_type: k).pluck(:option_id)
    end
    inform_count = Table.where(:updated_at => date_start..date_end)
                  .where(user_id: users)
                  .where(status_id: statuses)
                  .where(level_id: levels)
                  .where(specialization_id: specializations).count

    self.percentage = inform_count.to_f / self.count * 100
    self.save
  end 

  def all_resourse(resours)
    resours.constantize.all.pluck(:id) << nil
  end
end
