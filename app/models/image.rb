class Image < ApplicationRecord

  mount_uploader :file, ImageUploader
  
  belongs_to :post, optional: true, foreign_key: 'hint'
  
  before_destroy :before_destroy 

  # def hint
    # self.post_id
  # end
  
  # def hint=(val)
    # self.post_id = val 
  # end
  
  def before_destroy
    file.remove!
    file.delete_empty_dirs 
  end
  
  def extension_white_list
    %w(png jpg jpeg gif)
  end
  
  def post_id 
    hint 
  end 

  # def get_uri
    # "#{base_dir}#{file.store_dir}/#{file.file.filename}"
  # end 
  
  # def base_dir
    # "/"
  # end 
  
end
