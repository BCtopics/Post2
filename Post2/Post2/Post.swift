//
//  Post.swift
//  Post2
//
//  Created by Bradley GIlmore on 6/5/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation

struct Post {
    
    //MARK: - Keys
    
    fileprivate let userKey = "username"
    fileprivate let textKey = "text"
    fileprivate let timestampKey = "timestamp"
    
    //MARK: - Internal Properties
    
    let username: String
    let text: String
    let timestamp: TimeInterval
    let identifier: UUID
    
    
    //MARK: - Initializers
    
    init(username: String, text: String, identifier: UUID? = UUID(), timestamp: TimeInterval? = Date().timeIntervalSince1970 ) {
        
        guard let timestamp = timestamp, let identifier = identifier else { fatalError() }
        
        self.username = username
        self.text = text
        self.identifier = identifier
        self.timestamp = timestamp
        
    }
    
    init?(jsonDictionary: [String: Any], identifier: String) {
        
        guard let username = jsonDictionary[userKey] as? String,
            let text = jsonDictionary[textKey] as? String,
            let timestamp = jsonDictionary[timestampKey] as? Double,
            let identifier = UUID(uuidString: identifier) else { return nil }
        
        self.username = username
        self.text = text
        self.timestamp = TimeInterval(floatLiteral: timestamp)
        self.identifier = identifier
    }
    
    var jsonRep: [String: Any] {
        
        return [userKey: self.username,
                textKey: self.text,
                timestampKey: self.timestamp]
    }
    
    var jsonData: Data? {
        return (try? JSONSerialization.data(withJSONObject: self.jsonRep, options: .prettyPrinted))
    }
    
}
