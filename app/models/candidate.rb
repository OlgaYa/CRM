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

# This class defines the essence of which users will be working with the permission HH
class Candidate < Table
  
  # fields for Candidate scope
  DEFAULT_FIELDS = [:id,    :name,       :level_id,
                    :email, :skype,      :source_id,
                    :date,  :user_id,    :status_id,
                    :type,  :created_at, :updated_at,
                    :phone, :specialization_id]

  # fields for Candidate scope with status 'contact_later'
  ADVANCED_FIELDS = DEFAULT_FIELDS + [:reminder_date]

  # default fields for building Candidate table
  DEFAULT_COLUMNS = [:id,    :name,   :level,
                     :email, :skype,  :source,
                     :date,  :status, :comments,
                     :phone, :links,  :specialization]

  # default fields for building Candidate table with status 'contact_later'
  ADVANCED_COLUMNS = DEFAULT_COLUMNS + [:reminder]

  # hash for building filters with params:
  # st_default type = operations: 'equally', 'not equally'
  # number     type = operations: 'equally', 'not equally',
  #                               'between', 'more', 'less'
  # date       type = operations: 'more', 'less', 'between'
  FIELDS_FOR_FILTER = [[:status,      :status_id,   filter_type: :st_default],
                       [:source,      :source_id,   filter_type: :st_default],
                       [:date,        :date,        filter_type: :date],
                       [:level,       :level_id,    filter_type: :st_default],
                       [:specialization, :specialization_id,
                        filter_type: :st_default]]

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

  def self.FIELDS_FOR_FILTER
    FIELDS_FOR_FILTER
  end

  def self.filter_params
    result = {}
    result[:source_id] = entities_params(Source.all_candidate)
    result[:status_id] = entities_params(Status.all_candidate)
    result[:specialization_id] = entities_params(Specialization.all)
    result[:level_id] = entities_params(Level.all)
    result.to_json.html_safe
  end

  def self.entities_params(entitys)
    result = entitys.collect { |e| [e.name.to_sym, e.id] }
  end
end
