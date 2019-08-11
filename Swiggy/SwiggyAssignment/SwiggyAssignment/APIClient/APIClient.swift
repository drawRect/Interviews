//
//  APIClient.swift
//  SwiggyAssignment
//
//  Created by Ranjith Kumar on 3/16/19.
//  Copyright © 2019 DrawRect. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

struct APIClient {

    typealias _JSONResponse = (_ result: Result<JSONResponse>)->()

    static func getJSONReponse(completion: @escaping _JSONResponse) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.myjson.com/bins/3b0u2")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [:]
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(Result.failure(error!))
            } else {
                do {
                    if let _ = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] {
                        let jsonResponse = try JSONDecoder().decode(JSONResponse.self, from: data!)
                        completion(Result.success(jsonResponse))
                    }
                }catch(let e) {
                    print(e)
                    completion(Result.failure(e))
                }
            }
        })
        dataTask.resume()
    }
}
