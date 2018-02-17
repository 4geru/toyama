class Button
  def initialize(text, altText)
    @text = text
    @altText = altText
  end

  def create(action)
    {
      "type": "template",
      "altText": @altText,
      "template": {
          "type": "buttons",
          "title": @text,
          "text": "Please select",
          "actions": action
      }
    }
  end
end