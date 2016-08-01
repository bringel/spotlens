class TwilioController < ApplicationController
  # skip the csrf verification because this endpoint should be hit by twilio
  skip_before_action(:verify_authenticity_token)

  def new_message

    if params['NumMedia'].to_i < 1
      render 'no_photo_sent'
    end

    @message = TwilioMessage.create({
                                     :message_sid => params['MessageSid'],
                                     :account_sid => params['AccountSid'],
                                     :messaging_service_sid => params['MessagingServiceSid'],
                                     :from => params['From'],
                                     :to => params['To'],
                                     :body => params['Body'],
                                     :num_media => params['NumMedia'].to_i,
                                     :media_content_type => params['MediaContentType'],
                                     :media_url => params['MediaUrl']
                                  })
    Rails.logger.debug(@message.to_json)
  end
end
