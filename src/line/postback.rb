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
    place.update({name: data["name"]})
  elsif data["action"] == 'placeRequest'
    place = Place.find(data["placeId"])
    image = "https://res.cloudinary.com/dzhcf23xd/image/upload/v1518922536/w5zsbeq0zae9u09ydiqk.jpg"#Photo.last.url
    actions = [
      { "type": "uri", "label": "マップを見る", "text": "", "uri": "line://nv/camera/" },
      { "type": "postback", "label": "削除", "data": "action=placeDelete&placeId=#{place.id}" }
    ]
    message = Button.new("雪情報確認中", "雪情報確認中", "あんたどこのの情報聞きたいけぇ").create_image(image, actions)
    client.reply_message(event['replyToken'], message)
  elsif data["action"] == 'placeDelete'
    place = Place.find(data["placeId"])
    message = { type: 'text', text: "#{place.name}を削除したよ。" }
    client.reply_message(event['replyToken'], message)
    place.delete
  end
  user.update({status: nil})
end