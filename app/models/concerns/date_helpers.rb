module DateHelpers

  private

  def valid_date?(date)
     return true if Date.parse(date.to_s)
   rescue ArgumentError
     return false
  end

end



