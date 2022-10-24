//
//  Person.swift
//  FlickerLong
//
//  Created by LAP15335 on 20/10/2022.
//

import Foundation
// MARK: - Person
struct Person: Codable {
    let id, nsid: String?
    let ispro, isDeleted: Int
    let iconserver: String?
    let iconfarm: Int
    let pathAlias: String?
    let hasStats: Int
    let username, realname, location, personDescription: Description
    let photosurl, profileurl, mobileurl: Description
    let photos: Photoss
    let hasAdfree, hasFreeStandardShipping, hasFreeEducationalResources: Int

    enum CodingKeys: String, CodingKey {
        case id, nsid, ispro
        case isDeleted = "is_deleted"
        case iconserver, iconfarm
        case pathAlias = "path_alias"
        case hasStats = "has_stats"
        case username, realname, location
        case personDescription = "description"
        case photosurl, profileurl, mobileurl, photos
        case hasAdfree = "has_adfree"
        case hasFreeStandardShipping = "has_free_standard_shipping"
        case hasFreeEducationalResources = "has_free_educational_resources"
    }
}

// MARK: Person convenience initializers and mutators

extension Person {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Person.self, from: data)
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
        nsid: String? = nil,
        ispro: Int? = nil,
        isDeleted: Int? = nil,
        iconserver: String? = nil,
        iconfarm: Int? = nil,
        pathAlias: String? = nil,
        hasStats: Int? = nil,
        username: Description? = nil,
        realname: Description? = nil,
        location: Description? = nil,
        personDescription: Description? = nil,
        photosurl: Description? = nil,
        profileurl: Description? = nil,
        mobileurl: Description? = nil,
        photos: Photoss? = nil,
        hasAdfree: Int? = nil,
        hasFreeStandardShipping: Int? = nil,
        hasFreeEducationalResources: Int? = nil
    ) -> Person {
        return Person(
            id: id ?? self.id,
            nsid: nsid ?? self.nsid,
            ispro: ispro ?? self.ispro,
            isDeleted: isDeleted ?? self.isDeleted,
            iconserver: iconserver ?? self.iconserver,
            iconfarm: iconfarm ?? self.iconfarm,
            pathAlias: pathAlias ?? self.pathAlias,
            hasStats: hasStats ?? self.hasStats,
            username: username ?? self.username,
            realname: realname ?? self.realname,
            location: location ?? self.location,
            personDescription: personDescription ?? self.personDescription,
            photosurl: photosurl ?? self.photosurl,
            profileurl: profileurl ?? self.profileurl,
            mobileurl: mobileurl ?? self.mobileurl,
            photos: photos ?? self.photos,
            hasAdfree: hasAdfree ?? self.hasAdfree,
            hasFreeStandardShipping: hasFreeStandardShipping ?? self.hasFreeStandardShipping,
            hasFreeEducationalResources: hasFreeEducationalResources ?? self.hasFreeEducationalResources
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
