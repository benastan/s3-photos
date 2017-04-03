module S3
  module Photos
    module Storage
      
      class Filesystem < Base
        def objects(all: false)
          super do
            objects = filelist
            
            if @marker
              index = objects.map(&:key).index(@marker)
              objects = objects[index..-1]
            end
            
            objects
          end
        end
        
        def filelist
          Dir.glob(Pathname(ENV['DIRECTORY']).join('**/*')).map do |key|
            Object.new(key.gsub(ENV['DIRECTORY'], ''))
          end
        end
        
        def image_url(object, thumb: false)
          dragonfly_object = Dragonfly.app.fetch(object.key)
          dragonfly_object = dragonfly_object.thumb(THUMB_SIZE) if thumb
          dragonfly_object.url
        end
 
        def local?
          true
        end

        class Object
          attr_reader :key
  
          def initialize(key)
            @key = key
          end
        end
        
      end
    end
  end
end
