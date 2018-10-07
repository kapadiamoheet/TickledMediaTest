//
//  ListViewController.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 06/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    var dataCountToFetch = 100
    var posts: [Post] = []
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPosts()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.prefetchDataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        self.title = "Posts"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK: - Fetch Posts
    /// Call to fetch the Posts from server
    func fetchPosts(){
        PostManager.shared.getPosts {[weak self] (posts, error) in
            if let s = self {
                if let posts = posts {
                    if s.posts.isEmpty {
                        s.posts = posts
                    } else {
                        s.posts.append(contentsOf: posts)
                    }
                    
                    s.dataCountToFetch = s.dataCountToFetch - posts.count
                    s.tableView.reloadData()
                } else if let error = error {
                    Utility.showAlert(title: nil, message: error.description().1, source: s)
                }
            }
        }
            
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let destinationVC = segue.destination as? DetailViewController, let indexPath = sender as? IndexPath {
            let post = self.posts[indexPath.row]
            destinationVC.post = post
        }
     }
    
}


// MARK: - UITableViewDataSource, Delegate, Prefetch
extension ListViewController : UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for:indexPath) as? ListTableViewCell else {
           return UITableViewCell()
        }
        
        let post = self.posts[indexPath.row]
        cell.setValues(post: post)
        
        FetchImage().imageFromURL(urlString: post.image, indexPath:indexPath) { (image,indexpath) in
            if let ip = indexpath, let cell = tableView.cellForRow(at: ip) as? ListTableViewCell {
                cell.coverImage.image = image
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: MainControllers.segues.listToDetail.rawValue, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let post = self.posts[indexPath.row]
            FetchImage().imageFromURL(urlString: post.image, indexPath:indexPath) { (_,_) in
                //cache images
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalRows = tableView.numberOfRows(inSection:indexPath.section)
        if indexPath.row == totalRows - 1{
            #if DEBUG
                print("%@ more to fetch",dataCountToFetch)
            #endif
            if dataCountToFetch > 0  {
                fetchPosts()
            }
        }
    }
}
