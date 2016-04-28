class StreamController < ApplicationController
  def index
  end

  def next_instagram_photo
    respond_to(:json)

    if params[:current].empty?
      nextPhoto = InstagramPhoto.first
    else
      id = params[:current].to_i + 1
      nextPhoto = InstagramPhoto.find(id)
    end

    render({:json => nextPhoto})
  end

  def next_twitter_photo
    respond_to(:json)
  end
end
