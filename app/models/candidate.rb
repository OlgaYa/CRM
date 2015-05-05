# This class defines the essence of which users will be working with the role HH
class Candidate < Table
  DEFAULT_FIELDS = [:id,
                    :name,
                    :level_id,
                    :specialization_id,
                    :email,
                    :skype,
                    :source_id,
                    :date,
                    :user_id,
                    :status_id,
                    :type,
                    :created_at,
                    :updated_at]

  ADVANCED_FIELDS = DEFAULT_FIELDS + [:reminder_date]

  DEFAULT_COLUMNS = [:id,
                     :name,
                     :level,
                     :specialization,
                     :email,
                     :skype,
                     :source,
                     :date,
                     :user,
                     :status,
                     :comments,
                     :links]
  
  ADVANCED_COLUMNS = DEFAULT_COLUMNS + [:reminder_date]

  def self.default_scope
    select(DEFAULT_FIELDS)
  end

  def self.all_contact_later
    select(ADVANCED_FIELDS)
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

  def self.DEFAULT_COLUMNS
    DEFAULT_COLUMNS
  end

  def self.ADVANCED_COLUMNS
    ADVANCED_COLUMNS
  end
end
