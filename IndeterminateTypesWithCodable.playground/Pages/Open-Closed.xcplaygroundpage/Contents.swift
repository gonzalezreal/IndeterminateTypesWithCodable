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

struct Attachment: Codable {
	let type: String
	let payload: Any?

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case type
		case payload
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		type = try container.decode(String.self, forKey: .type)

		if let decode = Attachment.decoders[type] {
			payload = try decode(container)
		} else {
			payload = nil
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(type, forKey: .type)

		if let payload = self.payload {
			guard let encode = Attachment.encoders[type] else {
				let context = EncodingError.Context(codingPath: [], debugDescription: "Invalid attachment: \(type).")
				throw EncodingError.invalidValue(self, context)
			}

			try encode(payload, &container)
		} else {
			try container.encodeNil(forKey: .payload)
		}
	}

	// MARK: Registration

	private typealias AttachmentDecoder = (KeyedDecodingContainer<CodingKeys>) throws -> Any
	private typealias AttachmentEncoder = (Any, inout KeyedEncodingContainer<CodingKeys>) throws -> Void

	private static var decoders: [String: AttachmentDecoder] = [:]
	private static var encoders: [String: AttachmentEncoder] = [:]

	static func register<A: Codable>(_ type: A.Type, for typeName: String) {
		decoders[typeName] = { container in
			try container.decode(A.self, forKey: .payload)
		}

		encoders[typeName] = { payload, container in
			try container.encode(payload as! A, forKey: .payload)
		}
	}
}

struct Message: Codable {
	let from: String
	let text: String
	let attachments: [Attachment]
}

Attachment.register(ImageAttachment.self, for: "image")
Attachment.register(AudioAttachment.self, for: "audio")

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
		},
		{
			"type": "pdf",
			"payload": {
				"title": "The Swift Programming Language",
				"url": "https://contoso.com/media/SwiftBook.pdf"
			}
		}
	]
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
let message = try decoder.decode(Message.self, from: json)

print("\(message.from) says: '\(message.text)'")

for attachment in message.attachments {
	switch attachment.payload {
	case let image as ImageAttachment:
		print("found 'image' at \(image.url) with size \(image.width)x\(image.height)")
	case let audio as AudioAttachment:
		print("found 'audio' titled \"\(audio.title)\"")
	default:
		print("unsupported attachment: \(attachment.type)")
	}
}
