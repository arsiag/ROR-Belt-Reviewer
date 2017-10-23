class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :state
  has_many :joins, dependent: :destroy
  has_many :joined_users, through: :joins, source: :user
  has_many :comments, dependent: :destroy
  validates :name,:location, presence:true, length:{minimum:2}
  validates :state, presence:true
  validates :user, presence:true
  # validates_date :event_date, :after => lambda { Date.current }
  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    errors.add(:event_date, "can't be in the past") if !event_date.blank? and event_date < Date.today
  end

end
