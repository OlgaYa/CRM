class Status < ActiveRecord::Base
  has_many :tables
  validates :name, presence: true, uniqueness: { scope: [:name, :for_type] }

  UNCHANGEABLESTATUS = %w(sold declined negotiations assigned_meeting)

  def self.all_sale
    all.where(for_type: 'sale')
  end

  def self.all_candidate
    all.where(for_type: 'candidate')
  end

  def self.default_status(type)
    if type == 'SALE'
      all_sale.where(name: 'negotiations').take.id
    else
      all_candidate.where(name: 'negotiations').take.id
    end
  end

  def sold?
    name == 'sold'
  end

  def declined?
    name == 'declined'
  end

  def unchengeble_satus?
    UNCHANGEABLESTATUS.include?(name)
  end
end
