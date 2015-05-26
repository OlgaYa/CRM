class Status < ActiveRecord::Base
  has_many :tables
  has_many :options_for_plan, as: :option, dependent: :destroy
  has_many :options_for_history, as: :history_option, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: [:name, :for_type] }

  UNCHANGEABLESTATUS = %w(sold declined
                          negotiations
                          assigned_meeting
                          we_declined
                          he_declined
                          hired
                          contact_later)

  NOT_REMIND_WITH_STATUSES = ['10 Sold', '0 Declined',
                                'we_declined',
                                'he_declined',
                                'hired',
                                'contact_later']

  def self.all_sale
    all.where(for_type: 'sale')
  end

  def self.all_candidate
    all.where(for_type: 'candidate')
  end

  def self.default_status(type)
    case type
    when 'SALE'
      all_sale.where(name: '4 Interest').take.id
    when 'CANDIDATE'
      all_candidate.where(name: 'negotiations').take.id
    end
  end

  def self.meeting_status_id(type)
    case type
    when 'SALE'
      all_sale.where(name: '5 Asigned meeting').take.id
    when 'CANDIDATE'
      all_candidate.where(name: 'assigned_meeting').take.id
    end
  end

  def sold?
    name == 'sold' || name == '10 Sold'
  end

  def declined?
    name == 'declined' || name == '0 Declined'  || name == '1 ProbablyNo'
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
