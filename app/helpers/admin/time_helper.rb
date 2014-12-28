module Admin::TimeHelper

  def format_date(date)
    date.strftime("%-d/%-m/%Y")
  end

end
