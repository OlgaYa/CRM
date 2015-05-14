# This class defines essence of which users will be working with the role seller
class Sale < Table
  # fields for Sale default scope
  DEFAULT_FIELDS = [:id,        :name,       :skype,
                    :email,     :date,       :user_id,
                    :source_id, :topic,      :status_id,
                    :type,      :created_at, :updated_at,
                    :lead,      :phone]

  # fields for Sale scope with status 'sold'
  ADVANCED_FIELDS = DEFAULT_FIELDS + [:price,
                                      :date_start,
                                      :date_end]

  # default fields for building Sale table
  DEFAULT_COLUMNS = [:id,     :name,     :skype,
                     :email,  :date,     :user,
                     :source, :topic,    :status,
                     :lead,   :comments, :links,
                     :phone]

  # default fields for building Sale table with status 'sold'
  ADVANCED_COLUMNS = DEFAULT_COLUMNS + [:price, :terms]

  # hash for building filters with params:
  # st_default type = operations: 'equally', 'not equally', 'multiple'
  # number     type = operations: 'equally', 'not equally',
  #                               'between', 'more', 'less'
  # date       type = operations: 'more', 'less', 'between'
  FIELDS_FOR_FILTER = [[:lead,        :lead,        filter_type: :number],
                       [:status,      :status_id,   filter_type: :st_default],
                       [:source,      :source_id,   filter_type: :st_default],
                       [:date,        :date,        filter_type: :date],
                       [:assigned_to, :user_id,     filter_type: :st_default]]

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

  def self.FIELDS_FOR_FILTER
    FIELDS_FOR_FILTER
  end

  def self.filter_params
    result = {}
    result[:user_id]   = entities_params(User.seller)
    result[:source_id] = entities_params(Source.all_sale)
    result[:status_id] = entities_params(Status.all_sale)
    result[:lead]      = [1,2,3,4,5,6,7,8,9,10]
    result.to_json.html_safe
  end

  def self.entities_params(entitys)
    entitys.collect { |e| [e.name.to_sym, e.id] }
  end
end
