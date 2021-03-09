//
//  PictureViewController.swift
//  SnapFish
//
//  Created by Mac Owner on 2/6/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class PictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    
    var uuid = NSUUID().uuidString
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        nextButton.isEnabled = false
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage
        else {
            print("No image found!")
            return
        }
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        nextButton.isEnabled = true
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera 
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        
        nextButton.isEnabled = false
        
        let imagesFolder = FIRStorage.storage().reference().child("images")
        
        
        let imageData = imageView.image!.jpegData(compressionQuality: 0.1)!
        
        
        imagesFolder.child("\(uuid).jpg").put(imageData, metadata: nil, completion: {(metadata, error) in
            print("We tried to upload!")
            if error != nil {
                print("We had an error:\(String(describing: error))")
            } else {
                
                print(metadata?.downloadURL() as Any)
                
                self.performSegue(withIdentifier: "selectusersegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let nextVC = segue.destination as! SelectUserViewController
        nextVC.imageURL = sender as! String
        nextVC.descrip = descriptionTextField.text!
        nextVC.uuid = uuid
        
    }
    

}
