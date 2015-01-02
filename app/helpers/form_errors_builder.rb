class FormErrorsBuilder < ActionView::Helpers::FormBuilder
  def error_messages
    return unless object.respond_to?(:errors) && object.errors.any?

    @template.content_tag :div, class: "panel panel-danger" do
      error_header << error_panel
    end
  end

private
  def list_of_errors
    @template.content_tag(:ul, class: "bg-danger") do
      object.errors.full_messages.map { |message|
        @template.content_tag(:li, message) }.join("\n").html_safe
    end
  end

  def error_header
    @template.content_tag :div, class: "panel-heading" do
      @template.content_tag(:h3,
        "Please fix the errors below and resubmit the form.",
        class: "panel-title")
    end
  end

  def error_panel
      @template.content_tag(:div, list_of_errors, class: "panel-body")
  end
end
