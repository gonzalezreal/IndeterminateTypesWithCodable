# Indeterminate Types with Codable in Swift
This playground explore two different approaches to decode or encode JSON containing objects whose type is determined by a property.

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

You can find the full blog post [here](https://medium.com/@gonzalezreal/indeterminate-types-with-codable-in-swift-5a1af0aa9f3d).