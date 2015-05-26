class Link < ActiveRecord::Base  
  belongs_to :table
  has_many :options_for_history, as: :history_option, dependent: :destroy
end
