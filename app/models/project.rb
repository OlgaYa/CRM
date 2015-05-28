class Project < ActiveRecord::Base
  has_and_belongs_to_many :users

  def self.all_active
    where(status: "active")
  end
end
