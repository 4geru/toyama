def replyPostBack(event)
  data = Hash[URI::decode_www_form(event["postback"]["data"])]
  user = User.where({user_id: event["source"]["userId"]}).first
  puts data
  if data["action"] == 'placeCancel'
    message = { type: 'text', text: 'キャンセルしました。' }
    client.reply_message(event['replyToken'], message)
  elsif data["action"] == 'placeAccept'
    message = { type: 'text', text: "#{data["name"]}を追加しました。" }
    client.reply_message(event['replyToken'], message)
    place = user.places.last
    puts ">> place"
    puts place
    place.update({name: data["name"]})
  end
  user.update({status: nil})
end