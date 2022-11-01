//
//  User.swift
//  FlickerLong
//
//  Created by LAP15335 on 21/10/2022.
//

import Foundation
// MARK: - User
struct User: Codable {
    let id: String
    let updated_at: String?
    let username, name, first_name: String
    let last_name, twitter_username: String?
    let portfolio_url: String?
    let bio, location: String?
    let links: UserLinks
    let profile_image: ProfileImage
    let instagram_username: String?
    let total_collections, total_likes, total_photos: Int?
    let accepted_tos, for_hire: Bool?
    let social: Social

    enum CodingKeys: String, CodingKey {
        case id
        case updated_at
        case username, name
        case first_name
        case last_name
        case twitter_username
        case portfolio_url
        case bio, location, links
        case profile_image
        case instagram_username
        case total_collections
        case total_likes
        case total_photos
        case accepted_tos
        case for_hire
        case social
    }
}
