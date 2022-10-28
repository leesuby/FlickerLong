//
//  Photoset.swift
//  FlickerLong
//
//  Created by LAP15335 on 28/10/2022.
//

import Foundation

// MARK: - Photoset
struct Photoset: Codable {
    let id, owner, username, primary: String?
    let secret, server: String?
    let farm : Int?
    let count_views, count_comments : String?
    let count_photos: Int?
    let count_videos: Int?
    let title, photoset_description: Description?
    let can_comment: Int?
    let date_create, date_update: String?
    let photos, videos: Int?

    enum CodingKeys: String, CodingKey {
        case id, owner, username, primary, secret, server, farm
        case count_views
        case count_comments
        case count_photos
        case count_videos
        case title
        case photoset_description
        case can_comment
        case date_create
        case date_update
        case photos, videos
  
    }
}

extension Photoset {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Photoset.self, from: data)
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
        owner: String?? = nil,
        username: String?? = nil,
        primary: String?? = nil,
        secret: String?? = nil,
        server: String?? = nil,
        farm: Int?? = nil,
        countViews: String?? = nil,
        countComments: String?? = nil,
        countPhotos: Int?? = nil,
        countVideos: Int?? = nil,
        title: Description?? = nil,
        photosetDescription: Description?? = nil,
        canComment: Int?? = nil,
        dateCreate: String?? = nil,
        dateUpdate: String?? = nil,
        photos: Int?? = nil,
        videos: Int?? = nil
    ) -> Photoset {
        return Photoset(
            id: id ?? self.id,
            owner: owner ?? self.owner,
            username: username ?? self.username,
            primary: primary ?? self.primary,
            secret: secret ?? self.secret,
            server: server ?? self.server,
            farm: farm ?? self.farm,
            count_views: countViews ?? self.count_views,
            count_comments: countComments ?? self.count_comments,
            count_photos: countPhotos ?? self.count_photos,
            count_videos: countVideos ?? self.count_videos,
            title: title ?? self.title,
            photoset_description: photosetDescription ?? self.photoset_description,
            can_comment: canComment ?? self.can_comment,
            date_create: dateCreate ?? self.date_create,
            date_update: dateUpdate ?? self.date_update,
            photos: photos ?? self.photos,
            videos: videos ?? self.videos
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
