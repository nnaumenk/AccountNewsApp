//
//  SetUpViewController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SetUpViewController: UIViewController {
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonNext: UIButton!
    
    var flagDatePickedChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.maximumDate = Date()
    }
    
    @IBAction func datePickedValueChanged(_ sender: Any) {
        flagDatePickedChanged = true
        textFieldEditingChanged(sender)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        if textFieldFirstName.text!.isEmpty {
            buttonNext.isEnabled = false
            return
        }
        if textFieldLastName.text!.isEmpty {
            buttonNext.isEnabled = false
            return
        }
        if textFieldMobileNumber.text!.isEmpty {
            buttonNext.isEnabled = false
            return
        }
        if flagDatePickedChanged == false {
            buttonNext.isEnabled = false
            return
        }
        
        buttonNext.isEnabled = true
    }
    
    @IBAction func buttonNextClicked(_ sender: Any) {
        
        guard let userID = DataController.shared.userID else { return }
        let userData = initUsetDataModel()
        
        FireBaseNetworkManager.shared.createUserData(userID: userID, userData: userData, completionHandler: { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showErrorAlert(message: error)
                return
            }
            
            DataController.shared.isFirstSetupCompleted = true
            NavigationManager.shared.openNewsVC()
        })
    }
    
    private func initUsetDataModel() -> UserDataModel {
        
        let sources = [
            UserDataSourceModel(name: "BBC Sport", id: "bbc-sport"),
            UserDataSourceModel(name: "The Telegraph", id: "the-telegraph"),
            UserDataSourceModel(name: "Time", id: "time"),
            UserDataSourceModel(name: "ESPN", id: "espn"),
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MMMM.yyyy"
        
        let userData = UserDataModel(
            firstName: textFieldFirstName.text!,
            lastName: textFieldLastName.text!,
            mobileNumber: textFieldMobileNumber.text!,
            birhday: dateFormatter.string(from: datePicker.date),
            country: "",
            countryENG: "",
            city: "",
            cityENG: "",
            sources: sources
        )
        
        return userData
    }
}
