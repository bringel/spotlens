require('oauth2')
require('json')
require('pg')
require('base64')
require('httparty')

class AdminController < ApplicationController
  def index
    instagram_oauth_handler = OAuth2::Client.new(ENV['INSTAGRAM_CLIENT_ID'], ENV['INSTAGRAM_CLIENT_SECRET'], :site => "https://api.instagram.com")
    @instagram_oauth_code_link = instagram_oauth_handler.auth_code.authorize_url(:redirect_uri => instagram_callback_url, :scope => "public_content")


    @instagram_users = UserAccount.where(account_type: UserAccount.account_types[:instagram])
    @twitter_auth = UserAccount.where(account_type: UserAccount.account_types[:twitter]).first
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
    credentials = "#{ENV['TWITTER_CLIENT_KEY']}:#{ENV['TWITTER_CLIENT_SECRET']}"
    auth_header_value = "Basic #{Base64.strict_encode64(credentials)}"

    token_response = HTTParty.post("https://api.twitter.com/oauth2/token", {:headers => {"Authorization" => auth_header_value, "Content-Type" => "application/x-www-form-urlencoded;charset=UTF-8"}, :body => "grant_type=client_credentials"})

    parsed_response = JSON.parse(token_response.body)

    if parsed_response["token_type"] == "bearer"
      UserAccount.create(account_type: UserAccount.account_types[:twitter], auth_token: parsed_response["access_token"])
    end
    redirect_to(:action => "index")
  end

  def save_settings
    newFetch = (params["fetchRefresh"].to_i * 60).to_s
    newSwitch = params["switchRefresh"].to_s
    newHashtags = params["hashtags"].reject { |tag| tag.empty? }
    newHashtags = JSON.generate(newHashtags)

    ENV['photo_fetch_timer'] = newFetch
    ENV['photo_switch_timer'] = newSwitch
    ENV['hashtags'] = newHashtags

    connection = PG.connect(ENV['DATABASE_URL'])
    connection.exec("UPDATE settings SET value = '#{newFetch}' WHERE key = 'photo_fetch_timer';")
    connection.exec("UPDATE settings SET value = '#{newSwitch}' WHERE key = 'photo_switch_timer';")
    connection.exec("UPDATE settings SET value = '#{newHashtags}' WHERE key = 'hashtags';")
    flash[:notice] = "Settings saved"
    redirect_to(:action => "index")
  end

  def remove_instagram_account
    account_index = params[:account_index]

    instagram_accounts = UserAccount.where(:account_type => UserAccount.account_types[:instagram]).order(:id)
    instagram_accounts[account_index].destroy

    redirect_to(:action => "index")
  end

  def instagram_callback_url
    "#{request.protocol}#{request.host_with_port}/admin/instagram_callback"
  end

end
