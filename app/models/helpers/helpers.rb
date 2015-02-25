module Helpers

  private

  def valid_date?(date)
    Date.parse(date.to_s)
  rescue ArgumentError
    return false
  else
    return true
  end

end
