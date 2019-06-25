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

    override func viewDidLoad() {
        

        super.viewDidLoad()
    }

    @IBAction func pickAlbumImage(_ sender: Any) { //opens album for image selection
        let pickImage = UIImagePickerController()
        pickImage.delegate = self
        present(pickImage, animated: true, completion: nil)
        
 
        }
        
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        
    }
    
}

}
