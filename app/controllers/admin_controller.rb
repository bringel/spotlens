require('oauth2')
require('json')
require('pg')
require('base64')
require('httparty')
require('faraday')
require('faraday_middleware')
require('simple_oauth')

class AdminController < ApplicationController
  def index
    instagram_oauth_handler = OAuth2::Client.new(ENV['INSTAGRAM_CLIENT_ID'], ENV['INSTAGRAM_CLIENT_SECRET'], :site => "https://api.instagram.com")
    @instagram_oauth_code_link = instagram_oauth_handler.auth_code.authorize_url(:redirect_uri => instagram_callback_url(), :scope => "public_content")


    @instagram_users = UserAccount.where(account_type: UserAccount.account_types[:instagram])
    @twitter_users = UserAccount.where(account_type: UserAccount.account_types[:twitter])
    @hashtags = JSON.parse(ENV['hashtags'])
  end

  def instagram_callback
    instagram_oauth_handler = OAuth2::Client.new(ENV['INSTAGRAM_CLIENT_ID'], ENV['INSTAGRAM_CLIENT_SECRET'], :site => "https://api.instagram.com", :token_url => "/oauth/access_token")

    token = instagram_oauth_handler.auth_code.get_token(params[:code], :redirect_uri => instagram_callback_url)

    user = token["user"] # oauth2 stores the rest of the response in the @params variable, which can be accessed w/ []

    UserAccount.create(account_type: UserAccount.account_types[:instagram], username: user["username"], fullname: user["full_name"], profile_picture_url: user["profile_picture"], auth_token: token.token)

    redirect_to(:action => "index")
  end

  def twitter_callback
    connection = Faraday.new({ :url => 'https://api.twitter.com'}) do |faraday|
      faraday.request(:oauth, { :consumer_key => ENV['TWITTER_CLIENT_KEY'], :consumer_secret => ENV['TWITTER_CLIENT_SECRET'], :token => params['oauth_token'] })
      faraday.request(:url_encoded)
      faraday.response(:logger)
      faraday.adapter(Faraday.default_adapter)
    end

    response = connection.post('oauth/access_token', { :oauth_verifier => params['oauth_verifier'] })

    oauth_body = Hash[ URI.decode_www_form(response.body)]

    authenticated_connection = Faraday.new({ :url => 'https://api.twitter.com'}) do |faraday|
      faraday.request(:oauth, { :consumer_key => ENV['TWITTER_CLIENT_KEY'], :consumer_secret => ENV['TWITTER_CLIENT_SECRET'], :token => oauth_body['oauth_token'], :token_secret => oauth_body['oauth_token_secret'] })
      faraday.request(:url_encoded)
      faraday.response(:logger)
      faraday.response(:json, { :content_type => 'application/json' })
      faraday.adapter(Faraday.default_adapter)
    end
    user_response = authenticated_connection.get("1.1/users/show.json?user_id=#{oauth_body['user_id']}")

    UserAccount.create(account_type: UserAccount.account_types[:twitter], username: oauth_body['screen_name'], fullname: user_response.body['name'], profile_picture_url: user_response.body['profile_image_url'], auth_token: oauth_body['oauth_token'], token_secret: oauth_body['oauth_token_secret'])

    redirect_to(:action => "index")
  end

  def login_with_twitter
    connection = Faraday.new({ :url => 'https://api.twitter.com'}) do |faraday|
      faraday.request(:oauth, { :consumer_key => ENV['TWITTER_CLIENT_KEY'], :consumer_secret => ENV['TWITTER_CLIENT_SECRET']})
      faraday.response(:logger)
      faraday.adapter(Faraday.default_adapter)
    end

    response = connection.post("/oauth/request_token?oauth_callback=#{twitter_callback_url()}")

    body = Hash[URI.decode_www_form(response.body)]

    redirect_to("https://api.twitter.com/oauth/authorize?oauth_token=#{body['oauth_token']}")
  end

  def save_settings
    newFetch = (params["fetchRefresh"].to_i * 60).to_s
    newSwitch = params["switchRefresh"].to_s
    newHashtags = params["hashtags"].reject { |tag| tag.empty? }
    newHashtags = JSON.generate(newHashtags)

    ENV['photo_fetch_timer'] = newFetch
    ENV['photo_switch_timer'] = newSwitch
    ENV['hashtags'] = newHashtags

    app_settings = ApplicationSetting.first
    app_settings.update({ :photo_fetch_timer => newFetch, :photo_switch_timer => newSwitch, :hashtags => newHashtags })
    
    flash[:notice] = "Settings saved"
    redirect_to(:action => "index")
  end

  def remove_account
    # TODO: this should really redirect and refresh the page, but it doesn't. Maybe use a link instead of an xhr
    account_index = params[:account_index].to_i
    account_type = params[:account_type].to_i

    accounts = UserAccount.where(:account_type => account_type).order(:id)
    accounts[account_index].destroy

    redirect_to(:action => "index", '_' => "cachebustingtime")
  end

  def instagram_callback_url
    "#{request.protocol}#{request.host_with_port}/admin/instagram_callback"
  end

  def twitter_callback_url
    "#{request.protocol}#{request.host_with_port}/admin/twitter_callback"
  end
end
