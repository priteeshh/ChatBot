//
//  MFAViewController.swift
//  ChatBotApp
//
//  Created by Oneview Infosys on 05/02/19.
//  Copyright © 2019 Oneview Infosys. All rights reserved.
//

import Foundation

import AWSCognitoIdentityProvider

class MFAViewController: UIViewController {
    
    var destination: String?
    var mfaCodeCompletionSource: AWSTaskCompletionSource<NSString>?
    
    @IBOutlet weak var sentTo: UILabel!
    @IBOutlet weak var confirmationCode: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sentTo.text = "Code sent to: \(self.destination!)"
        self.confirmationCode.text = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // perform any action, if required, once the view is loaded
    }
    
    @IBAction func signIn(_ sender: AnyObject) {
        // check if the user is not providing an empty authentication code
        guard let authenticationCodeValue = self.confirmationCode.text, !authenticationCodeValue.isEmpty else {
            let alertController = UIAlertController(title: "Authentication Code Missing",
                                                    message: "Please enter the authentication code you received by E-mail / SMS.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion:  nil)
            return
        }
        self.mfaCodeCompletionSource?.set(result: authenticationCodeValue as NSString)
    }
    
}

// MARK :- AWSCognitoIdentityMultiFactorAuthentication delegate

extension MFAViewController : AWSCognitoIdentityMultiFactorAuthentication {
    
    func didCompleteMultifactorAuthenticationStepWithError(_ error: Error?) {
        DispatchQueue.main.async(execute: {
            if let error = error as NSError? {
                
                let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                        message: error.userInfo["message"] as? String,
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion:  nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func getCode(_ authenticationInput: AWSCognitoIdentityMultifactorAuthenticationInput, mfaCodeCompletionSource: AWSTaskCompletionSource<NSString>) {
        self.mfaCodeCompletionSource = mfaCodeCompletionSource
        self.destination = authenticationInput.destination
    }
    
}
