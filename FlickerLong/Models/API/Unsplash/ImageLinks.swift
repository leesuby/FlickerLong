//
//  ImageLinks.swift
//  FlickerLong
//
//  Created by LAP15335 on 21/10/2022.
//

import Foundation
// MARK: - ImageLinks
struct ImageLinks: Codable {
    let html, download, downloadLocation: String?

    enum CodingKeys: String, CodingKey {
        case html, download
        case downloadLocation
    }
}
