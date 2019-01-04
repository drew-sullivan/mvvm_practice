//
//  Manager.swift
//  MVVMSample
//
//  Created by Drew Sullivan on 1/3/19.
//  Copyright © 2019 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

class Manager {
    
    private var photos: [Photo]
    
    private init() {
        photos = [Photo]()
    }
    
    public static let shared: Manager = {
        let instance = Manager()
        return instance
    }()
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func clearPhotos() {
        photos = []
    }
    
    func numPhotos() -> Int {
        return photos.count
    }
    
    func addPhoto(_ photo: Photo) {
        photos.append(photo)
    }
    
}
