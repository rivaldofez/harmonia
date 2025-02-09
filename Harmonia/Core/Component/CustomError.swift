//
//  CustomError.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import Foundation
import Moya

public enum CustomError: Equatable, Error {
    case decodingError(Error)         ///< Represents an error that occurred during JSON decoding.
    case emptyDataResponse            ///< Represents a situation where the response contains no data.
    case unknown                      ///< Represents a situation where the error occured with no specific reason
    case noInternetConnection         ///< Represents a situation where there is no internet connection

    /// Checks if two `CustomError` values are equal.
    /// - Parameters:
    ///   - lhs: The first `CustomError` value.
    ///   - rhs: The second `CustomError` value.
    /// - Returns: `true` if both `CustomError` values are equal, otherwise `false`.
    public static func ==(lhs: CustomError, rhs: CustomError) -> Bool {
        switch (lhs, rhs) {
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
