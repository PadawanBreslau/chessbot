require 'sinatra'
require 'json'

post '/gateway' do
  message = params[:text]
  respond_message message
end

def respond_message message
  content_type :json
  {:text => message}.to_json
end

