class Status < ActiveRecord::Base
  has_many :tables
  has_many :options_for_plan, as: :option
  validates :name, presence: true, uniqueness: { scope: [:name, :for_type] }

  UNCHANGEABLESTATUS = %w(sold declined
                          negotiations
                          assigned_meeting
                          we_declined
                          he_declined
                          hired
                          contact_later)

  NOT_REMIND_WITH_STATUSES = %w(sold declined
                                we_declined
                                he_declined
                                hired
                                contact_later)

  def self.all_sale
    all.where(for_type: 'sale')
  end

  def self.all_candidate
    all.where(for_type: 'candidate')
  end

  def self.default_status(type)
    case type
    when 'SALE'
      all_sale.where(name: 'negotiations').take.id
    when 'CANDIDATE'
      all_candidate.where(name: 'negotiations').take.id
    end
  end

  def self.meeting_status_id(type)
    case type
    when 'SALE'
      all_sale.where(name: 'assigned_meeting').take.id
    when 'CANDIDATE'
      all_candidate.where(name: 'assigned_meeting').take.id
    end
  end

  def sold?
    name == 'sold'
  end

  def declined?
    name == 'declined'
  end

  def contact_later?
    name == 'contact_later'
  end

  def unchengeble_satus?
    UNCHANGEABLESTATUS.include?(name)
  end

  def not_remind?
    NOT_REMIND_WITH_STATUSES.include?(name)
  end
end
