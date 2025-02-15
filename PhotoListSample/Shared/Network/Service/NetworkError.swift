//
//  NetworkError.swift
//
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

public enum NetworkError: Error {
    case timedOut
    case missingUrl
    case unauthorized
    case notConnected
    case decodingError
    case encodingError
    case methodNotAllowed
    case invalidResponse
    case unknown(Error)
    case requestFailed(HTTPStatusCode, Data)
}
