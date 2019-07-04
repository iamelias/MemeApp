//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Elias Hall on 6/24/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
var activeTextField: UITextField!
    var bottomIndicator:String = "" // To prevent moveview with topText
    
    override func viewDidLoad() {
        
        topText.text = "TOP" //predefining the top text label
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -10,
        ]

        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        bottomText.text = "BOTTOM" //initializing the bottom text label
    
        super.viewDidLoad()
        self.topText.delegate = self
        self.bottomText.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) //disabling camera button if camera isn't available
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
    }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            dismiss(animated: true, completion: nil) //closes image picker when cancel is clicked
            
        }
  //**************************************
      func textFieldDidBeginEditing(_ textField: UITextField) { //clears textfield when tapped
        activeTextField = textField
        if textField == self.topText {
            print("Top Text Field Pressed")
        }
        else if textField == self.bottomText {
            print("Bottom Text Field Pressed")
            print(textField)
            bottomIndicator = "BOTTOM"
        }
        if textField.text == "TOP" { //If text is default text... text field clears when tapped
            textField.text = "" }
            else if textField.text == "BOTTOM"
            {  textField.text = "" }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
        func subscribeToKeyboardNotifications() { //notification of when keyboard will appear
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            //notification of when keyboard will dissapear
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
        }
        
        func unsubscribeFromKeyboardNotifications() {
             NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        
        return keyboardSize.cgRectValue.height
    }
    
        
    @objc func keyboardWillShow(_ notification:Notification) { // called by notification
        
        if bottomIndicator == "BOTTOM" {
            view.frame.origin.y -= getKeyboardHeight(notification)
            self.bottomIndicator = ""
        }
    }
        
    @objc func keyboardWillHide(_ notification:Notification) { // called by notification
            view.frame.origin.y = 0
        
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool { //dismisses keyboard with return
        textfield.resignFirstResponder()
        return true
    }
    
    /*
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
 */
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
 
    
}





