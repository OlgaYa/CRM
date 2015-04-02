# Parent model for all entitis
class Table < ActiveRecord::Base
  belongs_to :source
  belongs_to :status
  belongs_to :specializations
  belongs_to :levels
  belongs_to :user
  has_many :links

  has_many :table_comments, dependent: :destroy
  has_many :comments, through: :table_comments
end
