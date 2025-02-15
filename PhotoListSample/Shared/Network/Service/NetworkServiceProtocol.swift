//
//  NetworkServiceProtocol.swift
//
//
//  Created by Nghi Tran on 19/1/25.
//

public protocol NetworkServiceProtocol {
    func request(config: NetworkConfig) async throws
    func request<T: Decodable>(config: NetworkConfig) async throws -> T
}
