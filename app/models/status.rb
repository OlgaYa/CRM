class Status < ActiveRecord::Base
  # has_many :task
  has_many :tables
  validates :name, presence: true, uniqueness: true
end
