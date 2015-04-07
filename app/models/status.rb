class Status < ActiveRecord::Base
  # REMOVE
  # has_many :task
  
  has_many :tables
  validates :name, presence: true, uniqueness: true
end
