class Source < ActiveRecord::Base
  # REMOVE
  # has_many :task
  
  has_many :sales
  has_many :candidates
  validates :name, presence: true, uniqueness: true
end
