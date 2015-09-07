class ActorsController < ApplicationController
  def show
    @actor = Actor.find_by(name: params[:name])
    @photos = @actor.photos
    render "photos/index"
  end
end

