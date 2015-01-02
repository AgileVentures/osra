module FlashesHelper
  
  def flash_htmlclass_for type
    case type.to_sym 
      when :success 
        'alert alert-success'
      when :error
        'alert alert-danger'
    end
  end

end
