class OptionsForHistory < ActiveRecord::Base
	belongs_to :history_option, polymorphic: true
end