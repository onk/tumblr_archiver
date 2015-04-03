class PhotosController < ApplicationController
  before_action :find_photo, only: [:show, :update]

  def index
    @photos = Photo.order("rand()").page(params[:page]).per(50)
  end

  def show
    @photo.actor ||= Actor.new
  end

  def search
    render and return unless params[:url]

    blob = open(params[:url]) { |f| f.read }
    image = Magick::Image.from_blob(blob)[0]
    @average_hash = AverageHash.calc_hash(image)
  end

  def update
    @photo.save_with_actor(params[:photo])
    redirect_to photo_path(@photo)
  end

  private

  def find_photo
    @photo = Photo.find(params[:id])
  end
end
