//
//  ProfileViewController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class ProfileViewController: WithLeftMenuViewController {

    @IBOutlet weak var buttonSave: UIBarButtonItem!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var cityPicker: UIPickerView!
    
    var userDataModel: UserDataModel!
    
    let countries = [
        ["Украина", "Ukraine"],
        ["Польша", "Poland"],
        ["Германия", "Germany"]
    ]
    
    let cities = [
        [
            ["Киев", "Kiev"],
            ["Харьков", "Kharkiv"],
            ["Днепр", "Dnipropetrovsk"],
            ["Львов", "Lviv"]
        ],
        [
            ["Варшава", "Warsaw"],
            ["Краков", "Krakow"],
            ["Лодзь", "Lodz"],
            ["Познань", "Poznan"]
        ],
        [
            ["Берлин", "Berlin"],
            ["Мюнхен", "Munich"],
            ["Кельн", "Cologne"],
            ["Гамбург", "Hamburg"]
        ]
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textFieldPassword.text?.removeAll()
    
        guard let userID = DataController.shared.userID else { return }
        
        view.startActivityIndicator()
        FireBaseNetworkManager.shared.getUserData(userID: userID, completionHandler: { [weak self] (userDataModel: UserDataModel?) in
            guard let self = self else { return }
            
            self.view.stopActivityIndicator()
            guard let userDataModel = userDataModel else { return }
            
            self.userDataModel = userDataModel
            self.setData()
        })
    }
    
    @IBAction func buttonEyeClicked(_ sender: UIButton) {
        
        if textFieldPassword.isSecureTextEntry {
            textFieldPassword.isSecureTextEntry = false
            sender.setImage(UIImage.init(named: "eye2"), for: .normal)
            return
        }
        
        textFieldPassword.isSecureTextEntry = true
        sender.setImage(UIImage.init(named: "eye"), for: .normal)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        if textFieldPassword.text!.isEmpty {
            buttonSave.isEnabled = false
            return
        }
        if textFieldFirstName.text!.isEmpty {
            buttonSave.isEnabled = false
            return
        }
        if textFieldLastName.text!.isEmpty {
            buttonSave.isEnabled = false
            return
        }
        if textFieldMobileNumber.text!.isEmpty {
            buttonSave.isEnabled = false
            return
        }
        
        buttonSave.isEnabled = true
    }
    
    @IBAction func buttonSaveClicked(_ sender: Any) {
        
        updateUserData(successHandler: { [weak self] in
            guard let self = self else { return }
            
            self.updatePassword(successHandler: { [weak self] in
                guard let self = self else { return }
                
                self.showSuccessAlert(message: "All your data was successfully updated")
            })
        })
    }
    
    private func setData() {
        self.textFieldFirstName.text = userDataModel.firstName
        self.textFieldLastName.text = userDataModel.lastName
        self.textFieldMobileNumber.text = userDataModel.mobileNumber
        
        if !userDataModel.country.isEmpty {
            guard let row = countries.firstIndex(where: { $0[0] == userDataModel.country }) else { return }
            
            countryPicker.selectRow(row, inComponent: 0, animated: false)
        }
        
        if !userDataModel.city.isEmpty {
            guard let row = cities[countryPicker.selectedRow(inComponent: 0)].firstIndex(where: { $0[0] == userDataModel.country }) else { return }
            
            cityPicker.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    private func updateUserData(successHandler: (() -> Void)? ) {
        if userDataModel == nil { return }
        guard let userID = DataController.shared.userID else { return }
        
        userDataModel.firstName = textFieldFirstName.text!
        userDataModel.lastName = textFieldLastName.text!
        userDataModel.mobileNumber = textFieldMobileNumber.text!
        userDataModel.country = countries[countryPicker.selectedRow(inComponent: 0)][0]
        userDataModel.countryENG = countries[countryPicker.selectedRow(inComponent: 0)][1]
        userDataModel.city = cities[countryPicker.selectedRow(inComponent: 0)][cityPicker.selectedRow(inComponent: 0)][0]
        userDataModel.cityENG = cities[countryPicker.selectedRow(inComponent: 0)][cityPicker.selectedRow(inComponent: 0)][1]
        
        view.startActivityIndicator()
        FireBaseNetworkManager.shared.updateUserData(userID: userID, userData: userDataModel, completionHandler: { [weak self] error in
            guard let self = self else { return }
            
            self.view.stopActivityIndicator()
            if let error = error {
                self.showErrorAlert(message: error)
                return
            }
            
            successHandler?()
        })
    }
    
    private func updatePassword(successHandler: (() -> Void)? ) {
        
        view.startActivityIndicator()
        FireBaseNetworkManager.shared.updatePassword(newPassword: self.textFieldPassword.text!, completionHandler: { [weak self] error in
            guard let self = self else { return }
            
            self.view.stopActivityIndicator()
            
            if let error = error {
                self.showErrorAlert(message: error)
                return
            }
            
            successHandler?()
        })
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPicker {
            return countries.count
        }
        else {
            return cities[countryPicker.selectedRow(inComponent: 0)].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == countryPicker {
            let country = countries[row][0]
            return country
        }
        else {
            let city = cities[countryPicker.selectedRow(inComponent: 0)][row][0]
            return city
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPicker {
            cityPicker.reloadAllComponents()
        }
    }
}
