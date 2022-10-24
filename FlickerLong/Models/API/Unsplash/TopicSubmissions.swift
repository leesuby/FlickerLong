//
//  TopicSubmissions.swift
//  FlickerLong
//
//  Created by LAP15335 on 21/10/2022.
//

import Foundation
// MARK: - TopicSubmissions
struct TopicSubmissions: Codable {
    let wallpapers, texturesPatterns: TexturesPatterns?
    let fashion: Fashion?

    enum CodingKeys: String, CodingKey {
        case wallpapers
        case texturesPatterns
        case fashion
    }
}




