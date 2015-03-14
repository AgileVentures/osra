class User < ActiveRecord::Base
  self.per_page = 10

  validates :user_name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: Devise.email_regexp, allow_blank: false

  has_many :sponsors, :foreign_key => 'agent_id'

  def active_sponsors
    sponsors.all_active
  end

  def inactive_sponsors
    sponsors.all_inactive
  end
end
