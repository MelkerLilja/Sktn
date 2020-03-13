//
//  ListViewController.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-03-12.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var viewBehindTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var detailShow: String = ""
    var db: Firestore!
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    func initView() {
        mainView.addBackground()
        db = Firestore.firestore()
        loadData()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        viewBehindTableView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    // Gets information for all who attends to the specific show
    func loadData() {
        db.collection(detailShow).getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.users = querySnapshot!.documents.compactMap({User(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
        let user = users[indexPath.row]
        cell.userNameLabel.text = "\(user.firstname) \(user.lastname)"
        cell.selectionStyle = .none
        return cell
    }
    
    // Headersection to display the Title for the show
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width, height: 25))
        vw.backgroundColor = UIColor.clear
        label.textColor = .black
        label.text = detailShow
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        vw.addSubview(label)
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
}
