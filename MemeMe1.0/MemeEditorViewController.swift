//
//  ViewController.swift
//  MemeMe 2.0
//
//  Created by Elias Hall on 6/24/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit


class memeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    
    //  var bottomIndicator:String = "" // needed to have only bottom textbar cause slide up
    var originalPhoto: UIImage! //storing original non-meme image
    
    override func viewDidLoad() {
        
        configureTextfield(textfield: topText, defaultText: "TOP")
        configureTextfield(textfield: bottomText, defaultText: "BOTTOM")
        
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
    
    func configureTextfield(textfield: UITextField, defaultText: String) {
        textfield.delegate = self
        
        let memeTextAttributes: [NSAttributedString.Key: Any] = [ // text attributes
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -10,
        ]
        
        textfield.defaultTextAttributes = memeTextAttributes //setting topText's and bottomText's default attributes
        
        textfield.textAlignment = .center
        
        textfield.text = defaultText //making default "TOP" and "BOTTOM"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func pickAlbumImage(_ sender: Any) { //when album button is selected
        pickImageWith(sourceType: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickCameraImage(_ sender: Any) { //when camera button is selected
        pickImageWith(sourceType: UIImagePickerController.SourceType.camera)
    }
    
    func pickImageWith(sourceType: UIImagePickerController.SourceType) { //opens album/camera for image pick
        let pickImage = UIImagePickerController() //picking image
        pickImage.delegate = self
        pickImage.sourceType = sourceType
        present(pickImage, animated:true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            self.originalPhoto = image//storing image in property for save method
            dismiss(animated: true, completion: nil) //closes image picker when image is selected
            
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) { //when main view cancel button is selected
//        imagePickerView.image = nil //resetting image
//        shareButton.isEnabled = false // disabling sharebutton
//        viewDidLoad() //resetting text
        self.dismiss(animated: true, completion: nil) //added dismiss

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //when imagepicker cancel selected
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) { //clears textfield when tapped
        
        if textField.isFirstResponder {
            if textField.text == "TOP" || textField.text == "BOTTOM" {
                textField.text = ""
            }
        }
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
        
        if bottomText.isFirstResponder { //only shifts view up if bottom view selected
            view.frame.origin.y -= getKeyboardHeight(notification) //shifting view up out of keyboard's way
            //bottomIndicator = ""
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
                self.save(finishedMeme) //passing finished Meme to be save
            }
            else {
                print("Didn't save")
            }
        }
    }
    
    func save(_ memedImage: UIImage) { //saving meme to instance of Meme Struct
        
        
        let meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalPhoto, memedImage: memedImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
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





