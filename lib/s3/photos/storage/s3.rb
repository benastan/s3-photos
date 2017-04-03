module S3
  module Photos
    module Storage
      
      class S3 < Base
        
        def objects(all: false)
          super do
            options = {}
            options[:marker] = @marker if @marker
            bucket.objects(options)
          end
        end
        
        def bucket
          @bucket ||= (
          s3 = Aws::S3::Resource.new
          s3.bucket(ENV['AWS_BUCKET'])
          )
        end

        def image_url(object, thumb: false)
          domain = ENV.fetch('CLOUDFRONT_HOST', '')
          url = object.presigned_url(:get, expires_in: 3600)
          object = Dragonfly.app.fetch_url(url)
          object = object.thumb(THUMB_SIZE) if thumb
          "#{domain}#{object.url}"
        end

        def local?
          false
        end
      end
    
    end
  end
end
