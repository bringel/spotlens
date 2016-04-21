require('oauth2')
require('json')
require('pg')

class AdminController < ApplicationController
  def index
    instagram_oauth_handler = OAuth2::Client.new(ENV['INSTAGRAM_CLIENT_ID'], ENV['INSTAGRAM_CLIENT_SECRET'], :site => "https://api.instagram.com")
    @instagram_oauth_code_link = instagram_oauth_handler.auth_code.authorize_url(:redirect_uri => instagram_callback_url, :scope => "public_content")

    @twitter_oauth_handler = OAuth2::Client.new(ENV['TWITTER_CLIENT_ID'], ENV['TWITTER_CLIENT_SECRET'], :site => "https://twitter.com")
    @twitter_oauth_code_link = @twitter_oauth_handler.auth_code.authorize_url(:redirect_url => twitter_callback_url)

    @instagram_users = UserAccount.where(account_type: UserAccount.account_types[:instagram])
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

  def instagram_callback_url
    "#{request.protocol}#{request.host_with_port}/admin/instagram_callback"
  end

  def twitter_callback_url
    "#{request.protocol}#{request.host_with_port}/admin/twitter_callback"
  end
end
