# This class defines essence of which users will be working with the role seller
class Sale < Table
  DEFAULT_FIELDS = [:id,
                    :name,
                    :skype,
                    :email,
                    :date,
                    :user_id,
                    :source_id,
                    :topic,
                    :status_id,
                    :type,
                    :created_at,
                    :updated_at,
                    :lead]

  ADVANCED_FIELDS = DEFAULT_FIELDS + [:price,
                                      :date_start,
                                      :date_end]

  DEFAULT_COLUMNS = [:id,
                     :name,
                     :skype,
                     :email,
                     :date,
                     :user,
                     :source,
                     :topic,
                     :status,
                     :lead,
                     :comments,
                     :links]

  ADVANCED_COLUMNS = DEFAULT_COLUMNS + [:price, :terms]

  def self.default_scope
    select(DEFAULT_FIELDS)
  end

  def self.all_sold
    select(ADVANCED_FIELDS)
  end

  def self.open
    sql = "statuses.name <> 'sold' AND statuses.name <> 'declined'"
    all.join_statuses.where(sql)
  end

  def self.sold
    all_sold.join_statuses.where("statuses.name = 'sold'")
  end

  def self.declined
    all.join_statuses.where("statuses.name = 'declined'")
  end

  def self.DEFAULT_COLUMNS
    DEFAULT_COLUMNS
  end

  def self.ADVANCED_COLUMNS
    ADVANCED_COLUMNS
  end
end
