require "s3/photos/version"
require "sinatra/base"
require "slim"
require "aws-sdk"

Aws.config[:credentials] = Aws::Credentials.new(
  ENV['AWS_ACCESS_KEY_ID'],
  ENV['AWS_SECRET_ACCESS_KEY']
)

module S3
  module Photos
    class Application < Sinatra::Base
      get '/' do
        s3 = Aws::S3::Resource.new
        @bucket = s3.bucket(ENV['AWS_BUCKET'])
        
        slim :objects
      end
    end
  end
end
