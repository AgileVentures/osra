class Agent < ActiveRecord::Base

  validates :first_name, presence: true, uniqueness: { case_sensitive: false }
  validates :last_name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: Devise.email_regexp, allow_blank: false

  has_many :sponsors

  def full_name
    "#{first_name} #{last_name}"
  end
end
