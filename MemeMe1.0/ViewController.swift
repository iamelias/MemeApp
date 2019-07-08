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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    var bottomIndicator:String = "" // needed to have only bottom textbar cause slide up
    var originalPhoto: UIImage! //storing original non-meme image
    
    override func viewDidLoad() {
        topText.text = "TOP" //defualt top text
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [ // text attributes
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -10,
        ]

        topText.defaultTextAttributes = memeTextAttributes //setting topText and bottomText default attributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        bottomText.text = "BOTTOM" //default bottom text
    
        super.viewDidLoad()
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shareButton.isEnabled = false // shareButton is initally deactive
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera) //disabling camera button if camera isn't available
        if originalPhoto != nil { //activating shareButton if image is on view
            shareButton.isEnabled = true
        }

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
    @IBAction func cancelButton(_ sender: Any) { //when cancel button is selected...
        imagePickerView.image = nil //resetting image
        shareButton.isEnabled = false // disabling sharebutton
        viewDidLoad() //resetting text 
    }
    
    
    @IBAction func pickImageCamera(_ sender: Any) { //using camera to get image
        let pickImage = UIImagePickerController()
        pickImage.delegate = self
        pickImage.sourceType = .camera
        present(pickImage, animated: true, completion: nil)
    }
        
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            self.originalPhoto = image//storing image in property for save method
            dismiss(animated: true, completion: nil) //closes image picker when image is selected
            
        }
    }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            dismiss(animated: true, completion: nil) //closes image picker when cancel is clicked
            
        }
    
      func textFieldDidBeginEditing(_ textField: UITextField) { //clears textfield when tapped
        if textField == self.topText {
            print("Top Text Field Pressed")
        }
        else if textField == self.bottomText {
            print("Bottom Text Field Pressed")
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
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat { //getting keyboard size
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        
        return keyboardSize.cgRectValue.height
    }
    
        
    @objc func keyboardWillShow(_ notification:Notification) { // when keyboard appears
        
        if bottomIndicator == "BOTTOM" { //only shifts view up if bottom view selected
            view.frame.origin.y -= getKeyboardHeight(notification) //shifting view up out of keyboard's way
            bottomIndicator = ""
        }
    }
        
    @objc func keyboardWillHide(_ notification:Notification) { //shifting view back to normal when keyboard is gone
            view.frame.origin.y = 0
        
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool { //dismisses keyboard with return
        textfield.resignFirstResponder()
        return true
    }

    
    func generateMemedImage() -> UIImage { // creating meme
        
        topNavBar.isHidden = true // removing both navbar and tool bar from meme pic
        bottomToolBar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topNavBar.isHidden = false //bringing back navbar and toolbar after meme is created
        bottomToolBar.isHidden = false
        return memedImage // returning to shareButton method
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let finishedMeme = generateMemedImage() //generating memedImage for share/save
       
        let activityController = UIActivityViewController(activityItems: [finishedMeme], applicationActivities: nil) // creating UIActivityController instance, passing finished Meme
        self.present(activityController, animated: true, completion: nil) //presenting ActivityViewController
        
        //calling save meme when share has successfully completed
        activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                self.save(finishedMeme) //passing finished Meme to be saved
            }
            else {
                print("Didn't save")
            }
        }
        
            }
    
    func save(_ memedImage: UIImage) { //saving meme to instance of Meme Struct
       
        let meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalPhoto, memedImage: memedImage)
        }
        
    }

 struct Meme { //using struct to save data in meme instance in the View Controller's save function
 var topText: UITextField
 var bottomText: UITextField
 var originalImage: UIImage
 var memedImage: UIImage
 
 init(topText: UITextField, bottomText: UITextField, originalImage: UIImage, memedImage: UIImage) {
 
 self.topText = topText
 self.bottomText = bottomText
 self.originalImage = originalImage
 self.memedImage = memedImage
 
 
    }
 
 
 
 }
 
 
 


