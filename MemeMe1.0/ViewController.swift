//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Elias Hall on 6/24/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    override func viewDidLoad() {
        

        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) //disabling camera button if camera isn't available

    }
    
    @IBAction func pickAlbumImage(_ sender: Any) { //opens album for image selection
        let pickImage = UIImagePickerController()
        pickImage.delegate = self
        pickImage.sourceType = .photoLibrary //using sourceType property to distinguish between album and camera
        present(pickImage, animated: true, completion: nil)
        
 
        }
    @IBAction func pickImageCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
        
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil) //closes image picker when image is selected

        
    }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            dismiss(animated: true, completion: nil) //closes image picker when cancel is clicked
            
        }

    
}

}
