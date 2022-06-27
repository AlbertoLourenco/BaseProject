//
//  APIResponseError.swift
//

import Foundation

struct APIResponseError: Codable {
    
    var code: Int?
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "statusCode"
        case message = "message"
    }
}
