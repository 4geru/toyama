require 'uri'
def replyText(event)
  user_id = event["source"]["userId"]

  status = User.where({user_id: user_id}).first.status
  if status == nil
    if event.message['text'] == "追加"
      actions = [
        { "type": "uri", "label": "Yes", "text": "追加します", "uri": "line://nv/location/" },
        { "type": "message", "label": "No", "text": "追加しません" }
      ]
      User.where({user_id: user_id}).first.update({status: 'settingPlace'})
      message = Confirm.new("場所情報を登録するのじゃ", "場所情報登録中").create(actions)
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