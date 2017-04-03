module S3
  module Photos
    module Storage
      
      THUMB_SIZE = '400x400'
      
      class Base
        def initialize(marker: nil)
          @marker = marker
        end
        
        def objects(all: false)
          return @objects if @objects && !all
          objects = only_jpegs(yield)
          return objects if all
          @objects ||= objects.first(20)
        end
        
        def only_jpegs(collection)
          collection.
            select { |item| item.key =~ /\.JPG$/i }
        end
        
      end
    end
  end
end
