class Source < ActiveRecord::Base
  
  has_many :sales
  has_many :candidates
  validates :name, presence: true

  def self.all_sale
    all.where(for_type: 'sale')
  end

  def self.all_candidate
    all.where(for_type: 'candidate')
  end
end
