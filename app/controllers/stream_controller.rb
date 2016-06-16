class StreamController < ApplicationController
  def index
  end

  def next_instagram_photo
    if params[:current] == nil
      nextPhoto = InstagramPhoto.first
    else
      id = params[:current].to_i + 1
      nextPhoto = InstagramPhoto.find(id)
    end

    render({:json => nextPhoto})
  end

  def next_twitter_photo
    if params[:current] == nil
      nextPhoto = TwitterPhoto.first
    else
      id = params[:current].to_i + 1
      nextPhoto = TwitterPhoto.find(id)
    end

    render({:json => nextPhoto})
  end
end
