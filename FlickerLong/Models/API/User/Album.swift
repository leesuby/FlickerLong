//
//  File.swift
//  FlickerLong
//
//  Created by LAP15335 on 28/10/2022.
//

import Foundation
// MARK: - Album
struct Album: Codable {
    let photosets: Photosets?
    let stat: String?
}

// MARK: Album convenience initializers and mutators

extension Album {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Album.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        photosets: Photosets?? = nil,
        stat: String?? = nil
    ) -> Album {
        return Album(
            photosets: photosets ?? self.photosets,
            stat: stat ?? self.stat
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
