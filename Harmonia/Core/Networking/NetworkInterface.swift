//
//  NetworkInterface.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import Foundation
import Moya

extension NSString {
    /// Enum to represent different base URLs based on the environment.
    public enum BaseURL {
        case production
        case staging
    }
    
    /// The current environment configuration for base URLs.
    /// - Returns: `.staging` in debug builds, `.production` in release builds.
    public static var environment: BaseURL = {
        #if DEBUG
            return .staging
        #else
            return .production
        #endif
    }()
    
    /// Provides the base URL for the API based on the current environment.
    /// - Returns: A string containing the base URL for the API.
    public static func basicUrl() -> String {
        let url: String
        switch environment {
        case .production:
            url = "https://itunes.apple.com/"
        case .staging:
            url = "https://itunes.apple.com/"
        }
        return url
    }
}
        

public protocol CustomTargetType: TargetType {
    /// The API type for authentication and header configuration.
    var auth: APIType { get }
}

public enum APIType {
    case itunes
        
    /// Provides the API key(s) for the API type, formatted according to the target.
    /// - Returns: A dictionary containing the API key(s), or `nil` if not applicable.
    var apiKey: [String: String]? {
        switch self {
        case .itunes:
            return [:]
        }
    }
}
