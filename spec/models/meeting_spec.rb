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

require 'rails_helper'

RSpec.describe Meeting, type: :model do
end
