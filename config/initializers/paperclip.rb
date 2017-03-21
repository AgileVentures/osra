# frozen_string_literal: true

Paperclip::Attachment.default_options[:url] = ":s3_domain_url"
if Rails.env == "production"
  Paperclip::Attachment.default_options[:path] =
    "/:class/:attachment/:id_partition/:style/:filename"
else
  Paperclip::Attachment.default_options[:path] =
    ":rails_root/public/system/:class/:attachment/:id_partition/:style/:filename"
end

module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
