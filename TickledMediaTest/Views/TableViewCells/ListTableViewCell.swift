//
//  ListTableViewCell.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 06/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    
    /// SetUp Cell UI
    func setupUI() {
       self.messageLabel.numberOfLines = 3
       self.coverImage.contentMode = .scaleAspectFit
       self.selectionStyle = .none
       self.coverImage.backgroundColor = .lightGray
    }
    
    // Set Values in Cell
    func setValues(post:Post) {
        self.messageLabel.text = post.message
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}





