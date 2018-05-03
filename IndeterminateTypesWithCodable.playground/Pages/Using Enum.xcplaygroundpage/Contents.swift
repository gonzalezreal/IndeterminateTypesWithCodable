import Foundation

struct ImageAttachment: Codable {
	let url: URL
	let width: Int
	let height: Int
}

struct AudioAttachment: Codable {
	let title: String
	let url: URL
	let shouldAutoplay: Bool
}

enum Attachment {
	case image(ImageAttachment)
	case audio(AudioAttachment)
	case unsupported
}

extension Attachment: Codable {
	private enum CodingKeys: String, CodingKey {
		case type
		case payload
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let type = try container.decode(String.self, forKey: .type)

		switch type {
		case "image":
			let payload = try container.decode(ImageAttachment.self, forKey: .payload)
			self = .image(payload)
		case "audio":
			let payload = try container.decode(AudioAttachment.self, forKey: .payload)
			self = .audio(payload)
		default:
			self = .unsupported
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		switch self {
		case .image(let attachment):
			try container.encode("image", forKey: .type)
			try container.encode(attachment, forKey: .payload)
		case .audio(let attachment):
			try container.encode("audio", forKey: .type)
			try container.encode(attachment, forKey: .payload)
		case .unsupported:
			let context = EncodingError.Context(codingPath: [], debugDescription: "Invalid attachment.")
			throw EncodingError.invalidValue(self, context)
		}
	}
}

struct Message: Codable {
	let from: String
	let text: String
	let attachments: [Attachment]
}

let json = """
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
				"url": "https://contoso.com/media/NeverGonnaGiveYouUp.mp3",
				"shouldAutoplay": true,
			}
		}
	]
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
let message = try decoder.decode(Message.self, from: json)

print("\(message.from) says: '\(message.text)'")

for attachment in message.attachments {
	switch attachment {
	case .image(let image):
		print("found 'image' at \(image.url) with size \(image.width)x\(image.height)")
	case .audio(let audio):
		print("found 'audio' titled \"\(audio.title)\"")
	case .unsupported:
		print("unsupported")
	}
}
