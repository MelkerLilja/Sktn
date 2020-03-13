//
//  ShowsViewController.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-02-26.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//
import Foundation
import UIKit
import FirebaseFirestore

class ShowsViewController: UIViewController {
    
    @IBOutlet weak var viewBehindTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var mainView: UIView!
    
    var shows = [Show]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    func initView() {
        mainView.addBackground()
        
        db = Firestore.firestore()
        loadData()
        //self.tableView.contentInsetAdjustmentBehavior = .never
        //shows = createArray()
        
        viewBehindTableView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    // Hides the navigationBar and shows the tabBar. The opposite happens in DetailShowViewController
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
}

extension ShowsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom") as! ShowsCell
        let show = shows[indexPath.row]
        
        let url = URL(string: show.image)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                cell.showImageView?.image = UIImage(data: data!)
            }
        }
        cell.showImageView.layer.borderWidth = 2
        cell.showImageView.layer.borderColor = UIColor.black.cgColor
        cell.showTitleLabel.text = show.title
        cell.showTitleLabel.textAlignment = .center
        cell.showDescriptionLabel.text = show.date
        
        cell.selectionStyle = .none
        return cell
    }
    // Transfers the user to DetailShowVC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailShowViewController") as? DetailShowViewController
        vc?.detailShow = shows[indexPath.row].title
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
