# Indeterminate Types with Codable in Swift
This playground explores two different approaches to decode or encode JSON containing objects whose type is determined by a property.

```json
{
    "from": "Guille",
    "text": "Look what I just found!",
    "attachments": [
        {
            "type": "image",
            "payload": {
                "url": "http://via.placeholder.com/640x480",
                "width": 640,
                "height": 480
            }
        },
        {
            "type": "audio",
            "payload": {
                "title": "Never Gonna Give You Up",
                "url": "https://audio.com/NeverGonnaGiveYouUp.mp3",
                "shouldAutoplay": true,
            }
        }
    ]
}
```

You can find the full blog post [here](https://gonzalezreal.github.io/2018/04/30/indeterminate-types-with-codable-in-swift.html).
