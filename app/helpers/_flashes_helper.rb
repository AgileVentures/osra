module FlashesHelper

  ACCEPTED_FLASH_HTML_CLASSES = {
    success: 'alert alert-success',
    error: 'alert alert-danger'
  }  

  def flash_htmlclass_for type
    ACCEPTED_FLASH_HTML_CLASSES[type.to_sym] || nil
  end

  def each_accepted_flash
    flash.each do |fl|
      yield fl if flash_htmlclass_for fl[0]
    end
  end

  def any_accepted_flash?
    flash.any? {|k,_| flash_htmlclass_for k }
  end

end
