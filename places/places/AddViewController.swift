//
//  AddViewController.swift
//  places
//
//  Created by Wojciech Pratkowiecki on 06.01.2018.
//  Copyright © 2018 Wojciech Pratkowiecki. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: Properties
    var placeName = ""
    var imagePickerController : UIImagePickerController!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var placeDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeLabel.text = placeName
        placeDescription.delegate = self
        // Do any additional setup after loading the view.
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        placePhoto.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    
    //MARK: Utils
    func photoSource()
    {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            self.openCamera()
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)

    }
        
        func openCamera()
        {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
            {
                imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                present(imagePickerController, animated: true, completion: nil)
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "Could not access the camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        func openGallery()
        {
            imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    
    //MARK: Actions

    @IBAction func addButton(_ sender: UIButton) {
        guard let newPlace = Place(name: placeName, photo: placePhoto.image, placeDescription: placeDescription.text)
            else{
                fatalError("Unable to create place")
        }
        places.append(newPlace)
    }
    
    @IBAction func selectImageFromLib(_ sender: UITapGestureRecognizer) {
        placeDescription.resignFirstResponder()
        self.photoSource()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
