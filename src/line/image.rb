def replyImage(event)
  response = client.get_message_content(event.message['id'])
  user = User.where({user_id: event["source"]["userId"]}).first
  image = MiniMagick::Image.read(response.body)
  imageName = SecureRandom.uuid
  image.write("/tmp/#{imageName}.jpg")
  result = Cloudinary::Uploader.upload("/tmp/#{imageName}.jpg")
  image = Photo.create({
    user_id: user.id,
    url: result['secure_url'],
  })
  if user.status == 'uploadPhoto'
    actions = [
      { "type": "uri", "label": "いいよ", "text": "", "uri": "line://nv/location/" },
      { "type": "postback", "label": "やだ", "data": "action=placeCancel" }
    ]
    user.update({status: 'uploadPhoto'})
    message = Confirm.new("あんたを場所地図で教えてくれっけぇ", "場所情報登録中").create(actions)
    client.reply_message(event['replyToken'], message)
  else
    user.update({status: nil})
  end
end