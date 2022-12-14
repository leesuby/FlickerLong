//
//  Album.swift
//  FlickerLong
//
//  Created by LAP15335 on 26/10/2022.
//

import Foundation
// MARK: - GalleryData
struct GalleryData: Codable {
    let galleries: Galleries?
    let stat: String?
}

extension GalleryData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GalleryData.self, from: data)
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
        galleries: Galleries?? = nil,
        stat: String?? = nil
    ) -> GalleryData {
        return GalleryData(
            galleries: galleries ?? self.galleries,
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
