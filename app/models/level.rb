# == Schema Information
#
# Table name: levels
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Level < ActiveRecord::Base
  has_many :tables
  has_many :options_for_plan, as: :option, dependent: :destroy
  has_many :options_for_history, as: :history_option, dependent: :destroy
end
