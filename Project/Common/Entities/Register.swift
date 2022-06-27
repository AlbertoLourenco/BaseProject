//
//  Register.swift
//

import Foundation

struct Register {
    var name:               String = ""
    var email:              String = ""
    var phone:              String = ""
    var password:           String = ""
    var passwordConfirm:    String = ""
    var photo:              Data? = nil
}

extension Register {
    
    static func add(object: Register,
                    _ completion: @escaping (_ result: Auth?,
                                             _ error: APIResponseError?) -> Void) {
        
        let parameters = ["name" : object.name,
                          "email" : object.email,
                          "phone" : object.phone.digits(),
                          "password" : object.password,
                          "password_confirmation" : object.password,
                          "avatar" : object.photo?.base64EncodedString() ?? ""] as [String : Any]
        
        APIHelper.request(method: .post,
                            endpoint: Constants.API.Endpoint.Register,
                            parameters: parameters,
                            responseType: Auth.self) { (data, error, code) in
            
            if code == 201 {
                completion(data, nil)
            }else{
                completion(nil, error)
            }
        }
    }
}
