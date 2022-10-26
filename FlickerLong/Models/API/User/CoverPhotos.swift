//
//  CoverPhotos.swift
//  FlickerLong
//
//  Created by LAP15335 on 26/10/2022.
//

import Foundation
// MARK: - CoverPhotos
struct CoverPhotos: Codable {
    let photo: [Cover]?
}

// MARK: - Photo
struct Cover: Codable {
    let url: String?
    let width, height: Int?
    let isPrimary, isVideo: Int?

    enum CodingKeys: String, CodingKey {
        case url, width, height
        case isPrimary
        case isVideo
    }
}
