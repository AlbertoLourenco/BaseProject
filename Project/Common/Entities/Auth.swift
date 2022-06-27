//
//  Auth.swift
//

import UIKit

struct Auth: Codable {
    
    var objectId:       Int? = 0
    var name:           String? = ""
    var email:          String? = ""
    var phone:          String? = ""
    var paid:           Bool = false
    var avatar:         String? = ""
    var token:          String? = ""
    
    enum CodingKeys: String, CodingKey {
        case objectId = "id"
        case name
        case email
        case phone
        case paid
        case avatar = "image"
        case token
    }
}

extension Auth {
    
    static func login(email: String,
                      password: String,
                      _ completion: @escaping (_ result: Auth?,
                                               _ error: APIResponseError?) -> Void) {
        
        let parameters = ["email" : email,
                          "password" : password] as [String : Any]

        APIHelper.request(method: .post,
                            endpoint: Constants.API.Endpoint.Login,
                            parameters: parameters,
                            responseType: Auth.self,
                            mockType: .login) { (data, error, code) in
            
            if code == 200 {
                completion(data, nil)
            }else{
                completion(nil, error)
            }
        }
    }
    
    static func recoverPassword(email: String,
                                _ completion: @escaping (_ success: Bool) -> Void) {
        
        let parameters = ["email" : email]
        
        APIHelper.request(method: .post,
                     endpoint: Constants.API.Endpoint.ForgotPassword,
                     parameters: parameters,
                     responseType: Dictionary<String, String>.self) { (data, error, code) in
            completion(code == 200)
        }
    }
}
