# == Schema Information
#
# Table name: options_for_histories
#
#  id                  :integer          not null, primary key
#  history_id          :integer
#  history_option_id   :integer
#  history_option_type :string
#

class OptionsForHistory < ActiveRecord::Base
	belongs_to :history_option, polymorphic: true
  belongs_to :history, dependent: :destroy
end
