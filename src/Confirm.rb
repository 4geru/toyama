class Confirm
  def initialize(text, altText = "")
    @text = text
    @altText = altText
  end

  def create(actions)
  {
    "type": "template",
    "altText": @altText,
    "template": {
        "type": "confirm",
        "text": @text,
        "actions": actions
    }
  }
  end
end