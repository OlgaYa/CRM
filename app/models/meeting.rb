# == Schema Information
#
# Table name: meetings
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  location    :string
#  start_time  :datetime
#  end_time    :datetime
#  table_id    :integer
#  event_id    :string
#  for_type    :string
#  email       :string
#

class Meeting < ActiveRecord::Base
  validates :start_time, presence: true
  validates :title, presence: true
  belongs_to :table
end
