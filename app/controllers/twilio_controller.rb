class TwilioController < ApplicationController
  # skip the csrf verification because this endpoint should be hit by twilio
  skip_before_action(:verify_authenticity_token)

  def new_message

    if params['NumMedia'].to_i < 1
      render 'no_photo_sent'
    end

    num_media = params['NumMedia']
    num_media.times do |index|
      @message = TwilioMessage.create({
        :message_sid => params['MessageSid'],
        :account_sid => params['AccountSid'],
        :messaging_service_sid => params['MessagingServiceSid'],
        :from => params['From'],
        :to => params['To'],
        :body => params['Body'],
        :num_media => params['NumMedia'].to_i,
        :media_content_type => params['MediaContentType'],
        :media_url => params['MediaUrl#{index}']
        })
      end
  end
end

#{"id":3,"message_sid":"MMf372ca9840afc3241b6b6926cfce3b59","account_sid":"AC3c4eccde828c8c1d17f7f55bd817bd90","messaging_service_sid":null,"from":"+12162808787","to":"+12164506441","body":"","num_media":1,"media_content_type":null,"media_url":null,"created_at":"2016-08-31T01:13:47.360Z","updated_at":"2016-08-31T01:13:47.360Z"}
