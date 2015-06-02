# == Schema Information
#
# Table name: permissions
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Permission < ActiveRecord::Base
  validates :name, presence: true
  has_many :user_permissions, dependent: :destroy
  has_many :users, through: :user_permissions

  def self.get(permission_name)
    find_by(name: permission_name)
  end

  def self.have?(permission_name)
    exists?(name: permission_name)
  end
end
