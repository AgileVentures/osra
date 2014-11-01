class Agent < ActiveRecord::Base

  validates :agent_name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: Devise.email_regexp, allow_blank: false

  has_many :sponsors
end
