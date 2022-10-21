//
//  Social.swift
//  FlickerLong
//
//  Created by LAP15335 on 21/10/2022.
//

import Foundation
// MARK: - Social
struct Social: Codable {
    let instagramUsername: String?
    let portfolioURL: String?
    let twitterUsername: String?
    let paypalEmail: JSONNull?

    enum CodingKeys: String, CodingKey {
        case instagramUsername
        case portfolioURL
        case twitterUsername
        case paypalEmail
    }
}
