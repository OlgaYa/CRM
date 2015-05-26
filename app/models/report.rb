class Report < ActiveRecord::Base
	belongs_to :user

  def self.all_in_this_month(date, q, current_user)
    where(user: current_user,
          :date => date.beginning_of_month..date.end_of_month).ransack(q)
  end
end
