//
//  Photo.swift
//  MVVMSample
//
//  Created by Drew Sullivan on 1/3/19.
//  Copyright © 2019 Drew Sullivan, DMA. All rights reserved.
//

import Foundation

public struct Photo: Codable, Equatable {
    
    var albumId: Int
    var id: Int
    var title: String
    private var url: String
    private var thumbnailUrl: String
    
    init(albumID: Int, id: Int, title: String, url: String, thumbnailURL: String) {
        self.albumId = albumID
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailURL
    }
    
    init(isSample sample: Bool) {
        self.albumId = 23
        self.id = 17
        self.title = "Black Lotus"
        self.url = "https://whatever.com"
        self.thumbnailUrl = "https://whatever.com/photo"
    }
    
    public static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    var photoURL: URL? {
        return URL(string: url) ?? nil
    }

    var thumbnailLocationURL: URL? {
        return URL(string: thumbnailUrl) ?? nil
    }
}
