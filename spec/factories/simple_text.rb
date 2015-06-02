# == Schema Information
#
# Table name: simple_texts
#
#  id         :integer          not null, primary key
#  name       :string
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#


FactoryGirl.define do
  factory :simple_text do
  end
end