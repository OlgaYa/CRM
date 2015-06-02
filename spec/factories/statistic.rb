# == Schema Information
#
# Table name: statistics
#
#  id                :integer          not null, primary key
#  statistic_id      :integer
#  for_type          :string
#  level_id          :integer
#  specialization_id :integer
#  source_id         :integer
#  week              :date
#  status_id         :integer
#  user_id           :integer
#  count             :integer          default(1)
#

FactoryGirl.define do
  factory :statistic do
    
  end
end