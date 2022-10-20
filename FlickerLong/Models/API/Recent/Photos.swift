//
//  Photos.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//
import Foundation

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int?
    let total: Int?
    let photo: [Photo]?
}

// MARK: Photos convenience initializers and mutators
extension Photos {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Photos.self, from: data)
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
        page: Int? = nil,
        pages: Int? = nil,
        perpage: Int? = nil,
        total: Int? = nil,
        photo: [Photo]? = nil
    ) -> Photos {
        return Photos(
            page: page ?? self.page,
            pages: pages ?? self.pages,
            perpage: perpage ?? self.perpage,
            total: total ?? self.total,
            photo: photo ?? self.photo
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
