//
//  ViewController.swift
//  Tester
//
//  Created by Elijah Carrington on 10/2/17.
//  Copyright © 2017 Elijah Carrington. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var validator: Validator?
    var completeSignUp: Bool?
    
    // MARK: - View Loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup username/password validator
        validator = Validator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.stopAnimating()
        
        // Init handle to listen for login
        handle = Auth.auth().addStateDidChangeListener({ (_, _) in
            
        })
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
    
    // MARK: - Navigation

    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        continueButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        validateSignup { (valid) in
            if valid {
                self.performSegue(withIdentifier: "showRegisterViewController", sender: nil)
                self.activityIndicator.stopAnimating()
            } else {
                self.continueButton.setTitle("Continue", for: .normal)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func validateSignup(completion: @escaping(Bool) -> Void) {
        
        var validUsername: String?
        var validEmail: String?
        var validPassword: String?
        
        guard let validator = validator else {
            return
        }
        
        // Validate username is long enough
        if let username = usernameField.text {
            if validator.isValidUsername(username: username) {
                validUsername = username
                usernameLabel.textColor = UIColor.green
            } else {
                validUsername = nil
                usernameLabel.textColor = UIColor.red
            }
        }
        
        // Validate email uses @site.com
        if let email = emailField.text {
            if validator.isValidEmail(email: email) {
                validEmail = email
                emailLabel.textColor = UIColor.green
            } else {
                validEmail = nil
                emailLabel.textColor = UIColor.red
            }
        }
        
        // Validate password matches and is long enough
        if let password = passwordField.text, let confirm = confirmField.text {
            if validator.isValidPassword(password: password, confirm: confirm) {
                validPassword = password
                passwordLabel.textColor = UIColor.green
                confirmLabel.textColor = UIColor.green
            } else {
                validPassword = nil
                passwordLabel.textColor = UIColor.red
                confirmLabel.textColor = UIColor.red
            }
        }
        
        // Create user if both email and password are valid
        if validEmail != nil && validPassword != nil && validUsername != nil {
            Auth.auth().createUser(withEmail: validEmail!, password: validPassword!, completion: { (user, error) in
                
                if user != nil {
                    validEmail = nil
                    validPassword = nil
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = validUsername!
                        changeRequest?.commitChanges(completion: { (error) in
                        if error == nil {
                            // Dispatch call on main thread
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        }
                    })
                
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            })
        } else {
            completion(false)
        }
    }
}

