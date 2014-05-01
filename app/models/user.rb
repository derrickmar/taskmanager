# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  number                 :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

class User < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_PHONE_REGEX = /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/

	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "missing.jpg"
	validates_attachment :avatar,
	:content_type => { :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png"] }

	has_settings do |s|
		s.key :settings, :defaults => { :completed_hidden => false, :view => "seven",
			:daily_email => true }
		end

		before_save { self.email = email.downcase }
		before_save { 
			@password = self.password
		#puts "+++++++++++"
		#puts self.password
	}
	# create remember token to remember user after login
	before_create :create_remember_token
	after_create :fifteen_days
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
	uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 },
	:if => :password_validation_required?
	validates :number, allow_blank: true, format: { with: VALID_PHONE_REGEX }

	#for week association
	# has_many :weeks, dependent: :destroy
	has_many :days, dependent: :destroy
	has_many :tags, dependent: :destroy

	# generates token for password_reset
	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
		# the while loop is so if we generate a token that is the same as on in the userbase
		# then we loop and generate another one.
	end

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_sent_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end

	def password_validation_required?
		self.password_digest.blank? || !@password.blank?
	end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private
	def create_remember_token
		self.remember_token = User.encrypt(User.new_remember_token)
	end

	def fifteen_days
		Day.create(day: Date.today.strftime("%A"), date: Date.today, user_id: self.id)
		Day.create(day: Date.tomorrow.strftime("%A"), date: Date.tomorrow, user_id: self.id)
		start_date = 2.days.from_now.to_date
		end_date = 14.days.from_now.to_date
		start_date.upto(end_date) do |day|
			Day.create(day: day.strftime("%A"), date: day, user_id: self.id)
		end
	end

end
