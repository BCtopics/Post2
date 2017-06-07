//
//  PostController.swift
//  Post2
//
//  Created by Bradley GIlmore on 6/6/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation

class PostController {
    
    init() {
        fetchPosts { (post) in
            // Fix this later so I can just do fetchPosts()
        }
    }
    //MARK: - Internal Properties
    
    static let baseURL = URL(string: "https://devmtn-post.firebaseio.com/posts")
    
    static let getterEndPoint = baseURL?.appendingPathExtension("json")
    
    weak var delegate: PostControllerDelegate?
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsWereUpdatedTo(posts: posts, on: self)
        }
    }
    
    //MARK: - Fetch Posts
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        
        guard let requestedURL = PostController.getterEndPoint else { NSLog("RequestedURL was nil"); completion(nil); return }
        
        NetworkController.performRequest(for: requestedURL, httpMethod: .get, urlParameters: nil, body: nil) { (data, error) in
            
            if let error = error {
                NSLog("Error performing network request: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {NSLog("Data is nil"); completion(nil); return; }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: [String: Any]] else { NSLog("JSONSerialization has failed."); completion(nil); return }
            
            let posts = jsonDictionary.flatMap { Post(jsonDictionary: $0.1, identifier: $0.0) }
            let sortedPosts = posts.sorted(by: { $0.0.timestamp > $0.1.timestamp })
            
            DispatchQueue.main.async {
                self.posts = sortedPosts
                completion(sortedPosts)
            }
        }
    }
    
    //MARK: - Adding Posts/ PUT Request
    
    func addNewPostWith(username: String, text: String) {
        
        let post = Post(username: username, text: text)
        
        guard let requestURL = post.endpoint else { fatalError("URL is nil") }
        
        NetworkController.performRequest(for: requestURL, httpMethod: .put, urlParameters: nil, body: post.jsonData) { (data, error) in
            
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            } else {
                print("Successfully saved data to endpoint.")
            }
            
            self.fetchPosts(completion: { (post) in
                // Do nothing :D
                //FIXME: Fix later
            })
        }
    }
}


protocol PostControllerDelegate: class {
    
    func postsWereUpdatedTo(posts: [Post], on postController: PostController)
}









