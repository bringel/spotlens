class TwilioController < ApplicationController
  def new_message
    body = JSON.decode(request.body)

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
