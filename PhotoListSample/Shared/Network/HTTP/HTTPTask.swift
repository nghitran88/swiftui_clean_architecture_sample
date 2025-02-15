//
//  HTTPTask.swift
//
//
//  Created by Nghi Tran on 19/1/25.
//

import Foundation

public typealias Parameters = [String: Any]

public enum HTTPTask {
    case request
    case requestBody(Data)
    case requestParameters(Parameters)
}
