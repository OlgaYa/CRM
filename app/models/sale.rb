# This class defines essence of which users will be working with the role seller
class Sale < Table
  # CAN BE USEFUL IN FUTURE
  FILTER_ENTITIES = %w(user_id source_id status_id)
  FILTER_DATE_FIELDS = %w(date_start date_end)

  def self.default_scope
    select(:id, :name, :skype,
           :email, :date,
           :user_id, :source_id,
           :topic, :status_id,
           :type, :created_at,
           :updated_at)
  end

  def self.all_sold
    select(:id, :name, :skype,
           :email, :date,
           :user_id, :source_id,
           :topic, :status_id,
           :price, :date_start,
           :date_end, :type,
           :created_at, :updated_at)
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

  # CAN BE USEFUL IN FUTURE
  def self.simple_filters
    default_filters FILTER_ENTITIES
  end
end
