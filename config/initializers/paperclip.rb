Paperclip::Attachment.default_options[:url] = ":s3_domain_url"
Paperclip::Attachment.default_options[:path] = ":rails_root/public/system/:class/:attachment/:id_partition/:style/:filename"

module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
