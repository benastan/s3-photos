require 'dotenv'
Dotenv.load

require "aws-sdk"
require "s3/photos/version"

module S3
  module Photos
    autoload :Application, 's3/photos/application'
    autoload :Storage, 's3/photos/storage'
  end
end
