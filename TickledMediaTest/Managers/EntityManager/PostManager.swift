//
//  PostManager.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 07/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import Foundation

class PostManager {
    static let shared = PostManager()
    private init() {
    }
    
    func getPosts(callback:@escaping (_ post:[Post]?, _ error:APIError?)->Void) {
        let serviceParameters = ServiceParamters(method: .get, body: nil, serviceName: WebService.Name.dummyPath)
        
        let serviceManager = ServiceManager<Posts>()
        let _ = serviceManager.callWebService(parameters:serviceParameters) {(response) in
            switch (response) {
            case .success(let postArrayEntity):
                callback(postArrayEntity.1.response, nil)
            case .failure(let error):
                callback(nil, error.1)
            }
        }
    }
}
