//
//  Gallery.swift
//  FlickerLong
//
//  Created by LAP15335 on 26/10/2022.
//

import Foundation
// MARK: - Gallery
struct Gallery: Codable {
    let id, gallery_id: String?
    let url: String?
    let owner, username, iconserver: String?
    let iconfarm: Int?
    let primary_photo_id, date_create, date_update: String?
    let count_photos, count_videos, count_total, count_views: Int?
    let count_comments: Int?
    let title, gallery_description: Description?
    let sort_group: String?
    let cover_photos: CoverPhotos?
    let primary_photo_server: String?
    let primary_photo_farm: Int?
    let primary_photo_secret: String?

    enum CodingKeys: String, CodingKey {
        case id
        case gallery_id
        case url, owner, username, iconserver, iconfarm
        case primary_photo_id
        case date_create
        case date_update
        case count_photos
        case count_videos
        case count_total
        case count_views
        case count_comments
        case title
        case gallery_description
        case sort_group
        case cover_photos
        case primary_photo_server
        case primary_photo_farm
        case primary_photo_secret
    }
}
