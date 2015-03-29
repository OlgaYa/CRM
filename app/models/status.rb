class Status < ActiveRecord::Base
  has_many :task
  validates :name, presence: true, uniqueness: true
end
