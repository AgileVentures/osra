module Hq::TimeHelper
  def self.date_to_string(date)
    date.strftime('%d %B %Y') if date.is_a?(Date)
  end
end
