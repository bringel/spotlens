class TwilioController < ApplicationController
  # skip the csrf verification because this endpoint should be hit by twilio
  skip_before_action(:verify_authenticity_token)

  def new_message
    body = JSON.decode(request.body)

    if body['NumMedia'] < 1
      render 'no_photo_sent'
    end

    @message = TwilioMessage.create({
                                     :message_sid => body['MessageSid'],
                                     :account_sid => body['AccountSid'],
                                     :messaging_service_sid => body['MessagingServiceSid'],
                                     :from => body['From'],
                                     :to => body['To'],
                                     :body => body['Body'],
                                     :num_media => body['NumMedia'],
                                     :media_content_type => body['MediaContentType'],
                                     :media_url => body['MediaUrl']
                                  })
    Rails.logger.debug(@message.to_json)
  end
end
