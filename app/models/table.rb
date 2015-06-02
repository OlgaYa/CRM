# == Schema Information
#
# Table name: tables
#
#  id                :integer          not null, primary key
#  type              :string
#  name              :string
#  level_id          :integer
#  specialization_id :integer
#  email             :string
#  source_id         :integer
#  date              :datetime
#  status_id         :integer
#  topic             :string
#  skype             :string
#  user_id           :integer
#  price             :integer
#  date_start        :date
#  date_end          :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  reminder_date     :datetime
#  phone             :string
#  date_status_1     :date
#

# Parent model for all entitis
class Table < ActiveRecord::Base
  belongs_to :source
  belongs_to :status
  belongs_to :specialization
  belongs_to :level
  belongs_to :user
  
  has_many :links
  has_many :table_comments, dependent: :destroy
  has_many :comments, through: :table_comments
  has_many :meetings, dependent: :destroy
  has_many :history, dependent: :destroy

  scope :join_statuses,
        -> { joins('INNER JOIN statuses ON tables.status_id = statuses.id') }

  after_save :add_email_to_mailchimp

  def self.in_time_period(from, to)
    from = DateTime.now - 365.day unless nil_if_blank(from)
    to = DateTime.now unless nil_if_blank(to)
    where(created_at: (from)..to)
  end

  def self.belongs_to_users(users)
    users = User.all.pluck(:id) unless users
    where(user_id: users)
  end

  def self.with_statuses(statuses)
    statuses = Status.all.pluck(:id) unless statuses
    where(status_id: statuses)
  end

  def self.oder_date_nulls_first
    order('date DESC NULLS FIRST')
  end

  def self.export(from, to, users, statuses)
    in_time_period(nil_if_blank(from), nil_if_blank(to)
                   ).belongs_to_users(users
                   ).with_statuses(statuses)
  end


  def self.nil_if_blank(value)
    nil if value.blank?
  end

  def self.to_csv(options = {}, fields)
    fields = %w(name email status_id date) unless fields
    CSV.generate(options) do |csv|
      csv << fields_names(fields)
      all.each do |product|
        arr = []
        product.attributes.each do |attribute|
          arr << field_value(attribute) if fields.include? attribute[0]
        end
        csv << arr
      end
    end
  end

  def self.fields_names(fields)
    return fields unless first
    ordered_fields = []
    first.attributes.each do |attribute|
      ordered_fields << attribute[0] if fields.include? attribute[0]
    end
    ordered_fields
  end

  def self.field_value(attribute)
    case attribute[0]
    when 'status_id'
      Status.find(attribute[1]).name if attribute[1]
    when 'source_id'
      Source.find(attribute[1]).name if attribute[1]
    when 'specialization_id'
      Specialization.find(attribute[1]).name if attribute[1]
    when 'level_id'
      Level.find(attribute[1]).name if attribute[1]
    when 'user_id'
      User.find(attribute[1]).full_name if attribute[1]
    when 'date'
      attribute[1]
    else
      attribute[1].gsub(/(,|;)/, ' ') if attribute[1]
    end
  end

  def add_email_to_mailchimp
    return unless Rails.env.production?
    MailchimpWorker.perform_async({
      'id' => self.id,
      'email' => self.email.nil? ? '' : self.email.strip,
      'type' => self.type,
      'level_name' => self.level.nil? ? nil : self.level.name,
      'specialization_name' => self.specialization.nil? ? nil : self.specialization.name,
      'name' => self.name
    })
  end
end
