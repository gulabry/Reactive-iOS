//
//  DetailViewController.swift
//  Reactive
//
//  Created by Bryan Gula on 7/10/17.
//  Copyright © 2017 Gula, Inc. All rights reserved.
//

import UIKit
import ReactiveJSON
import ReactiveSwift
import Result

class DetailViewController: UIViewController, UITableViewDataSource {

    var topTitle : String?
    var subject : String?
    var subtitle : String?
    var details : String?
    
    var comments = [Comment]()
    var loadComments = false
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    @IBOutlet var commentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupComments()
    }
    
    func setupView() {
        titleLabel.text = topTitle!
        subjectLabel.text = subject!
        subtitleLabel.text = subtitle!
        detailLabel.text = details!
    }
    
    func setupComments() {
        if loadComments {
            
            commentTableView.isHidden = false

            ReactiveModel.request(endpoint: "comments")
                .startWithResult { (result: Result<[[String:Any]], NetworkError>) in
                    
                    for post in result.value! {
                        let id = post["id"] as! Int
                        let name = post["name"] as! String
                        let body = post["body"] as! String
                        let email = post["email"] as! String

                        self.comments.append(Comment(id: id, name: name, email: email, body: body))
                    }
                    
                    DispatchQueue.main.async {
                        self.commentTableView.reloadData()
                    }
            }
        } else {
            commentTableView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //  MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.row]
        
        cell.commentTitle.text = comment.name
        cell.commentSubtitle.text = comment.body
        
        return cell
    }
}

class CommentCell : UITableViewCell {
    
    @IBOutlet var commentTitle: UILabel!
    @IBOutlet var commentSubtitle: UILabel!
}
