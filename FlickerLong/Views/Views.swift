//
//  Views.swift
//  FlickerLong
//
//  Created by LAP15335 on 13/10/2022.
//

import Foundation

protocol View {
    associatedtype viewModel
    var viewModel: viewModel! { get set }
    
    func bind(with vm: viewModel)
}
