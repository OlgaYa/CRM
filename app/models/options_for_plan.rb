# == Schema Information
#
# Table name: options_for_plans
#
#  id          :integer          not null, primary key
#  plan_id     :integer
#  option_id   :integer
#  option_type :string
#

class OptionsForPlan < ActiveRecord::Base
	belongs_to :option, polymorphic: true
end
