def replyLocation(event)
  user_id = event["source"]["userId"]
  puts event.message['address']

  user = User.where({user_id: user_id}).first
  status = user.status
  puts status
  if status == 'settingPlace'
    Place.create({latitude: event.message['latitude'], longitude: event.message['longitude'], user_id: user.id})
    message = { type: 'text', text: '名前は何にする？' }
    client.reply_message(event['replyToken'], [questionSticky, message])
  elsif status == 'uploadPhoto'
    photo = user.photos.last
    photo.update({latitude: event.message['latitude'], longitude: event.message['longitude']})
    message = { type: 'text', text: '登録したよー' }

    client.reply_message(event['replyToken'], [okSticky, message])
    user.update({status: nil})
  elsif status == 'placeRequest'

    photo = Photo.all.min_by{|photo|
      get_distance([event.message['latitude'], event.message['longitude']], [photo[:latitude], photo[:longitude]])
    }
    image = photo.url
    actions = [
      { "type": "uri", "label": "マップを見る", "text": "", "uri": "https://secreto-tokyo.com/yukibot/yukimap.html?lat=#{event.message['latitude']}&lng=#{event.message['longitude']}" },
    ]
    message = Button.new("地図検索結果", "地図検索結果表示中", "指定した場所付近の情報じゃ").create_image(image, actions)
    client.reply_message(event['replyToken'], message)
  end
end