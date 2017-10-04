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
    @IBOutlet weak var usernameCheck: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailCheck: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCheck: UILabel!
    
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var confirmCheck: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var handle: AuthStateDidChangeListenerHandle?
    var fieldValidator: FieldValidator?
    var completeSignUp: Bool?
    
    var checkYes = "👍", checkNo = "👎", checkNone = ""
    
    // MARK: - View Loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup user field validator
        fieldValidator = FieldValidator()
        
        // Clear all checks to start
        emailCheck.text = checkNone
        usernameCheck.text = checkNone
        passwordCheck.text = checkNone
        confirmCheck.text = checkNone
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.stopAnimating()
        
        // Init handle to listen for login
        handle = Auth.auth().addStateDidChangeListener({ (_, _) in })
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
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: "elijahjcarrington@gmail.com", password: "123456") { (user, error) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "skipToPostTableController", sender: nil)
            }
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        continueButton.setTitle("", for: .normal)
        activityIndicator.startAnimating()
        
        validateSignup { (valid) in
            if valid {
                self.performSegue(withIdentifier: "showPostTableController", sender: nil)
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
        
        guard let validator = fieldValidator else {
            return
        }
        
        // Validate username is long enough
        if let username = usernameField.text {
            if validator.isValidUsername(username: username) {
                validUsername = username
                usernameCheck.text = checkYes
            } else {
                validUsername = nil
                usernameCheck.text = checkNo
            }
        }
        
        // Validate email uses @site.com
        if let email = emailField.text {
            if validator.isValidEmail(email: email) {
                validEmail = email
                emailCheck.text = checkYes
            } else {
                validEmail = nil
                emailCheck.text = checkNo
            }
        }
        
        // Validate password matches and is long enough
        if let password = passwordField.text, let confirm = confirmField.text {
            if validator.isValidPassword(password: password, confirm: confirm) {
                validPassword = password
                passwordCheck.text = checkYes
                confirmCheck.text = checkYes
            } else {
                validPassword = nil
                passwordCheck.text = checkNo
                confirmCheck.text = checkNo
            }
        }
        
        // Guard that all fields are filled in
        guard let email = validEmail, let password = validPassword, let username = validUsername else {
            completion(false)
            return
        }
        
        // Create user based on email and password
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            guard let user = user else {
                completion(false)
                return
            }
            
            if error != nil {
                // Check for sign up errors from callback
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        completion(false)
                        self.emailCheck.text = self.checkNo
                    case .invalidEmail:
                        completion(false)
                        self.emailCheck.text = self.checkNo
                    case .weakPassword:
                        completion(false)
                        self.passwordCheck.text = self.checkNo
                    default:
                        completion(false)
                        break
                    }
                }
            } else {
                
                // Create the user's display name
                let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = username
                    changeRequest.commitChanges(completion: { (error) in
                        
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
            }
        })
    }
}

