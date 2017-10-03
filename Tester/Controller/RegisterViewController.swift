//
//  RegisterViewController.swift
//  Tester
//
//  Created by Elijah Carrington on 10/2/17.
//  Copyright © 2017 Elijah Carrington. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var handleField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    // MARK: - View Loaded
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide back button to prevent going back
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Init handle to listen for login
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = ""
        changeRequest?.commitChanges(completion: { (error) in
            
        })
    }

}
