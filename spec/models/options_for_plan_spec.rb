# == Schema Information
#
# Table name: options_for_plans
#
#  id          :integer          not null, primary key
#  plan_id     :integer
#  option_id   :integer
#  option_type :string
#

require 'rails_helper'

RSpec.describe OptionsForPlan, type: :model do
end
