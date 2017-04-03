
module S3
  module Photos
    
    module Storage
      
      autoload :Base, 's3/photos/storage/base'
      autoload :S3, 's3/photos/storage/s3'
      autoload :Filesystem, 's3/photos/storage/filesystem'
      
      def self.new(marker: nil)
        storage = ENV['STORAGE']
        
        storage_class =
          case storage.to_sym
            when :filesystem then Filesystem
            when :s3 then S3
          end
        
        
        storage_class.new(marker: marker)
      end
      
    end
  end
end
