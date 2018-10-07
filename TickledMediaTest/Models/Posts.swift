//
//  Posts.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 07/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import Foundation

struct Posts: Codable, ServiceResponseRepresentable {
    typealias T = [Post]
    var status: Bool
    var message: String
    var response: T
}

struct Post: Codable {
    let id : Int
    let userID: Int
    let message: String
    let image: String
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case message
        case image
        case comments
    }
}

struct Comment: Codable {
    let message: String
}
