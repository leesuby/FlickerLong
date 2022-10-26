//
//  Galleries.swift
//  FlickerLong
//
//  Created by LAP15335 on 26/10/2022.
//

import Foundation
// MARK: - Galleries
struct Galleries: Codable {
    let total, per_page: Int?
    let user_id: String?
    let page, pages: Int?
    let gallery: [Gallery]

    enum CodingKeys: String, CodingKey {
        case total
        case per_page
        case user_id
        case page, pages, gallery
    }
}


extension Galleries {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Galleries.self, from: data)
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
        total: Int?? = nil,
        perPage: Int?? = nil,
        userID: String?? = nil,
        page: Int?? = nil,
        pages: Int?? = nil,
        gallery: [Gallery]?? = nil
    ) -> Galleries {
        return Galleries(
            total: total ?? self.total,
            per_page: perPage ?? self.per_page,
            user_id: userID ?? self.user_id,
            page: page ?? self.page,
            pages: pages ?? self.pages,
            gallery: (gallery ?? self.gallery)!
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
