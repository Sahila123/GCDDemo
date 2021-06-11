//
//  Album.swift
//  ThreadAssignment
//
//  Created by Mirajkar on 11/06/21.
//  Copyright © 2021 Mirajkar. All rights reserved.
//

import Foundation.NSURL

struct Album {
    //MARK: Global varibles
    var title : String
    var trackThumbnailUrl : URL
    
    
    init(title: String, trackThumbnailUrl: URL) {
        self.title = title
        self.trackThumbnailUrl = trackThumbnailUrl
    }
}
