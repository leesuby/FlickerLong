//
//  TexturePictures.swift
//  FlickerLong
//
//  Created by LAP15335 on 21/10/2022.
//

import Foundation
// MARK: - TexturesPatterns
struct TexturesPatterns: Codable {
    let status: String?
    let approvedOn: Date?

    enum CodingKeys: String, CodingKey {
        case status
        case approvedOn
    }
}
