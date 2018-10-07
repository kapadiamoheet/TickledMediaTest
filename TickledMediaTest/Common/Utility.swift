//
//  Utility.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 07/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import UIKit
class Utility {
    static func showAlert( title:String?,
                    message:String?,
                    style:UIAlertControllerStyle? = .alert,
                    actions:[UIAlertAction]? = [],
                    source:UIViewController ) {
        let alert = UIAlertController(title: title ?? Title.appName.rawValue, message: message, preferredStyle: style!)
        if !actions!.isEmpty {
            for action in actions! {
                alert.addAction(action)
            }
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
        source.present(alert, animated: true, completion: nil)
    }
}

