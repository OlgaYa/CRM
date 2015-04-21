class Specialization < ActiveRecord::Base
  has_many :tables
  has_many :options_for_plan, as: :option
end
