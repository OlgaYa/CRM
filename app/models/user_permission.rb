# == Schema Information
#
# Table name: user_permissions
#
#  user_id       :integer
#  permission_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class UserPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :permission
end
