class Source < ActiveRecord::Base  
  has_many :tables
  validates :name, presence: true, uniqueness: { scope: [:name, :for_type] }

  def self.all_sale
    all.where(for_type: 'sale')
  end

  def self.all_candidate
    all.where(for_type: 'candidate')
  end
end
