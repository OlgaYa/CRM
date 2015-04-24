# This class defines the essence of which users will be working with the role HH
class Candidate < Table
  # CAN BE USEFUL IN FUTURE
  FILTER_ENTITIES = %w(user_id level_id specialization_id source_id status_id)
  FILTER_DATE_FIELDS = %w(date_start date_end)

  def self.default_scope
    select(:id, :name, :level_id,
           :specialization_id,
           :email, :skype, :source_id,
           :date, :status_id,
           :type, :created_at,
           :updated_at)
  end

  def self.all_contact_later
    select(:id, :name, :level_id,
           :specialization_id,
           :email, :skype, :source_id,
           :date, :status_id,
           :type, :created_at,
           :updated_at, :user_id,
           :reminder_date)
  end

  def self.open
    sql = "statuses.name <> 'hired'
          AND statuses.name <> 'we_declined'
          AND statuses.name <> 'he_declined'
          AND statuses.name <> 'contact_later'"
    all.join_statuses.where(sql)
  end

  def self.hired
    all.join_statuses.where("statuses.name = 'hired'")
  end

  def self.we_declined
    all.join_statuses.where("statuses.name = 'we_declined'")
  end

  def self.he_declined
    all.join_statuses.where("statuses.name = 'he_declined'")
  end

  def self.contact_later
    all_contact_later.join_statuses.where("statuses.name = 'contact_later'")
  end

  # CAN BE USEFUL IN FUTURE
  def self.simple_filters
    default_filters FILTER_ENTITIES
  end
end
