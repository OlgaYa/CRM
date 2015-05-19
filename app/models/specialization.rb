class Specialization < ActiveRecord::Base
  has_many :tables
  has_many :options_for_plan, as: :option
  has_many :options_for_history, as: :history_option
end
