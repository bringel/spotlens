class StreamController < ApplicationController
  def index
  end

  def next_instagram_photo
    respond_to(:json)
  end

  def next_twitter_photo
    respond_to(:json)
  end
end
