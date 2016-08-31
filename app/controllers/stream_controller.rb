class StreamController < ApplicationController
  def index
  end

  def next_instagram_photo
    if params[:current] == nil
      nextPhoto = InstagramPhoto.first
    else
      id = params[:current].to_i + 1
      begin
        nextPhoto = InstagramPhoto.find(id)
      rescue ActiveRecord::RecordNotFound
        nextPhoto = InstagramPhoto.first()
      end
    end

    render({:json => nextPhoto, :status => 200})
  end

  def next_twitter_photo
    if params[:current] == nil
      nextPhoto = TwitterPhoto.first
    else
      id = params[:current].to_i + 1
      begin
        nextPhoto = TwitterPhoto.find(id)
      rescue ActiveRecord::RecordNotFound
        nextPhoto = TwitterPhoto.first()
      end
    end

    render({:json => nextPhoto, :status => 200})
  end

  def next_twilio_photo
    if params[:current] == nil
      nextPhoto = TwilioMessage.first
    else
      id = params[:current].to_i + 1
      begin
        nextPhoto = TwilioMessage.find(id)
      rescue ActiveRecord::RecordNotFound
        nextPhoto = TwilioMessage.first()
      end
    end

    render({:json => nextPhoto, :status => 200})
  end
end
