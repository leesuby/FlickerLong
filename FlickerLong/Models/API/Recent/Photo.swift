//
//  Photo.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
}

// MARK: Photo convenience initializers and mutators
extension Photo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Photo.self, from: data)
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
        id: String? = nil,
        owner: String? = nil,
        secret: String? = nil,
        server: String? = nil,
        farm: Int? = nil,
        title: String? = nil,
        ispublic: Int? = nil,
        isfriend: Int? = nil,
        isfamily: Int? = nil
    ) -> Photo {
        return Photo(
            id: id ?? self.id,
            owner: owner ?? self.owner,
            secret: secret ?? self.secret,
            server: server ?? self.server,
            farm: farm ?? self.farm,
            title: title ?? self.title,
            ispublic: ispublic ?? self.ispublic,
            isfriend: isfriend ?? self.isfriend,
            isfamily: isfamily ?? self.isfamily
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
