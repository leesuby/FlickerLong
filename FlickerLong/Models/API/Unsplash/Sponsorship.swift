//
//  Sponsorship.swift
//  FlickerLong
//
//  Created by LAP15335 on 21/10/2022.
//

import Foundation
// MARK: - Sponsorship
struct Sponsorship: Codable {
    let impressionUrls: [String]?
    let tagline: String?
    let taglineURL: String?
    let sponsor: User

    enum CodingKeys: String, CodingKey {
        case impressionUrls
        case tagline
        case taglineURL
        case sponsor
    }
}
