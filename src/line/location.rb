def replyLocation(event)
  user_id = event["source"]["userId"]
  puts event.message['address']

  user = User.where({user_id: user_id}).first
  status = user.status
  puts status
  if status == 'settingPlace'
    Place.create({latitude: event.message['latitude'], longitude: event.message['longitude'], user_id: user.id})
    message = { type: 'text', text: '名前は何にしますか？' }
    client.reply_message(event['replyToken'], message)
  elsif status == 'uploadPhoto'
    photo = user.photos.last
    photo.update({latitude: event.message['latitude'], longitude: event.message['longitude']})
    message = { type: 'text', text: '登録しました。' }
    client.reply_message(event['replyToken'], message)
    user.update({status: nil})
  end
end