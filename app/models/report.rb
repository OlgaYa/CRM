# == Schema Information
#
# Table name: reports
#
#  id         :integer          not null, primary key
#  project    :string
#  task       :string
#  user_id    :integer
#  hours      :float
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Report < ActiveRecord::Base
  belongs_to :user

  validates :date, presence: true
  validates :hours, presence: true
  validates :task, presence: true
  validates :project, presence: true

  def self.all_in_this_month(date, current_user)
    where(user: current_user,
          date: date.beginning_of_month..date.end_of_month)
  end

  def self.month_repors_time(date, current_user)
    all_in_this_month(date, current_user).sum :hours
  end
end
