class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :set_user_settings

  has_many :tables
  has_many :reports
  has_many :dt_reports
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :options_for_history, as: :history_option, dependent: :destroy
  has_one :user_setting
  has_and_belongs_to_many :projects

  has_many :user_permissions, dependent: :destroy
  has_many :permissions, through: :user_permissions

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  # FIXME
  has_attached_file :avatar, styles: { medium: '128x128>',
                                       small: '36x36' },
                             default_url: 'avatar-default.jpg'
  
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  extend Enumerize
  enumerize :status, in: [:observer, :lock, :unlock]

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset(current_user)
    generate_token(:reset_password_token)
    self.reset_password_sent_at = Time.zone.now
    save!
    UserMailer.new_password_instructions(self, current_user).deliver
  end

  def self.reminder
    date = Date.yesterday.saturday? ? 4.days : 2.days
    tables = Table.where('updated_at < ?', Date.today - date)
    hash = {}
    tables.each do |t|
      status = t.status
      unless(status.not_remind? || !t.user_id)
        if hash.key?(t.user_id)
          hash[t.user_id] << t.name
        else
          hash[t.user_id] = [t.name]
        end
      end
    end
    hash.each_key do |k|
      UserMailer.reminder_instructions(k, hash[k]).deliver
    end
  end

  def self.contact_later_reminder
    tables = Candidate.contact_later
    tables.each do |t|
      reminder_date = t.reminder_date
      if reminder_date.to_date == Date.today
        UserMailer.remind_today(t.id).deliver_later(wait_until: reminder_date)
      end
    end
  end

  def name
    full_name
  end

  # method check does user has Permission with name = 'permission_name'
  def permission?(permission_name)
    permissions.have?(permission_name)
  end

  # method used when menu is generated
  def admin_permission?
    [:manage_hh_controls,
     :manage_seller_controls,
     :hr_admin,
     :crm_controls_admin].any? { |sym| permissions.have? sym }
  end

  def self.all_except(user)
    where.not(id: user)
  end

  def self.all_unlock
    where(status: 'unlock')
  end

  def self.all_lock
    where(status: 'lock')
  end

  def self.hh
    Permission.get('manage_candidates').users
  end

  def self.seller
    Permission.get('manage_sales').users
  end

  def self.all_candidate
    hh
  end

  def self.all_sale
    seller
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def self.reports_oblige_users
    where('id IN (?)',
          Permission.get('self_reports').users.pluck(:id))
  end

  def current_user?(user)
    user == current_user
  end

  def dt_month_time(date)
    seconds_to_time(dt_reports.where(date: date.beginning_of_month..date.end_of_month).sum :time)
  end

  def reports_month_time(date)
    time = reports.where(date: date.beginning_of_month..date.end_of_month).sum :hours
    seconds_to_time((time * 3600).to_i)
  end

  def seconds_to_time(seconds)
    [seconds / 3600, seconds / 60 % 60].map do |time|
      time.to_s.rjust(2, '0')
    end.join(':')
  end

  def set_user_settings
    return unless user_setting.nil?
    self.user_setting = UserSetting.new(:hh_record_per_page => 'all', :sale_record_per_page => 'all')
    self.user_setting.save!
  end

  def self.all_users_for_project
    all.pluck(:first_name, :last_name, :id).select do|p|
      p
    end
  end

  def self.all_users_not_for_current_project project_id
    all.pluck(:first_name, :last_name, :id).select do|p|
      p unless User.find(p[2]).projects.include? Project.find(project_id)
    end
  end

  def self.all_users_for_current_project project_id
    all.pluck(:first_name, :last_name, :id).select do|p|
      p if User.find(p[2]).projects.include? Project.find(project_id)
    end
  end
end
