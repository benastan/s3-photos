require "s3/photos/version"
require "sinatra/base"
require "slim"

Aws.config[:credentials] = Aws::Credentials.new(
  ENV['AWS_ACCESS_KEY_ID'],
  ENV['AWS_SECRET_ACCESS_KEY']
)

module S3
  module Photos
    
    class Application < Sinatra::Base
      get '/' do
        slim :objects
      end
      
      helpers do
        def storage
          @storage ||= Storage.new(
            marker: params['marker']
          )
        end
      end
      
    end
  end
end
