//
//  DetailViewController.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 07/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var post: Post!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "Posts"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDataSource, Delegate, Prefetch
extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return post.comments.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let coverCell = tableView.dequeueReusableCell(withIdentifier: "PostDetailCoverTableViewCell", for:indexPath) as? PostDetailCoverTableViewCell else {
                return UITableViewCell()
            }
            
            coverCell.setValues(post: self.post)
            FetchImage().imageFromURL(urlString: post.image, indexPath:indexPath) { (image,indexpath) in
                if let ip = indexpath, let cell = tableView.cellForRow(at: ip) as? PostDetailCoverTableViewCell {
                    cell.coverImage.image = image
                }
            }
            return coverCell
            
        } else {
            guard let commentCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for:indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            let commentEntity = self.post.comments[indexPath.row]
            commentCell.setValues(comment:commentEntity)
            return commentCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1, !post.comments.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") {
                return cell.contentView
            }
        }
        
        return nil
    }
}
