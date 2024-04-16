//
//  FormViewController.swift
//  TestApp
//
//  Created by Sudeepa Pal on 16/04/24.
//

import UIKit

class FormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView: UIImageView!
    var uploadButton: UIButton!
    var longitudeTextField: UITextField!
    var latitudeTextField: UITextField!
    var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Create an image view to display the selected image
        imageView = UIImageView(frame: CGRect(x: 20, y: 100, width: 200, height: 200))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        // Create text fields for longitude and latitude
                longitudeTextField = UITextField(frame: CGRect(x: 20, y: 320, width: 200, height: 40))
                longitudeTextField.placeholder = "Longitude"
                longitudeTextField.keyboardType = .numbersAndPunctuation
                longitudeTextField.borderStyle = .roundedRect
                view.addSubview(longitudeTextField)
                
                latitudeTextField = UITextField(frame: CGRect(x: 20, y: 370, width: 200, height: 40))
                latitudeTextField.placeholder = "Latitude"
                latitudeTextField.keyboardType = .numbersAndPunctuation
                latitudeTextField.borderStyle = .roundedRect
                view.addSubview(latitudeTextField)
                
                // Create a button to trigger image selection
                uploadButton = UIButton(type: .system)
                uploadButton.frame = CGRect(x: 20, y: 420, width: 200, height: 40)
                uploadButton.setTitle("Upload Image", for: .normal)
                uploadButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
                view.addSubview(uploadButton)
        
        // Create a submit button
                submitButton = UIButton(type: .system)
                submitButton.frame = CGRect(x: 20, y: 470, width: 200, height: 40)
                submitButton.setTitle("Submit", for: .normal)
                //submitButton.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
                view.addSubview(submitButton)
        
        
    }
    
    @objc func uploadImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera // Set source type to camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


