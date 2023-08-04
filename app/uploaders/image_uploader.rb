class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
 
  storage :file

  version :thumb200 do
    process resize_to_fill: [200, 200]  
    process convert: 'jpg'
  end 
    
  def store_dir
    #dir = Time.now.strftime("%Y/%m/%d")
    t = model.created_at
    dir = sprintf("%04d/%02d/%02d", t.year, t.month, t.day)
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{dir}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def content_type_whitelist
    /image\//
  end

  def delete_empty_dirs
    path = File.expand_path(store_dir, root)
    Dir.rmdir(path)
  rescue
    true
  end

  def size_range
    0..5.megabytes
  end

end
