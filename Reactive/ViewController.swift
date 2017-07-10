//
//  ViewController.swift
//  Reactive
//
//  Created by Bryan Gula on 7/10/17.
//  Copyright © 2017 Gula, Inc. All rights reserved.
//

import UIKit
import ReactiveJSON
import ReactiveSwift
import Result


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var userCollectionView: UICollectionView!
    @IBOutlet var postTableView: UITableView!
    
    var users = [User]()
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.rowHeight = UITableViewAutomaticDimension
        postTableView.estimatedRowHeight = 90
        
        loadPosts()
        loadUsers()
    }
    
    func loadPosts() {
        ReactiveModel.request(endpoint: "posts")
            .startWithResult { (result: Result<[[String:Any]], NetworkError>) in
                
                for post in result.value! {
                    let id = post["id"] as! Int
                    let title = post["title"] as! String
                    let body = post["body"] as! String
                    self.posts.append(Post(id: id, title: title, body: body))
                }
                
                DispatchQueue.main.async {
                    self.postTableView.reloadData()
                }
            }
    }
    
    func loadUsers() {
        ReactiveModel.request(endpoint: "users")
            .startWithResult { (result: Result<[[String:Any]], NetworkError>) in
                
                for post in result.value! {
                    let id = post["id"] as! Int
                    let name = post["name"] as! String
                    let username = post["username"] as! String
                    let email = post["email"] as! String

                    self.users.append(User(id: id, name: name, username: username, email: email))
                }
                
                DispatchQueue.main.async {
                    self.userCollectionView.reloadData()
                }
        }
    }
    
    //  MARK: UICollectionView Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! UserCell
        let user = self.users[indexPath.row]
        
        cell.usernameLabel.text = user.username
        
        return cell
    }
    
    //  MARK: UICollectionView Flow Layout Delgate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.height * 2 - 10, height: collectionView.bounds.height - 10)
    }
    
    //  MARK: UITableView Data Source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        cell.titleLabel.text = post.title
        cell.secondaryLabel.text = post.body
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    //  MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //  MARK: Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destiniation = segue.destination as! DetailViewController
        
        if segue.identifier == "showUser" {
            let index = self.userCollectionView.indexPath(for: sender as! UserCell)
            let user = users[index!.row]
            destiniation.topTitle = user.username
            destiniation.subject = user.name
            destiniation.subtitle = user.email
            destiniation.details = ""
            destiniation.loadComments = false
            
        } else if segue.identifier == "showComments" {
            let index = self.postTableView.indexPath(for: sender as! PostCell)
            let post = posts[index!.row]
            destiniation.topTitle = "Comments"
            destiniation.subject = post.title
            destiniation.subtitle = post.body
            destiniation.details = ""
            destiniation.loadComments = true
        }
    }
}

class UserCell : UICollectionViewCell {
    
    @IBOutlet var usernameLabel: UILabel!
}

class PostCell : UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
    
}
