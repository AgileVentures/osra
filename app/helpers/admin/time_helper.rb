module Admin::TimeHelper

  def format_date(date)
    date.try :strftime, ApplicationHelper::FULL_DATE_FORMAT_STRING
  end

  def format_short_date(date)
    date.try :strftime, ApplicationHelper::MONTH_YEAR_DATE_FORMAT_STRING
  end

end
