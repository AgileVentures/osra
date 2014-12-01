ActiveAdmin.register_page "Dashboard" do

  IMAGE_SCALING = 0.38

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content do
    div class: "blank_slate_container" do
      height= (865 * IMAGE_SCALING).to_i.to_s
      width= (960 * IMAGE_SCALING).to_i.to_s
      image= '<img src="/osra_logo.jpg" height="' + height + '" width="' + width + '" alt="Welcome to OSRA" />'
      text_node image.html_safe
    end
  end
end
