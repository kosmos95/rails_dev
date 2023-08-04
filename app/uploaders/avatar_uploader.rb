class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  #include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  #def cache_dir
  #  Rails.root.join('/tmp/cache').to_s
  #end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  #version :thumb do
  #  process resize: "200x200"
  #end
  
  #version :thumb do
  #  process resize_to_fit: [200, 200]
  #end  

  process resize_to_fit: [200, 200]
  process convert: 'jpg'

  version :thumb do
    process resize_to_fill: [100, 100]  
    process convert: 'jpg'
  end 
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
  
  def content_type_whitelist
    /image\//
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  #def filename
  #  "avatar_#{model.id}.jpg" if original_filename
  #end
  
  def filename
    super.chomp(File.extname(super)) + '.jpg' if original_filename.present?
  end
  
  def delete_empty_dirs
    path = File.expand_path(store_dir, root)
    Dir.rmdir(path)
  rescue
    true
  end
  
  def size_range
    0..2.megabytes
  end
  
end
