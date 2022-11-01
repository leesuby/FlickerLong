//
//  ImageElement.swift
//  FlickerLong
//
//  Created by LAP15335 on 21/10/2022.
//

import Foundation

// MARK: - ImageElement
struct ImageElement: Codable {
    let id: String?
    let created_at, updated_at: String?
    let promoted_at: String?
    let width, height: Int?
    let color, blur_hash: String?
    let description: String?
    let urls: Urls
    let links: ImageLinks
    let likes: Int?
    let liked_by_user: Bool?
    let current_user_collections: [JSONAny]?
    let sponsorship: Sponsorship?
    let topic_submissions: TopicSubmissions
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case created_at
        case updated_at
        case promoted_at
        case width, height, color
        case blur_hash
        case description
        case urls, links, likes
        case liked_by_user
        case current_user_collections
        case sponsorship
        case topic_submissions
        case user
    }
}
