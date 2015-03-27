class PhotosController < ApplicationController
  def index
    @photos = Photo.order("rand()").page(params[:page]).per(50)
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def search
    render and return unless params[:url]

    blob = open(params[:url]) { |f| f.read }
    image = Magick::Image.from_blob(blob)[0]
    @average_hash = AverageHash.calc_hash(image)
  end
end
