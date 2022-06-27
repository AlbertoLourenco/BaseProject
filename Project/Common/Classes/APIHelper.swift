//
//  APIHelper.swift
//

import Foundation

final class APIHelper {
    
    static func request<T:Decodable>(method: RequestType,
                                     endpoint: String,
                                     parameters: Dictionary<String, Any>,
                                     responseType: T.Type,
                                     mockType: MockType = .none,
                                     completion: @escaping (_ response: T?,
                                                            _ error: APIResponseError?,
                                                            _ code: Int) -> Void) {
        
        var serverURL: String = Constants.API.BaseURL + endpoint
        
        let request = NSMutableURLRequest()
        request.timeoutInterval = 30
        request.cachePolicy = .useProtocolCachePolicy
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        switch method {
            case .get:
                serverURL += parameters.buildQueryString()
                request.httpMethod = "GET"
                break
            case .post:
                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                break
            case .put:
                request.httpMethod = "PUT"
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                break
        }
        
        if let token = Session.get()?.token {
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        
        request.url = URL(string: serverURL)
        
        //---------------------------------------------------------
        //  Running tests
        //---------------------------------------------------------
        
        if Preferences.isRunningTests {
            if Preferences.isRunningTestsFail {
                Cache.testsSuccess = false
                if let mock = Mock.shared.load(type: .error) {
                    let error = try? JSONDecoder().decode(APIResponseError.self, from: mock)
                    completion(nil, error, 400)
                }
            }else{
                Cache.testsSuccess = true
                if let mock = Mock.shared.load(type: mockType) {
                    let parse = try? JSONDecoder().decode(T.self, from: mock)
                    completion(parse, nil, 200)
                }
            }
            return
        }
        
        //---------------------------------------------------------
        //  Load API
        //---------------------------------------------------------
        
        DispatchQueue.global().async {
            let _ = session.dataTask(with: request as URLRequest,
                                        completionHandler: {data, response, error -> Void in
                let responseCode = response?.getStatusCode() ?? 0
                if let data = data, data.count != 0 {
                    let responseError = try? JSONDecoder().decode(APIResponseError.self, from: data)
                    do {
                        let parse = try JSONDecoder().decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(parse, responseError, responseCode)
                        }
                    }catch{
                        print(error)
                        DispatchQueue.main.async {
                            completion(nil, responseError, responseCode)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(nil, nil, responseCode)
                    }
                }
            }).resume()
        }
    }
}
