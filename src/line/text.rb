require 'uri'
def replyText(event)
  user = User.where({user_id: event["source"]["userId"]}).first
  status = User.where({user_id: event["source"]["userId"]}).first.status
  if status == nil
    if event.message['text'] == "場所を登録したい"
      actions = [
        { "type": "uri", "label": "いいよ", "text": "", "uri": "line://nv/location/" },
        { "type": "postback", "label": "やだ", "data": "action=placeCancel" }
      ]
      user.update({status: 'settingPlace'})
      message = Confirm.new("あんたよういく場所地図で教えてくれっけぇ", "場所情報登録中").create(actions)
      client.reply_message(event['replyToken'], [okSticky, message])
    elsif event.message['text'] == "写真あげたい"
      actions = [
        { "type": "uri", "label": "いいよ", "text": "", "uri": "line://nv/camera/" },
        { "type": "postback", "label": "やだ", "data": "action=placeCancel" }
      ]
      message = Confirm.new("あんたカメラの情報教えてくれっけぇ", "写真アップロード確認中").create(actions)
      client.reply_message(event['replyToken'], [photoSticky, message] )
    elsif event.message['text'] == "雪の情報を見たい"
      actions = user.places.map{|place|
        { "type": "postback", "label": "#{place.name}", "data": "action=placeRequest&placeId=#{place.id}" }
      }[0...3]
      if actions.empty?
        message = { type: 'text', text: "場所の登録しとらんとね？" }
        client.reply_message(event['replyToken'], message)
      else
        user.update({status: 'placeRequest'})
        image = Photo.all.shuffle.first.url
        text = "あんたどこのの情報聞きたいけぇ" + (actions.length == 3 ? "\nお気に入りが3件以上だからシャッフルするね" : "")
        actions << { "type": "uri", "label": "地図から検索する", "uri": "line://nv/location/" }
        message = Button.new("雪情報確認中", "雪情報確認中", text ).create_image(image, actions)
        client.reply_message(event['replyToken'], message)
      end
    else
      message = {
        type: 'text',
        text: event.message['text']
      }
      client.reply_message(event['replyToken'], message)
    end
  elsif status == 'settingPlace'
    encode = URI::encode_www_form({action: 'placeAccept', name: event.message['text']})
    actions = [
      { "type": "postback", "label": "する", "data": "#{encode}" },
      { "type": "postback", "label": "しない",  "data": "action=placeCancel" }
    ]
    # 文字列が長い場合の処理
    message = Confirm.new("#{event.message['text']}を登録する？", "場所情報確認中").create(actions)
    client.reply_message(event['replyToken'], message)
  else
    user.update({status: nil})
  end
end