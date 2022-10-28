//
//  Photosets.swift
//  FlickerLong
//
//  Created by LAP15335 on 28/10/2022.
//

import Foundation
// MARK: - Photosets
struct Photosets: Codable {
    let cancreate, page, pages: Int?
    let perpage: Int?
    let total: Int?
    let photoset: [Photoset]?
}

// MARK: Photosets convenience initializers and mutators

extension Photosets {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Photosets.self, from: data)
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
        cancreate: Int?? = nil,
        page: Int?? = nil,
        pages: Int?? = nil,
        perpage: Int?? = nil,
        total: Int?? = nil,
        photoset: [Photoset]?? = nil
    ) -> Photosets {
        return Photosets(
            cancreate: cancreate ?? self.cancreate,
            page: page ?? self.page,
            pages: pages ?? self.pages,
            perpage: perpage ?? self.perpage,
            total: total ?? self.total,
            photoset: photoset ?? self.photoset
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
