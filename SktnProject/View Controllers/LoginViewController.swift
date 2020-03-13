//
//  ViewController.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-02-24.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.addBackground()
        errorLabel.alpha = 0
        loginButton.styleButton()
        emailField.setTextFieldWithIconAndBorder(fsSymbol: "envelope")
        passwordField.setTextFieldWithIconAndBorder(fsSymbol: "lock")
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        // Validate textfields
        
        // Create cleaned versions of the textfields
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Login in user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error == nil {
                // Get the type from the database. It's path is users/<userId>/type.
                // docRef are fetching the reference for type through real time, cache didn't work
                self.loginButton.bounce()
                let docRef = Firestore.firestore().collection("users").document(result!.user.uid)
                
                docRef.getDocument(source: .server) { (document, error) in
                    if let document = document {
                        let property = document.get("type")
                        
                        switch property as! String{
                        case "admin":
                            // ...redirect to the admin page
                            let vc = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.adminVC) as? AdminTabBar
                            
                            self.view.window?.rootViewController = vc
                            self.view.window?.makeKeyAndVisible()
                            
                        case "user":
                            // ...redirect to the user page
                            let vc = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.userVC) as? UserTabBar
                            UserTabBar.userUid = result!.user.uid
                            
                            self.view.window?.rootViewController = vc
                            self.view.window?.makeKeyAndVisible()
                            
                        default:
                            print("Document does not exist in cache")
                        }
                        
                    }
                }
            } else {
                self.errorLabel.text = error?.localizedDescription
                self.errorLabel.alpha = 0
                self.errorLabel.fadeIn(completion: {
                    (finished: Bool) -> Void in
                    self.errorLabel.fadeOut()
                })
                self.loginButton.shake()
            }
        }
    }
    
}
