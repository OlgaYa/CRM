# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  alt        :string
#  href       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  table_id   :integer
#

class Link < ActiveRecord::Base  
  belongs_to :table
  has_many :options_for_history, as: :history_option, dependent: :destroy
end
