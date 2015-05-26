class OptionsForHistory < ActiveRecord::Base
	belongs_to :history_option, polymorphic: true
  belongs_to :history, dependent: :destroy
end
