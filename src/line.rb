# reload template
require './src/Confirm'
require './src/Button'
# reload functions
require './src/line/postback'
require './src/line/join'
require './src/line/text'
require './src/line/location'
require './src/line/image'

require 'mini_magick'
require 'cloudinary'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

Cloudinary.config do |config|
  config.cloud_name = "xxx" || ENV['CLOUD_NAME']
  config.api_key    = "xxx" || ENV['CLOUDINARY_API_KEY']
  config.api_secret = "xxx" || ENV['CLOUDINARY_API_SECRET']
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each { |event|
    case event
    when Line::Bot::Event::Message
      puts event.type
      User.find_or_create_by({user_id: event["source"]["userId"]})
      if event["source"]["type"] == "group"
        group = Group.where({group_id: event["source"]["groupId"]}).first
        user  = User.where( {user_id:  event["source"]["userId"] }).first

        UserGroup.find_or_create_by({group_id: group.id, user_id: user.id})
      end
      case event.type
      when Line::Bot::Event::MessageType::Text
        replyText(event)
      when Line::Bot::Event::MessageType::Image
        replyImage(event)
      when Line::Bot::Event::MessageType::Location
        replyLocation(event)
      end
    when Line::Bot::Event::Postback
      replyPostBack(event)
    when Line::Bot::Event::Join
      replyJoin(event)
    end
  }
  "OK"
end