//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by BKS-GGS on 06/03/23.
//

import Foundation

protocol NetworkSession {
    func loadData(with urlRequest: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    func loadData(with urlRequest: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: urlRequest) { (data, _, error) in
            completionHandler(data, error)
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case failed(_ desc: String)
    case badRequest
}

class NetworkManager {
    private let session: NetworkSession
    
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }
    
    func makeRequest<T: Decodable>(
        with url: URL,
        decode decodable: T.Type,
        completionHandler: @escaping (Result<T, NetworkError>) -> Void
    ) {
        session.loadData(with: URLRequest(url: url)) { data, error in
            guard let data = data else {
                if let error = error {
                    return completionHandler(.failure(NetworkError.failed(error.localizedDescription)))
                }
                return completionHandler(.failure(NetworkError.badRequest))
            }
            do {
                let parsed = try JSONDecoder().decode(decodable, from: data)
                completionHandler(.success(parsed))
            } catch {
                completionHandler(.failure(NetworkError.failed(error.localizedDescription)))
            }
        }
    }
}

