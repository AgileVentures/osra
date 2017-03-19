Paperclip::Attachment.default_options[:s3_host_name] = ENV.fetch("S3_HOST_NAME")

module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
