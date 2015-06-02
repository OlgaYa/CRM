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

require 'rails_helper'

RSpec.describe Plan, type: :model do
end
