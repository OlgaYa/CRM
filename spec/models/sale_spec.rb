# == Schema Information
#
# Table name: tables
#
#  id                :integer          not null, primary key
#  type              :string
#  name              :string
#  level_id          :integer
#  specialization_id :integer
#  email             :string
#  source_id         :integer
#  date              :datetime
#  status_id         :integer
#  topic             :string
#  skype             :string
#  user_id           :integer
#  price             :integer
#  date_start        :date
#  date_end          :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  reminder_date     :datetime
#  phone             :string
#  date_status_1     :date
#

require 'rails_helper'

RSpec.describe Sale, type: :model do
end
