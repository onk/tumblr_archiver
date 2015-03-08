class PhotosController < ApplicationController
  def index
    @photos = Photo.order("rand()").page(params[:page]).per(50)
  end

  def show
    @photo = Photo.find(params[:id])
  end
end
