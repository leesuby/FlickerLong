//
//  Photos.swift
//  FlickerLong
//
//  Created by LAP15335 on 20/10/2022.
//

import Foundation
// MARK: - Photos
struct Photoss: Codable {
    let count: Count
}

// MARK: Photos convenience initializers and mutators

extension Photoss {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Photoss.self, from: data)
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
        count: Count? = nil
    ) -> Photoss {
        return Photoss(
            count: count ?? self.count
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
