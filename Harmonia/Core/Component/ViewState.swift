//
//  ViewState.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import Foundation

enum ViewState: Equatable {
    case loading
    case error(message: String)
    case success
}
