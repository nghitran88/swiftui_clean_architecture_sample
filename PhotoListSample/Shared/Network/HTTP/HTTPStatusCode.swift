//
//  HTTPStatusCode.swift
//
//
//  Created by Nghi Tran on 19/1/25.
//

public enum HTTPStatusCode: Int {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204

    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405

    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
}
