//
//  LoginViewController.swift
//  SnapFish
//
//  Created by Jay Beaudoin on 2021-03-04.
//  Copyright © 2021 Jay. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            self.performSegue(withIdentifier: "signinsegue", sender: nil)
            
            let userEmail = FIRAuth.auth()?.currentUser?.email as! String
            print("Signed in as " + userEmail)
        }
    else
        {
            return
            
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        
        
    }
    
    @IBAction func turnupTapped(_ sender: UIButton) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            let userEmail = FIRAuth.auth()?.currentUser?.email as! String
            let username = self.userTextField.text!
            let password = self.passwordTextField.text!
            
            print("We tried to sign in")
            if error != nil {
                print("Hey we have an error:\(String(describing: error))")
                
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("We tried to create a user")
                        
                        if error != nil {
                            print("Hey we have an error:\(String(describing: error))")
                        } else {
                            print("Created " + userEmail + " successfully!")
                            
                        FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                            FIRDatabase.database().reference().child("users").child(user!.uid).child("username").setValue(username)
                            FIRDatabase.database().reference().child("users").child(user!.uid).child("password").setValue(password)
                            
                            self.performSegue(withIdentifier: "signinsegue", sender: nil)
                            
                    }
                    
                })
                
                
            } else {
                
                
                print("Signed in Successfully as " + userEmail)
                
                self.performSegue(withIdentifier: "signinsegue", sender: nil)
                
            }
            
            
        })
        
        
    }
    
    

}
