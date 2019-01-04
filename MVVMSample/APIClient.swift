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

struct APIClient {
    
    lazy var session: SessionProtocol = URLSession.shared
    
    mutating func fetchData(completion: @escaping ([Photo]?, Error?) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else { fatalError() }
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, WebserviceError.DataEmptyError)
                return
            }
            let photos: [Photo]?
            do {
                photos = try JSONDecoder().decode([Photo].self, from: data)
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
