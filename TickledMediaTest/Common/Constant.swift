//
//  Constant.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 06/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import UIKit

//MARK: - Constants
typealias JsonDictionary = [String:Any]
typealias MainControllers = Storyboard.Main.controllers

let appDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: - Storyboard
struct Storyboard  {
    struct Main {
        static let name = "Main"
        struct controllers {
            enum segues:String {
                case listToDetail = "showPostDetail"
            }
            
            static let list = "ListViewController"
            static let detail = "DetailViewController"
        }
    }
}


//MARK: - Common Titles/String
enum Title: String {
   case appName = "TickledMediaTest"
}
