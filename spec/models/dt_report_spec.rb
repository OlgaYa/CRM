# == Schema Information
#
# Table name: dt_reports
#
#  id         :integer          not null, primary key
#  date       :date
#  time       :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe DtReport, type: :model do
end
