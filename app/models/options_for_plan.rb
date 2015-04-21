class OptionsForPlan < ActiveRecord::Base
	belongs_to :option, polymorphic: true
end