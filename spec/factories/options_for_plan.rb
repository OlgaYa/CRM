# == Schema Information
#
# Table name: options_for_plans
#
#  id          :integer          not null, primary key
#  plan_id     :integer
#  option_id   :integer
#  option_type :string
#

FactoryGirl.define do
  factory :options_for_plan do
  end
end