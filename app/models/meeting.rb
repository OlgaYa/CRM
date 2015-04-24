class Meeting < ActiveRecord::Base
  validates :start_time, presence: true
  validates :title, presence: true
end
