class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

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

  def self.destroy_reports
    destroy_all(["date < ?", Date.today - 1.years])
  end
end
