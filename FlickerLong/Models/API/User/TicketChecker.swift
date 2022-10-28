//
//  TicketChecker.swift
//  FlickerLong
//
//  Created by LAP15335 on 28/10/2022.
//

import Foundation
// MARK: - TicketChecker
struct TicketChecker: Codable {
    let uploader: Uploader?
    let stat: String?
}

// MARK: TicketChecker convenience initializers and mutators

extension TicketChecker {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TicketChecker.self, from: data)
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
        uploader: Uploader?? = nil,
        stat: String?? = nil
    ) -> TicketChecker {
        return TicketChecker(
            uploader: uploader ?? self.uploader,
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
