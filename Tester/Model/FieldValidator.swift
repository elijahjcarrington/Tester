//
//  Validator.swift
//  Tester
//
//  Created by Elijah Carrington on 10/2/17.
//  Copyright © 2017 Elijah Carrington. All rights reserved.
//

import Foundation
import FirebaseAuth

struct FieldValidator {
    
    func isValidEmail(email:String) -> Bool {
        
        // Ensure input is an email
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let matchesRegEx = NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
        return matchesRegEx
    }
    
    func isValidUsername(username: String) -> Bool {
        
        // Trim any whitespace in username
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check that username is between 4 and 16 chars
        if (4...16 ~= trimmedUsername.characters.count) {
            return true
        } else {
            return false
        }
    }
    
    func isValidPassword(password: String, confirm : String) -> Bool {
        
        // Trim any whitespace in fields
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirm = confirm.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check that password is between 6 and 64 chars
        if (6...64 ~= trimmedPassword.characters.count && 6...64 ~= trimmedConfirm.characters.count) {
            if password == confirm {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
