//
//  PhoneHandler.swift
//  SktnProject
//
//  Created by Melker Lilja on 2020-03-09.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import MobileCoreServices
import UIKit

class DSCameraHandler: NSObject {
    
    private let imagePicker = UIImagePickerController()
    private let isPhotoLibraryAvailable = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    private let isSavedPhotoAlbumAvailable = UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
    
    var delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate
    init(delegate_: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        delegate = delegate_
    }
    
    func getPhotoLibraryOn(_ onVC: UIViewController, canEdit: Bool) {
        
        if !isPhotoLibraryAvailable && !isSavedPhotoAlbumAvailable { return }
        let type = kUTTypeImage as String
        
        if isPhotoLibraryAvailable {
            imagePicker.sourceType = .photoLibrary
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                if availableTypes.contains(type) {
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
            
            imagePicker.sourceType = .savedPhotosAlbum
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                if availableTypes.contains(type) {
                    imagePicker.mediaTypes = [type]
                }
            }
        } else {
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = delegate
        onVC.present(imagePicker, animated: true, completion: nil)
    }
}
