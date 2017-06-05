//
//  Post.swift
//  Post2
//
//  Created by Bradley GIlmore on 6/5/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation

struct Post {
    
    //MARK: - Internal Properties
    
    let username: String
    let text: String
    let timestamp: TimeInterval
    let identifier: UUID
    
    init(username: String, text: String, identifier: UUID? = UUID(), timestamp: TimeInterval? = Date().timeIntervalSince1970 ) {
        
        guard let timestamp = timestamp, let identifier = identifier else { fatalError() }
        
        self.username = username
        self.text = text
        self.identifier = identifier
        self.timestamp = timestamp
        
    }
    
}
