# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  for_type   :string           default("sale")
#

class Source < ActiveRecord::Base  
  has_many :tables
  has_many :options_for_history, as: :history_option, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: [:name, :for_type] }

  def self.all_sale
    all.where(for_type: 'sale')
  end

  def self.all_candidate
    all.where(for_type: 'candidate')
  end
end
