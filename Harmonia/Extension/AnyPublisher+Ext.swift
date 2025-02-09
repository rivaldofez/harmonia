//
//  AnyPublishers+Ext.swift
//  Harmonia
//
//  Created by Rivaldo Fernandes on 09/02/25.
//

import Foundation
import Combine
import Moya
import CombineMoya

extension AnyPublisher where Output == Response, Failure == MoyaError {
    /// Decodes the response data into a specified `Decodable` type.
    /// - Parameter type: The type of the data you want to decode.
    /// - Returns: An `AnyPublisher` that publishes a `Result` containing the decoded data or a `CustomError`.
    public func decodeJSON<T: Decodable>(to type: T.Type) -> AnyPublisher<Result<T, CustomError>, Never> {
        return self
            .tryMap { response -> Result<T, CustomError> in
                do {
                    // Decode the response data using JSONDecoder
                    let decodedData = try JSONDecoder().decode(T.self, from: response.data)
                    
                    // Return success with the decoded data
                    return .success(decodedData)
                } catch {
                    // Return failure with decoding error
                    return .failure(.decodingError(error))
                }
            }
            .catch{ error -> Just<Result<T, CustomError>> in
                if case let MoyaError.underlying(wrappedError, _) = error, let customError = wrappedError as? CustomError {
                    return Just(.failure(customError))
                } else {
                    return Just(.failure(.decodingError(error)))
                }
            }
            .eraseToAnyPublisher() // Erase to AnyPublisher to conform to the publisher chain
    }
}
