class Holiday < ActiveRecord::Base
  validates :date, presence: true, uniqueness: true
end
