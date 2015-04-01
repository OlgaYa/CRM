class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tasks
  has_many :comments, dependent: :destroy
  has_many :sold_tasks
  has_many :messages, dependent: :destroy

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "36x36" }, :default_url => 'avatar-default.jpg'
  
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

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
    date = 2.days
    date += 2.days if Date.yesterday.saturday?
     tasks = Task.where("updated_at < ?", Date.today - date)
    # tasks = Task.where("updated_at < ?", 1.minute.ago)
    hash = {}
    tasks.each do |t|
      status = t.status
      unless ( status.name ==  "declined" ||  status.name == "sold" || !t.user_id )
        if hash.key?(t.user_id)
          hash[t.user_id]<<t.name
        else
          hash[t.user_id] = [t.name]
        end
      end
    end
    hash.each_key do |k|
      UserMailer.reminder_instructions(k, hash[k]).deliver
    end
  end

  def self.all_except(user)
    where.not(id: user)
  end
end
