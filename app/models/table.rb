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

  scope :join_statuses,
        -> { joins('INNER JOIN statuses ON tables.status_id = statuses.id') }

  def self.in_time_period(from, to)
    from = DateTime.now - 365.day unless from
    to = DateTime.now unless to
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
    in_time_period(from, to).belongs_to_users(users).with_statuses(statuses)
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
end
