module FormHelper
  def bool_to_int bool
    bool ? 1 : 0
  end

  def cancel_button_link record
    record.new_record? ? hq_sponsors_path : hq_sponsor_path(record.id)
  end

end
