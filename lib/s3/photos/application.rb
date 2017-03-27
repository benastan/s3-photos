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
        slim :objects
      end
      
      helpers do
        def filesystem?
          ENV.key?('FILESYSTEM')
        end
        
        def objects(all = false)
          @bucket ||= (
            s3 = Aws::S3::Resource.new
            @bucket = s3.bucket(ENV['AWS_BUCKET'])
          )
          
          return @bucket.objects.select { |item| item.key =~ /\.JPG$/ } if all
          
          @objects ||= (
            options = {}
            options[:marker] = params[:marker] if params.key?(:marker)
            
            @bucket.objects(options).
              select { |item| item.key =~ /\.JPG$/ }.
              first(20)
          )
        end
        
        def image_url(object)
          url = object.presigned_url(:get, expires_in: 3600)
          Dragonfly.app.fetch_url(url).thumb('200x200').url
        end
      end
      
    end
  end
end
