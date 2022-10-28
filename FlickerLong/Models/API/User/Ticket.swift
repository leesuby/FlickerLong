//
//  Ticker.swift
//  FlickerLong
//
//  Created by LAP15335 on 28/10/2022.
//

import Foundation
// MARK: - Ticket
struct Ticket: Codable {
    let id: String?
    let complete: Int?
    let photoid, imported: String?
}

// MARK: Ticket convenience initializers and mutators

extension Ticket {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Ticket.self, from: data)
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
        id: String?? = nil,
        complete: Int?? = nil,
        photoid: String?? = nil,
        imported: String?? = nil
    ) -> Ticket {
        return Ticket(
            id: id ?? self.id,
            complete: complete ?? self.complete,
            photoid: photoid ?? self.photoid,
            imported: imported ?? self.imported
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
