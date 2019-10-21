//
//  NetworkHelper.swift
//  GoJek-Assignment
//
//  Created by Kumar, Ranjith B. (623-Extern) on 11/09/19.
//  Copyright © 2019 Kumar, Ranjith B. (623-Extern). All rights reserved.
//

import Foundation

public enum GoResult<V, E> {
    case success(V)
    case failure(E)
}

typealias fetchCompletion = (GoResult<GoContacts,Error>) -> ()
typealias taskCompletion = (GoResult<GoContact,Error>) -> ()
typealias deleteCompletion = (GoResult<Bool,Error>) -> ()

protocol ContactModuleApisProtcol {
    static func fetchContactsList(handler: @escaping (fetchCompletion))
    static func getContactDetails(with contact: GoContact, handler: @escaping (taskCompletion))
    static func createContact(with details: GoContact, handler: @escaping (deleteCompletion))
    static func updateContact(with details: GoContact, handler: @escaping (deleteCompletion))
    static func deleteContact(with details: GoContact, handler: @escaping (deleteCompletion))
}

struct GoNetworkHelper: ContactModuleApisProtcol {
    
    private init(){}
    
    static var baseURL: String {
        return "http://gojek-contacts-app.herokuapp.com/"
    }
    
    static func fetchContactsList(handler: @escaping (fetchCompletion)) {
        
        guard let url = URL(string: baseURL + "contacts.json") else {
            fatalError()
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                do {
                    handler(GoResult.success(try GoContacts(data: data!)))
                }catch let e {
                    handler(GoResult.failure(e))
                }
            }
        }).resume()
    }
    
    static func getContactDetails(with contact: GoContact, handler: @escaping (taskCompletion)) {
        
        guard let url = URL(string: baseURL + "contacts/\(contact.id).json") else {
            fatalError()
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                handler(GoResult.failure(error!))
            } else {
                do {
                    handler(GoResult.success(try GoContact(data: data!)))
                }catch let e {
                    print("error:\(e)")
                    handler(GoResult.failure(e))
                }
            }
        }).resume()
    }
    
    static func createContact(with details: GoContact, handler: @escaping (deleteCompletion)) {
        
        guard let url = URL(string: baseURL + "contacts.json") else {
            fatalError()
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: details.blob, options: [])
            request.httpBody = postData
        }catch let e {
            fatalError("Serialization error:\(e)")
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                handler(GoResult.failure(error!))
            } else {
                handler(GoResult.success(true))
            }
        })
        
        dataTask.resume()
    }
    
    static func updateContact(with details: GoContact, handler: @escaping (deleteCompletion)) {
        
        guard let url = URL(string: baseURL + "contacts/\(details.id).json") else {
            fatalError()
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "PUT"
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: details.blob, options: [])
            request.httpBody = postData
        }catch let e {
            fatalError("Serialization error:\(e)")
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                handler(GoResult.failure(error!))
            } else {
                handler(GoResult.success(true))
            }
        })
        
        dataTask.resume()
    }
    
    static func deleteContact(with details: GoContact, handler:@escaping (deleteCompletion)) {
        
        guard let url = URL(string: baseURL + "contacts/\(details.id).json") else {
            fatalError()
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "DELETE"
                
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                handler(GoResult.failure(error!))
            } else {
                handler(GoResult.success(true))
            }
        }).resume()
    }
    
}
