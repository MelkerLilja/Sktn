//
//  DetailShowViewController.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-03-11.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DetailShowViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var attendButton: UIButton!
    
    
    var db: Firestore!
    var detailShow: String = ""
    var userUid: String = ""
    var shows: Show?
    var user: User?
    var isAttending = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
    }
    
    func initView() {
        userUid = UserTabBar.userUid
        mainView.addBackground()
        db = Firestore.firestore()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        showLabel.text = detailShow
        loadData()
        loadUser()
        checkIfUserIsAttending()
        
        descriptionView.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
    
    /*
     Checks if the user is attending or not the a event. If attending the UI for the button attend will change
     */
    func checkIfUserIsAttending() {
        
        let docRef = db.collection("\(detailShow)").document("\(userUid)")
        docRef.getDocument(source: .server) { (document, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isAttending = false
                    self.notAttendingUI()
                    print("\(error.localizedDescription)")
                }
            } else {
                if let document = document {
                    if document.data() != nil {
                        self.isAttending = true
                        DispatchQueue.main.async {
                            self.attendingUI()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.isAttending = false
                            self.notAttendingUI()
                        }
                    }
                    
                }
            }
        }
    }
    
    func loadData() {
        
        // Get selected Show from firestore
        let docRef = db.collection("shows").document("\(detailShow)")
        docRef.getDocument(source: .server) { (document, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                if let document = document {
                    guard let data = document.data() else { return }
                    let show = Show(dictionary: data)
                    guard show != nil else { return }
                    self.shows = show
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                }
            }
        }
    }
    
    func attendingUI() {
        self.attendButton.setTitle("Don't attend to show",for: .normal)
    }
    
    func notAttendingUI() {
        self.attendButton.setTitle("Attend to show!",for: .normal)
    }
    
    func loadUser() {
        // Get user info from firestore
        
        let docRef = db.collection("users").document("\(userUid)")
        docRef.getDocument(source: .server) { (document, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                if let document = document {
                    guard let data = document.data() else { return }
                    let user = User(dictionary: data)
                    guard user != nil else { return }
                    self.user = user
                }
            }
        }
    }
    // Updates the UI when loaddata() have passed correctly
    func updateUI() {
        self.showLabel.text = self.shows?.title
        self.dateLabel.text = self.shows?.date
        self.descriptionView.text = self.shows?.description
        guard let imageUrl = self.shows?.image else { return }
        let url = URL(string: imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.showImage.image = UIImage(data: data!)
                self.showImage.layer.borderWidth = 2
                self.showImage.layer.borderColor = UIColor.black.cgColor
            }
        }
        self.attendButton.styleButton()
    }
    // Attends the user to the specific show. Collection is the show, and the documents will be the users
    @IBAction func attendButtonTapped(_ sender: Any) {
        if isAttending == false {
            let db = Firestore.firestore()
            db.collection("\(detailShow)").document("\(userUid)").setData([
                "firstname": self.user?.firstname ?? "no firstname",
                "lastname": self.user?.lastname ?? "no lastname",
                "type": self.user?.type ?? "no type",
                "uid": self.user?.uid ?? "no uid"
            ])
            self.isAttending = true
            self.attendButton.bounce()
            self.attendingUI()
        } else {
            let db = Firestore.firestore()
            db.collection("\(detailShow)").document("\(userUid)").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    self.isAttending = false
                    self.attendButton.bounce()
                    self.notAttendingUI()
                }
            }
        }
    }
}
