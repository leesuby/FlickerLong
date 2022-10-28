//
//  ListPhotosAlbum.swift
//  FlickerLong
//
//  Created by LAP15335 on 28/10/2022.
//

import Foundation
// MARK: - Photoset
struct ListPhotosAlbum: Codable {
    let id, primary, owner, ownername: String?
    let photo: [Photo]?
    let page: Int?
    let perPage: String?
    let perpage: Int?
    let pages: Int?
    let title: String?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case id, primary, owner, ownername, photo, page
        case perPage
        case perpage, pages, title, total
    }
}

// MARK: Photoset convenience initializers and mutators

extension ListPhotosAlbum {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ListPhotosAlbum.self, from: data)
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
        primary: String?? = nil,
        owner: String?? = nil,
        ownername: String?? = nil,
        photo: [Photo]?? = nil,
        page: Int?? = nil,
        perPage: String?? = nil,
        perpage: Int?? = nil,
        pages: Int?? = nil,
        title: String?? = nil,
        total: Int?? = nil
    ) -> ListPhotosAlbum {
        return ListPhotosAlbum(
            id: id ?? self.id,
            primary: primary ?? self.primary,
            owner: owner ?? self.owner,
            ownername: ownername ?? self.ownername,
            photo: photo ?? self.photo,
            page: page ?? self.page,
            perPage: perPage ?? self.perPage,
            perpage: perpage ?? self.perpage,
            pages: pages ?? self.pages,
            title: title ?? self.title,
            total: total ?? self.total
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
