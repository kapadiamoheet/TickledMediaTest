//
//  CommentTableViewCell.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 07/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentText : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpUI()
    }
    
    func setUpUI(){
        self.commentText.numberOfLines = 0
        self.selectionStyle = .none
    }
    
    func setValues(comment:Comment) {
        self.commentText.text = comment.message
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
