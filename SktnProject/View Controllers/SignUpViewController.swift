//
//  SignUpViewController.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-02-25.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        mainView.addBackground()
        signUpButton.styleButton()
        firstNameField.setTextFieldWithIconAndBorder(fsSymbol: "person")
        lastNameField.setTextFieldWithIconAndBorder(fsSymbol: "person.2")
        emailField.setTextFieldWithIconAndBorder(fsSymbol: "envelope")
        passwordField.setTextFieldWithIconAndBorder(fsSymbol: "lock")
    }
    
    //Checks the fields and validates that the data is correct. If correct it returns nil. Otherwise, returns error message
    func validateFields() -> String? {
        if firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        let cleanedEmail = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isValidEmail(cleanedEmail) == false {
            
            return "Please make sure your email is correct"
        }
        
        return nil
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            // Create clean versions of the data
            let firstName = firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    // There was an error creating the user
                    self.showError("Error creating user")
                } else {
                    // User was created, store first name and last name
                    self.signUpButton.bounce()
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData([
                        "firstname": firstName,
                        "lastname": lastName,
                        "type": "user",
                        "uid": result!.user.uid
                    ]) { (error) in
                        
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                    }
                    // Transition to the home screen
                    self.transitionToHome(uid: result!.user.uid)
                }
            }
        }
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        self.errorLabel.alpha = 0
        self.errorLabel.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.errorLabel.fadeOut()
        })
        self.signUpButton.shake()
        
    }
    
    func transitionToHome(uid: String) {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.userVC) as? UserTabBar
        UserTabBar.userUid = uid
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
