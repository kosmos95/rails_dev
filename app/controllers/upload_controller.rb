require 'carrierwave/orm/activerecord'

class UploadController < ActionController::Base
  FILE_EXT = [".txt", ".pdf", ".doc"]
  IMAGE_EXT = [".gif", ".jpeg", ".jpg", ".png", ".svg"]

  def upload_file
    if params[:file]
      FileUtils::mkdir_p(Rails.root.join("public/uploads/files"))

      ext = File.extname(params[:file].original_filename)
      ext = file_validation(ext)
      file_name = "#{SecureRandom.urlsafe_base64}#{ext}"
      path = Rails.root.join("public/uploads/files/", file_name)

      File.open(path, "wb") {|f| f.write(params[:file].read)}
      view_file = Rails.root.join("/download_file/", file_name).to_s
      render :json => {:link => view_file}.to_json
    else
      render :text => {:link => nil}.to_json
    end
  end

  def file_validation(ext)
    raise "Not allowed" unless FILE_EXT.include?(ext)
    ext 
  end

  def upload_image
    if params[:file]
      FileUtils::mkdir_p(Rails.root.join("public/uploads/files"))
  
      #byebug 
      ext = File.extname(params[:file].original_filename)
      ext = image_validation(ext)
      file_name = "#{SecureRandom.urlsafe_base64}#{ext}"
      path = Rails.root.join("public/uploads/files/", file_name)
  
      File.open(path, "wb") {|f| f.write(params[:file].read)}
      view_file = Rails.root.join("/download_file/", file_name).to_s
      #render :json => {:link => view_file, :url => view_file}.to_json
  
      render json: { image: { url: view_file }
          }, content_type: "text/html"
    
    else
      #render :text => {:link => nil, :url => nil}.to_json
      render json: { 
          image: { url: nil } 
          }, content_type: "text/html"
    end
  end
  
  def image_validation(ext)
    raise "Not allowed" unless IMAGE_EXT.include?(ext)
    ext 
  end    

  def access_file
    if File.exists?(Rails.root.join("public", "uploads", "files", params[:name]))
      send_data File.read(Rails.root.join("public", "uploads", "files", params[:name])), :disposition => "attachment"
    else
      render :nothing => true
    end
  end

end
