//
//  RegistrationViewController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldPassword2: UITextField!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var buttonSignIn: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    @IBOutlet weak var buttonEye: UIButton!
    @IBOutlet weak var buttonEye2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideSignButtons()
        
        textFieldPassword.isSecureTextEntry = true
        buttonEye.setImage(UIImage(named: "eye"), for: .normal)
        
        textFieldPassword2.isSecureTextEntry = true
        buttonEye2.setImage(UIImage(named: "eye"), for: .normal)
    }
    
    @IBAction func buttonSignInClicked(_ sender: Any) {
        
        self.view.startActivityIndicator()
        FireBaseNetworkManager.shared.signIn(email: textFieldEmail.text!, password: textFieldPassword.text!, completionHandler: { [weak self] userID, error in
            guard let self = self else { return }
            
            self.view.stopActivityIndicator()
            guard let userID = userID else {
                self.showErrorAlert(message: error ?? "Some error occured")
                return
            }
            
            DataController.shared.userID = userID
            self.view.startActivityIndicator()
            self.checkFirstSetup(userID: userID, completionHandler: { [weak self] isFirstSetupCompleted in
                guard let self = self else { return }
                
                self.view.stopActivityIndicator()
                DataController.shared.isFirstSetupCompleted = isFirstSetupCompleted
                
                if isFirstSetupCompleted {
                    NavigationManager.shared.openNewsVC()
                } else {
                    NavigationManager.shared.openFirstSetupVC()
                }
            })
        })
    }
    
    @IBAction func buttonSignUpClicked(_ sender: Any) {
        
        if textFieldPassword.text != textFieldPassword2.text {
            self.showErrorAlert(message: "Passwords are different")
            
            textFieldPassword.text = ""
            textFieldPassword2.text = ""
            return
        }
        
        self.view.startActivityIndicator()
        FireBaseNetworkManager.shared.signUp(email: textFieldEmail.text!, password: textFieldPassword.text!, completionHandler: { [weak self] userID, error in
            guard let self = self else { return }
            
            self.view.stopActivityIndicator()
            guard let userID = userID else {
                self.showErrorAlert(message: error ?? "Some error occured")
                return
            }
            
            DataController.shared.userID = userID
            NavigationManager.shared.openFirstSetupVC()
        })
        
    }
    
    @IBAction func buttoneEyeClicked(_ sender: UIButton) {
        
        if sender == buttonEye {
            manageButtonEye(textField: textFieldPassword, button: buttonEye)
        }
        else {
            manageButtonEye(textField: textFieldPassword2, button: buttonEye2)
        }
    }
    
    @IBAction func segmentControllerChanged(_ sender: UISegmentedControl) {
        if segmentController.selectedSegmentIndex == 0 {
            
            textFieldPassword2.isHidden = false
            textFieldPassword2.isEnabled = true
            buttonEye2.isHidden = false
            buttonEye2.isEnabled = true
            
        }
        else {
            textFieldPassword2.isHidden = true
            textFieldPassword2.isEnabled = false
            buttonEye2.isHidden = true
            buttonEye2.isEnabled = false
            
            textFieldPassword2.text = ""
        }
        
        textFieldEditingChanged(nil)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any?) {
        if textFieldEmail.text!.isEmpty {
            hideSignButtons()
            return
        }
        if textFieldPassword.text!.isEmpty {
            hideSignButtons()
            return
        }
        
        if segmentController.selectedSegmentIndex == 1 {
            hideSignButtons()
            buttonSignIn.isEnabled = true
            buttonSignIn.isHidden = false
            return
        }
        if textFieldPassword2.text!.isEmpty {
            hideSignButtons()
            return
        }
        
        hideSignButtons()
        buttonSignUp.isEnabled = true
        buttonSignUp.isHidden = false
    }
    
    private func hideSignButtons() {
        buttonSignIn.isEnabled = false
        buttonSignIn.isHidden = true
        buttonSignUp.isEnabled = false
        buttonSignUp.isHidden = true
    }

    private func manageButtonEye(textField: UITextField, button: UIButton) {
        
        if textField.isSecureTextEntry {
            textField.isSecureTextEntry = false
            button.setImage(UIImage.init(named: "eye2"), for: .normal)
        }
        else {
            textField.isSecureTextEntry = true
            button.setImage(UIImage.init(named: "eye"), for: .normal)
        }
    }
    
    private func checkFirstSetup(userID: String, completionHandler: ((Bool) -> Void)? ) {
        
        FireBaseNetworkManager.shared.getUserData(userID: userID, completionHandler: { userDataModel in
            
            guard let userDataModel = userDataModel else {
                completionHandler?(false)
                return
            }
            
            if userDataModel.sources.isEmpty {
                completionHandler?(false)
                return
            }
            
            completionHandler?(true)
        })
    }
}
