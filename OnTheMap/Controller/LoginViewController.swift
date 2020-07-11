//
//  ViewController.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/3/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: OnTheMapTextField!
    @IBOutlet weak var passwordTextField: OnTheMapTextField!
    @IBOutlet weak var loginButton: OnTheMapButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func loginTapped(_ sender: Any) {
        setLogginIn(true)
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }

    func handleLoginResponse(success: Bool,error: Error?) {
        setLogginIn(false)
        if success {
            UdacityClient.getUserInfo { (success, error) in
                if success {
                    print("User information has been loaded successfully")
                }
            }
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showFailureMessage(message: error?.localizedDescription ?? "", title: "Login Failed")
        }
    }
    
    func setLogginIn(_ logginIn: Bool) {
        if logginIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !logginIn
        passwordTextField.isEnabled = !logginIn
        loginButton.isEnabled = !logginIn
        signUpButton.isEnabled = !logginIn
    }

}

