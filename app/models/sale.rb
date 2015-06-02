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

# This class defines essence of which users will be working with the permission seller
class Sale < Table
  # fields for Sale default scope
  DEFAULT_FIELDS = [:id,        :name,       :skype,
                    :email,     :date,       :user_id,
                    :source_id, :topic,      :status_id,
                    :type,      :created_at, :updated_at,
                    :phone]

  # fields for Sale scope with status 'sold'
  ADVANCED_FIELDS = DEFAULT_FIELDS + [:price,
                                      :date_start,
                                      :date_end]

  # default fields for building Sale table
  DEFAULT_COLUMNS = [:id,     :name,     :skype,
                     :email,  :date,     :user,
                     :source, :topic,    :status,
                     :comments, :links,  :phone]

  # default fields for building Sale table with status 'sold'
  ADVANCED_COLUMNS = DEFAULT_COLUMNS + [:price, :terms]

  # hash for building filters with params:
  # st_default type = operations: 'equally', 'not equally', 'multiple'
  # number     type = operations: 'equally', 'not equally',
  #                               'between', 'more', 'less'
  # date       type = operations: 'more', 'less', 'between'
  FIELDS_FOR_FILTER = [[:status,      :status_id,   filter_type: :st_default],
                       [:source,      :source_id,   filter_type: :st_default],
                       [:date,        :date,        filter_type: :date],
                       [:assigned_to, :user_id,     filter_type: :st_default]]

  before_save :set_date_status_1

  def self.default_scope
    select(DEFAULT_FIELDS)
  end

  def self.all_sold
    select(ADVANCED_FIELDS)
  end

  def self.open
    sql = "statuses.name <> '10 Sold' AND statuses.name <> '0 Declined' AND statuses.name <> '1 ProbablyNo'"
    all.join_statuses.where(sql)
  end

  def self.sold
    all_sold.join_statuses.where("statuses.name = '10 Sold'")
  end

  def self.declined
    all.join_statuses.where("statuses.name = '0 Declined' OR statuses.name = '1 ProbablyNo'")
  end

  def self.DEFAULT_COLUMNS
    DEFAULT_COLUMNS
  end

  def self.ADVANCED_COLUMNS
    ADVANCED_COLUMNS
  end

  def self.FIELDS_FOR_FILTER
    FIELDS_FOR_FILTER
  end

  def self.filter_params
    result = {}
    result[:user_id]   = entities_params(User.seller)
    result[:source_id] = entities_params(Source.all_sale)
    result[:status_id] = entities_params(Status.all_sale)
    result.to_json.html_safe
  end

  def self.entities_params(entitys)
    entitys.collect { |e| [e.name.to_sym, e.id] }
  end

  def set_date_status_1
    if self.changes[:status_id]
      self.date_status_1 = Time.current if self.status.name == '1 ProbablyNo'
    end
  end
end
