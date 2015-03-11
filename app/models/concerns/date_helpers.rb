module DateHelpers

  private

  def valid_date?(date)
     Date.parse(date.to_s) and return true
   rescue ArgumentError
     return false
  end

end



