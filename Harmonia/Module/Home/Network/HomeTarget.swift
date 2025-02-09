//
//  HomeTarget.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import Foundation
import Moya

enum HomeTarget {
    case searchForSong(query: String)
}

extension HomeTarget: CustomTargetType {
    var auth: APIType {
        return .itunes
    }
    
    internal var baseURL: URL {
        guard let url = URL(string: NSString.basicUrl()) else { fatalError() }
        return url
    }
    
    internal var path: String {
        switch self {
        case .searchForSong:
            return "search"
        }
    }
    
    internal var method: Moya.Method {
        switch self {
            
        case .searchForSong:
            return .get
        }
    }
    
    internal var headers: [String : String]? { return [:] }
    
    internal var parameters: [String: Any] { return [:] }
    
    internal var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    internal var task: Task {
        switch self {
        case .searchForSong(let query):
            return .requestParameters(parameters: ["term": query], encoding: URLEncoding.default)
        }
    }
}
