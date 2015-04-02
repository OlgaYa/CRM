# This class defines essence of which users will be working with the role seller
class Sale < Table
  scope :join_statuses,
        -> { joins('INNER JOIN statuses ON tables.status_id = statuses.id') }

  def self.default_scope
    select(:id, :name, :skype,
           :email, :date,
           :user_id, :source_id,
           :topic, :status_id,
           :type)
  end

  def self.all_sold
    select(:id, :name, :skype,
           :email, :date,
           :user_id, :source_id,
           :topic, :status_id,
           :price, :date_start,
           :date_end, :type)
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
end
