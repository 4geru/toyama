class Button
  def initialize(title, altText, text)
    @title = title
    @altText = altText
    @text = text
  end

  def create(action)
    {
      "type": "template",
      "altText": @altText,
      "template": {
          "type": "buttons",
          "title": @title,
          "text": @text,
          "actions": action
      }
    }
  end

  def create_image(image, action)
    {
      "type": "template",
      "altText": @altText,
      "template": {
          "type": "buttons",
          "thumbnailImageUrl": image,
          "title": @title,
          "text": @text,
          "actions": action
      }
    }
  end
end