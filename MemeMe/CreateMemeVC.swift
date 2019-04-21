//
//  ViewController.swift
//  MemeMe
//
//  Created by aziz on 02/04/2019.
//  Copyright © 2019 Aziz. All rights reserved.

import UIKit

class CreateMemeVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imagePickeView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    override var prefersStatusBarHidden: Bool { return true}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        
        setTitle(textField: topLabel)
        setTitle(textField: bottomLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    func setTitle(textField: UITextField){
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    //MARK: Pick images and share
    func openImagePicker(type: UIImagePickerController.SourceType){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = type
        present(pickerController, animated: true)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        
        openImagePicker(type: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        
        openImagePicker(type: .camera)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        let image = generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityView.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed){
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityView, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            imagePickeView.image = image
            imagePickeView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Keyboard setup
    func getKeyboardHieght(notification: Notification) -> CGFloat{
        
        let userInformation = notification.userInfo
        let keyboardSize = userInformation![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(notification: Notification){
        if (bottomLabel.isEditing){
        view.frame.origin.y -= getKeyboardHieght(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Save and generate the meme
    func save() {
        
        let meme = Meme(topText: topLabel.text!, bottomText: bottomLabel.text!, originalImage: imagePickeView.image!, memedImage: generateMemedImage())
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        hideToolBars(hide: true)

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolBars(hide: false)
        return memedImage
    }
    
    func hideToolBars(hide: Bool){
        
        navigationBar.isHidden = hide
        toolBar.isHidden = hide
    }
}

//MARK: Extension for the text field delegate
extension CreateMemeVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.clearsOnBeginEditing = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
