//
//  RecentData.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.

import Foundation

// MARK: - RecentData
struct RecentData: Codable {
    let photos: Photos?
    let stat: String?
}

// MARK: RecentData convenience initializers and mutators
extension RecentData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RecentData.self, from: data)
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
        photos: Photos? = nil,
        stat: String? = nil
    ) -> RecentData {
        return RecentData(
            photos: photos ?? self.photos,
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
