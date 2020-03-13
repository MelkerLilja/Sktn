//
//  CreateViewController.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-03-10.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class CreateViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var eventView: UIStackView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var loadImageButton: UIButton!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        mainView.addBackground()
        loadImageButton.styleButton()
        saveButton.styleButton()
        titleLabel.setUnderline()
        dateLabel.setUnderline()
        errorLabel.alpha = 0
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(CreateViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateLabel.inputView = datePicker
        
        descriptionView.delegate = self
        descriptionView.text = "Write event description here"
        descriptionView.textColor = UIColor.darkGray
        descriptionView.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, h:mm a"
        dateLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func loadButtonTapped(_ sender: Any) {
        self.loadImageButton.bounce()
        getImageFromPhone()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
            
        } else {
            self.saveButton.bounce()
            let imageText = titleLabel.text!.removingWhitespaces()
            let storageRef = Storage.storage().reference().child("\(imageText).png")
            
            if let uploadData = self.showImage.image!.pngData(){
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    } else {
                        storageRef.downloadURL(completion: { (url, error) in
                            let db = Firestore.firestore()
                            db.collection("shows").document(self.titleLabel.text!).setData([
                                "title": self.titleLabel.text!,
                                "date": self.dateLabel.text!,
                                "description": self.descriptionView.text!,
                                "image": (url?.absoluteString)!,
                                "timeStamp": Timestamp()
                            ])
                        })
                        
                        let alertController = UIAlertController(title: "Success", message: "You have succesfully createt a event called: \(self.titleLabel.text!)", preferredStyle: .alert)
                        
                        let okayAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                            self.titleLabel.text = ""
                            self.dateLabel.text = ""
                            self.descriptionView.text = ""
                            self.showImage.image = nil
                            self.showImage.layer.borderWidth = 0
                        }
                        
                        alertController.addAction(okayAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                    //
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write event description here"
            textView.textColor = UIColor.darkGray
        }
    }
    
    func validateFields() -> String? {
        if titleLabel.text!.isEmpty || dateLabel.text!.isEmpty || descriptionView.text!.isEmpty || showImage.image == nil {
            
            return "Please fill in all fields and upload image."
        }
        return nil
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 0
        errorLabel.fadeIn(completion: {
            (finished: Bool) -> Void in
            self.errorLabel.fadeOut()
        })
        saveButton.shake()
    }
}


extension CreateViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func getImageFromPhone() {
        let camera = DSCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // image is our desired image
        showImage.image = image
        showImage.layer.borderWidth = 2
        showImage.layer.borderColor = UIColor.black.cgColor
        picker.dismiss(animated: true, completion: nil)
    }
}
