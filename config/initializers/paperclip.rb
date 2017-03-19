Paperclip::Attachment.default_options[:s3_host_name] = ENV["S3_HOST_NAME"] || "s3.amazonaws.com"

module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
