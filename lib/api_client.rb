require('faraday')
require('faraday_middleware')
require('simple_oauth')

class ApiClient

  # consumer_key, consumer_secret and token_secret are only used for OAuth v1
  attr_accessor(:connection, :base_url, :auth_version, :consumer_key, :consumer_secret, :token, :token_secret)

  def initialize
    @connection = Faraday.new({ :url => @base_url }) do |connection|
      configure_connection(connection)
    end
  end

  def configure_connection(connection)
    # request middleware
    connection.request(:url_encoded)
    if @auth_version == :oauth1
      conneciton.request(:oauth, { :consumer_key => @consumer_key, :consumer_secret => @consumer_secret, :token => @token, :token_secret => @token_secret })
    else
      connection.request(:oauth2, @token)
    end
    # response middleware
    connection.response(:logger)
    connection.response(:json, { :content_type => 'application/json' })
    # adapter
    connection.adapter(Faraday.default_adapter)
  end
end
