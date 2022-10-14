//
//  ViewModels.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//

import Foundation

protocol ViewModel {
    associatedtype Item
    var model: Item? { get set }
}
