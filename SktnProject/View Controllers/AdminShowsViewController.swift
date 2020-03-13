//
//  AdminShowsViewController.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-03-10.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AdminShowsViewController: UIViewController {
    
    var shows = [Show]()
    var db: Firestore!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var behindTableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    func initView() {
        db = Firestore.firestore()
        loadData()
        checkForUpdates()
        mainView.addBackground()
        
        tableView.delegate = self
        tableView.dataSource = self
        behindTableView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    // Hides the navigationBar and shows the tabBar. The opposite happens in ListViewController
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    /* Get all the documents of the collection shows. Creates the every document into Show
     finally reloads the tableview the user can see the shows
     */
    func loadData() {
        db.collection("shows").getDocuments() {
            querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                self.shows = querySnapshot!.documents.compactMap({Show(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    /*
     Checks if any new shows been created and added to Firestore.
     If thats the case, TableView will be reloaded
     */
    func checkForUpdates() {
        db.collection("shows").whereField("timeStamp", isGreaterThan: Timestamp())
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        self.shows.append(Show(dictionary: diff.document.data())!)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
        }
    }
    
}

extension AdminShowsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! AdminShowsCell
        let show = shows[indexPath.row]
        
        cell.titleLabel.text = show.title
        cell.titleLabel.textAlignment = .center
        cell.dateLabel.text = show.date
        cell.titleLabel.textAlignment = .center
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
        vc?.detailShow = shows[indexPath.row].title
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

