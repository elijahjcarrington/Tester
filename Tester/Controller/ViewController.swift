//
//  ViewController.swift
//  Tester
//
//  Created by Elijah Carrington on 10/2/17.
//  Copyright © 2017 Elijah Carrington. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    var validator: Validator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        validator = Validator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Init handle to listen for login
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove handle listening for login
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        registerButton.setTitle("Loading...", for: .normal)
        
        if let email = emailField.text, let password = passwordField.text {
            
            let e = validator!.isValidEmail(email: email)
            print(e)
            
//            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//                if user != nil {
//                     self.registerButton.setTitle("Success!", for: .normal)
//                }
//            })
        }
    }
    

    
}

