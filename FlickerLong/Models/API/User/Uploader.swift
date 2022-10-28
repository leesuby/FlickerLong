//
//  Uploader.swift
//  FlickerLong
//
//  Created by LAP15335 on 28/10/2022.
//

import Foundation
// MARK: - Uploader
struct Uploader: Codable {
    let ticket: [Ticket]?
}

// MARK: Uploader convenience initializers and mutators

extension Uploader {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Uploader.self, from: data)
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
        ticket: [Ticket]?? = nil
    ) -> Uploader {
        return Uploader(
            ticket: ticket ?? self.ticket
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
