//
//  NetworkProvider.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import Foundation
import Moya
import Combine
import CombineMoya
import Alamofire

/// A generic network provider that handles network requests using Moya and Combine.
open class NetworkProvider<Target> where Target: CustomTargetType {
    private let provider: MoyaProvider<Target>
    
    /// Initializes a new `NetworkProvider` instance.
    /// - Parameters:
    ///   - endpointClosure: A closure to customize endpoint creation. Defaults to `NetworkProvider.defaultEndpointCreator`.
    ///   - requestClosure: A closure to customize the request. Defaults to `MoyaProvider<Target>.defaultRequestMapping`.
    ///   - stubClosure: A closure to provide stubbing behavior. Defaults to `MoyaProvider.neverStub`.
    ///   - callbackQueue: The queue to which the request callback will be dispatched. Defaults to `nil`.
    ///   - session: The Alamofire session to use for network requests. Defaults to `MoyaProvider<Target>.defaultAlamofireSession()`.
    ///   - plugins: An array of plugins to use with the provider. Defaults to an empty array.
    ///   - trackInflights: A Boolean value indicating whether to track inflight requests. Defaults to `false`.
    public init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = NetworkProvider.defaultEndpointCreator,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        callbackQueue: DispatchQueue? = nil,
        session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
        plugins: [PluginType] = [],
        trackInflights: Bool = false
    ) {
        provider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            callbackQueue: callbackQueue,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
    
    /// Creates a URLRequest for a given target.
    /// - Parameter target: The target for which the URLRequest is created.
    /// - Returns: The URLRequest if creation is successful, otherwise `nil`.
    public final class func urlRequest(for target: Target) -> URLRequest? {
        let endpoint: Endpoint = NetworkProvider.defaultEndpointCreator(for: target)
        return try? endpoint.urlRequest()
    }
    
    /// Creates a default endpoint for a given target, with headers and task configurations.
    /// - Parameter target: The target for which the endpoint is created.
    /// - Returns: An `Endpoint` configured for the target.
    public final class func defaultEndpointCreator(for target: Target) -> Endpoint {
        let headers: [String: String] = [:]
        
        var extraHeaders: [String: String] = [:]
        let path = target.path
        let newTask: Task
        
        switch target.task {
        case .requestParameters(let targetParameters, let encoding):
            let parameters: [String: Any]?
            if encoding is Moya.JSONEncoding {
                parameters = targetParameters
            } else {
                parameters = addUserParameters(param: targetParameters)
            }
            newTask = .requestParameters(parameters: parameters ?? [:], encoding: encoding)
        case .uploadMultipart(let multipartData):
            newTask = .uploadMultipart(multipartData)
        default:
            newTask = target.task
        }
        
        // Add any additional headers for authentication
        if let authTargetHeader = target.auth.apiKey {
            authTargetHeader.forEach {
                extraHeaders.updateValue($1, forKey: $0)
            }
        }
        
        // Add any extra headers provided by the target
        if let extraTargetHeader = target.headers {
            extraTargetHeader.forEach {
                extraHeaders.updateValue($1, forKey: $0)
            }
        }
        
        // Convert default headers from Alamofire to a [String: String] dictionary
        let defaultHeaders = MoyaProvider<Target>.defaultAlamofireSession().sessionConfiguration.headers.dictionary
        extraHeaders = extraHeaders.merging(defaultHeaders) { first, _ in
            first
        }
        
        return Endpoint(
            url: target.baseURL.appendingPathComponent(path).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: newTask,
            httpHeaderFields: headers
        ).adding(newHTTPHeaderFields: extraHeaders)
    }
    
    /// Adds user-specific parameters to the request parameters.
    /// - Parameter param: The original parameters.
    /// - Returns: The parameters including user-specific values. This is currently a placeholder function.
    private class func addUserParameters(param: [String: Any]) -> [String: Any] {
        // Implement additional parameter handling if needed
        return param
    }
        
    /// Makes a network request and handles the response.
    /// - Parameter service: The target for the request.
    /// - Returns: An `AnyPublisher` that emits the response or an error.
    public func requestPlainResponse(_ service: Target) -> AnyPublisher<Response, MoyaError> {
        if(NetworkReachabilityManager()?.isReachable ?? false) {
            return provider.requestPublisher(service)
                .flatMap { response -> AnyPublisher<Response, MoyaError> in
                    return Just(response).setFailureType(to: MoyaError.self).eraseToAnyPublisher()
                }
                .retry(2)
                .catch { error -> AnyPublisher<Response, MoyaError> in
                    return Fail(error: error).eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: MoyaError.underlying(CustomError.noInternetConnection, nil)).eraseToAnyPublisher()
        }
    }
}
