# == Schema Information
#
# Table name: user_permissions
#
#  user_id       :integer
#  permission_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :user_permission do
    user
    permission
  end
end