module ViewHelpers
  def show_me_rendered
    require 'launchy'
    filename = "tmp/view_spec_render-#{Time.now.to_i}.html"
    File.open(filename, 'w') { |file| file.write(rendered) }
    Launchy.open filename
  rescue LoadError
    warn 'You need to install launchy to open pages: `gem install launchy`'
  end
end

RSpec.configure do |c|
  c.include ViewHelpers, :type => :view
end
