//
//  APIClient.swift
//  MVVMSampleUITests
//
//  Created by Drew Sullivan on 1/3/19.
//  Copyright © 2019 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

protocol SessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask
}

enum JSONPlaceholderType: String {
    case posts = "posts"
    case comments = "comments"
    case albums = "albums"
    case photos = "photos"
    case todos = "todos"
    case users = "users"
}

enum JSONPlaceholderQuery: String {
    case limit = "_limit"
}

class APIClient {
    
    lazy var session: SessionProtocol = URLSession.shared
    
    func fetchItems(ofType type: JSONPlaceholderType, withQuery query: JSONPlaceholderQuery, numItems num: Int, completion: @escaping ([Photo]?, Error?) -> Void) {
        guard num > 0 else { fatalError() }
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/\(type)?\(query)=\(num)") else { fatalError() }
        
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                completion(photos, nil)
            } catch {
                completion(nil, error)
            }
            
        }.resume()
    }
    
}

extension URLSession: SessionProtocol {}

enum WebserviceError: Error {
    case DataEmptyError
}
