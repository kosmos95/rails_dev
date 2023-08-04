class TinymceAssetsController < ApplicationController
  
  def create
    # Take upload from params[:file] and store it somehow...
    # Optionally also accept params[:hint] and consume if needed
    image = Image.create! params.permit(:file, :alt, :hint)
    # geometry = Paperclip::Geometry.from_file params[:file]
    # height: geometry.height.to_i,
    # width:  geometry.width.to_i
    
    #logger.error image.errors.to_s if image.errors 

    render json: {
      image: {
        id: image.id, 
        url: image.file.url
      }
    }, content_type: "text/html"
  end
  
end
