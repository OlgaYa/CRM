class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tables
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :options_for_plan, as: :option
  has_many :options_for_history, as: :history_option
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  # FIXME
  has_attached_file :avatar, styles: { medium: '128x128>',
                                       small: '36x36' },
                             default_url: 'avatar-default.jpg'
  
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  extend Enumerize

  enumerize :status, in: [:observer, :lock, :unlock]
  enumerize :role,   in: [:hh, :hr, :seller]

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
    where(role: 'hh')
  end

  def self.seller
    where(role: 'seller')
  end

  def self.all_candidate
    self.hh
  end

  def self.all_sale
    self.seller
  end

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def locked?
    status == 'lock'
  end

  def seller?
    role == 'seller'
  end

  def hh?
    role == 'hh'
  end

  def hr?
    role == 'hr'
  end
end
