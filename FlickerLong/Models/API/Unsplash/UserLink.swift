//
//  UserLink.swift
//  FlickerLong
//
//  Created by LAP15335 on 21/10/2022.
//

import Foundation
// MARK: - UserLinks
struct UserLinks: Codable {
    let html, photos, likes: String?
    let portfolio, following, followers: String?

    enum CodingKeys: String, CodingKey {
        case html, photos, likes, portfolio, following, followers
    }
}
