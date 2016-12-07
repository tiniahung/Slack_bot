require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'rake'
require 'slack-ruby-client'
require 'httparty'
require 'rspotify'
# ----------------------------------------------------------------------

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)
configure :development do
  require 'dotenv'
  Dotenv.load
end




# require any models 
# you add to the folder
# using the following syntax:
require_relative './models/user'
require_relative './models/task'
#require_relative './models/playlist'

# enable sessions for this project
enable :sessions

# ----------------------------------------------------------------------
#     ROUTES, END POINTS AND ACTIONS
# ----------------------------------------------------------------------

get "/" do
  401
end

#=begin
#post "/service/:team/:user/:channel" do
#  param[:text]
#end
#=end

get "/login/:user" do 
  
  send_slack_request "Good news\n #{params[:user]} just signed into the app." 
  
  #send_slack_request "Good news\n #{params[:user]} just signed into the app.", ["https://github.com/daraghbyrne"]
  
end 


# check for token = V38x8M9GYU8BhKhE64WhidX7

# Params I'll receive
# token=V38x8M9GYU8BhKhE64WhidX7
# team_id=T0001
# team_domain=example
# channel_id=C2147483705
# channel_name=test
# user_id=U2147483697
# user_name=Steve
# command=/weather
# text=94070
# response_url=https://hooks.slack.com/commands/1234/5678

post "/handle_echo_slash_cmd/" do

  puts params.to_s

  # this should be in a .env
  slack_token = "V38x8M9GYU8BhKhE64WhidX7"

  # check it's valid
  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]
    
    formatted_message = "@#{user_name} said:\n" + text.to_s 
    
    #echo_slack_request response_url, channel_name, user_name, text
    #{text: formatted_message, response_type: "in_channel" }.to_json

    # specify the return type as 
    # json
    content_type :json
    
    # When the response_type is in_channel, both the response message and the initial message typed by the user will be shared in the channel. 

    # Setting response_type to ephemeral is the same as not including the response type at all, and the response message will be visible only to the user that issued the command. For the best clarity of intent, we recommend always declaring your intended response_type.

    {text: formatted_message, response_type: "in_channel" }.to_json
    
    
  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end

end


post "/dj_slash_cmd/" do

  puts params.to_s

  slack_token = "oBz6gSn6Uh1J6F2oV5u6yrCP"

  if slack_token == params[:token]
    
    channel_name = params[:channel_name]
    user_name = params[:user_name]
    text = params[:text]
    response_url = params[:response_url]

    
    greeting = ["Hey dude!", "Hey man!", "Hey brother!", "It's great to see you bro!"]
    
    random = Dj.all.sample(1).first
    formatted_message = greeting.sample + " Here's your new playlist!\n\n" + Rspotify(random.name).underline + "\n" + random.playlist

    content_type :json
  
    {text: formatted_message, response_type: "in_channel" }.to_json

  else
    content_type :json
    {text: "Invalid Request", response_type: "ephemeral" }.to_json

  end

end

# ----------------------------------------------------------------------
#     ERRORS
# ----------------------------------------------------------------------

error 401 do 
  "Not allowed!!!"
end

# ----------------------------------------------------------------------
#   METHODS
#   Add any custom methods below
# ----------------------------------------------------------------------

private


#"https://https://hooks.slack.com/services/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"
#payload

# You have two options for sending data to the Webhook URL above:
# Send a JSON string as the payload parameter in a POST request
# Send a JSON string as the body of a POST request
# For a simple message, your JSON payload could contain a text property at minimum. This is the text that will be posted to the channel.
# A simple example:
# payload={"text": "This is a line of text in a channel.\nAnd this is another line of text."}


# for example 
def send_slack_request message

  slack_webhook = "https://hooks.slack.com/services/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"
  
  HTTParty.post slack_webhook, body: { text: message.to_s, username: "AppBot", channel: "jukebox"}.to_json, headers: {'content-type' => 'application/json'}

  response
  
end


#def send_slack_request message, links
#
#  slack_webhook = "https://hooks.slack.com/services/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"
#  
#  formatted_message = message.to_s + "\n"
#  links.each do |link|
#    formatted_message += "<#{link.to_s}>".to_s
#  end
#  
#  HTTParty.post slack_webhook, body: {text: formatted_message.to_s, username: "AppBot", channel: "bots"}.to_json, headers: {'content-type' => 'application/json'}
#
#  response
#  
#end