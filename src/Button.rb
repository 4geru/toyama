class Button

  def create(action)
    {
      "type": "template",
      "altText": "This is a buttons template",
      "template": {
          "type": "buttons",
          "thumbnailImageUrl": "https://example.com/bot/images/image.jpg",
          "imageAspectRatio": "rectangle",
          "imageSize": "cover",
          "imageBackgroundColor": "#FFFFFF",
          "title": "Menu",
          "text": "Please select",
          "defaultAction": {
              "type": "uri",
              "label": "View detail",
              "uri": "http://example.com/page/123"
          },
          "actions": action
      }
    }
  end
end