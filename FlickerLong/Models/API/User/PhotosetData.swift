//
//  PhotosetData.swift
//  FlickerLong
//
//  Created by LAP15335 on 28/10/2022.
//

import Foundation
// MARK: - PhotosetData
struct PhotosetData: Codable {
    let photoset: ListPhotosAlbum?
    let stat: String?
}

// MARK: PhotosetData convenience initializers and mutators

extension PhotosetData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PhotosetData.self, from: data)
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
        photoset: ListPhotosAlbum?? = nil,
        stat: String?? = nil
    ) -> PhotosetData {
        return PhotosetData(
            photoset: photoset ?? self.photoset,
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
