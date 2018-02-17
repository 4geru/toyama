require 'uri'
def replyText(event)
  user_id = event["source"]["userId"]

  status = User.where({user_id: user_id}).first.status
  if status == nil
    if event.message['text'] == "追加"
      actions = [
        { "type": "uri", "label": "いいよ", "text": "", "uri": "line://nv/location/" },
        { "type": "postback", "label": "やだ", "data": "action=placeCancel" }
      ]
      User.where({user_id: user_id}).first.update({status: 'settingPlace'})
      message = Confirm.new("あんたよういく場所地図で教えてくれっけぇ", "場所情報登録中").create(actions)
      client.reply_message(event['replyToken'], message)
    elsif event.message['text'] == "聞く"
      actions = [
        { "type": "uri", "label": "いいよ", "text": "", "uri": "line://nv/location/" },
        { "type": "postback", "label": "やだ", "data": "action=placeCancel" }
      ]
      User.where({user_id: user_id}).first.update({status: 'settingPlace'})
      message = Confirm.new("あんたよういく場所地図で教えてくれっけぇ", "場所情報登録中").create(actions)
      client.reply_message(event['replyToken'], message)
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
      { "type": "postback", "label": "Yes", "data": "#{encode}" },
      { "type": "postback", "label": "No",  "data": "action=placeCancel" }
    ]
    # 文字列が長い場合の処理
    message = Confirm.new("#{event.message['text']}を登録しますか？", "場所情報確認中").create(actions)
    client.reply_message(event['replyToken'], message)
  end
end