class User < ActiveRecord::Base
  belongs_to :state
  has_many :events
  has_many :joins
  has_many :joined_events, through: :joins, source: :event
  has_many :comments
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name,:last_name,:location, presence:true, length:{minimum:2}
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
  validates :state, presence:true
  validates :password, presence:true, length:{minimum:8}, on: :create
  has_secure_password

  before_save :email_lowercase
  
  def email_lowercase
    email.downcase!
  end
end
