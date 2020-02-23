//
//  WeatherViewController.swift
//  NewsApp
//
//  Created by Nazar NAUMENKO on 1/1/20.
//  Copyright © 2019 Nazar NAUMENKO. All rights reserved.
//

import UIKit

class WeatherViewController: WithLeftMenuViewController {

    @IBOutlet weak var labelNameCityCountry: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    @IBOutlet weak var labelWindDirection: UILabel!
    @IBOutlet weak var labelPressure: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var imageCondition: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var weatherModel: WeatherModel?
    var userDataModel: UserDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelNameCityCountry.text = ""
        labelTemperature.text = ""
        labelWindSpeed.text = ""
        labelWindDirection.text = ""
        labelPressure.text = ""
        labelHumidity.text = ""
        imageCondition.image = nil
        
        guard let userID = DataController.shared.userID else { return }
        
        view.startActivityIndicator()
        FireBaseNetworkManager.shared.getUserData(userID: userID, completionHandler: { [weak self] userDataModel in
            guard let self = self else { return }
            
            self.view.stopActivityIndicator()
            self.userDataModel = userDataModel
            print("OK")
            self.getCurrentWeather()
        })
    }
}


extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let weatherModel = weatherModel else { return 0 }
        
        return weatherModel.forecast.forecastday.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let weatherModel = weatherModel else { return UICollectionViewCell() }
        guard let forecastDay = weatherModel.forecast.forecastday[safe: indexPath.row] else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell else { return UICollectionViewCell() }
        
        let urlString = "https://" + String(forecastDay.day.condition.icon.dropFirst(2))
        cell.imageCondition.imageFromURL(urlString: urlString, completionHandler: nil)

        cell.labelDate.text = forecastDay.date
        cell.labelMinTemp.text = String(forecastDay.day.mintemp_c) + "°C"
        cell.labelMaxTemp.text = String(forecastDay.day.maxtemp_c) + "°C"
        
        cell.backView.layer.borderWidth = 1
        cell.backView.layer.cornerRadius = cell.backView.frame.height / 10
        cell.backView.layer.borderColor = UIColor.black.cgColor
        cell.backView.layer.masksToBounds = true
        
        return cell
    }
}

extension WeatherViewController {
    
    private func getCurrentWeather() {
        guard let userDataModel = userDataModel else { return }
        
        if userDataModel.cityENG.isEmpty {
            self.showErrorAlert(message: "There is no city in your profile")
            return
        }
        
        let stringURL = CONSTANTS.WEATHER_API_URL + "&query=\(userDataModel.cityENG)+\(userDataModel.countryENG)&days=9"
        
        NetworkManager.shared.sendGETRequestResponseModel(stringURL: stringURL, completionHandler: { [weak self] (weatherModel: WeatherModel?) in
            guard let self = self else { return }
            
            self.weatherModel = weatherModel
            self.collectionView.reloadData()
            
            guard let weatherModel = weatherModel else { return }
            
            self.labelNameCityCountry.text = weatherModel.location.country + " " + weatherModel.location.region + " " + weatherModel.location.name
            self.labelTemperature.text = "Temperature(°C): " + String(weatherModel.current.temp_c)
            self.labelWindSpeed.text = "Wind speed(km/h): " + String(weatherModel.current.wind_kph)
            self.labelWindDirection.text = "Wind direction: " + weatherModel.current.wind_dir
            self.labelPressure.text = "Pressure(millibar): " + String(weatherModel.current.pressure_mb)
            self.labelHumidity.text = "Humidity(%): " + String(weatherModel.current.humidity)
            
            let urlString = "https://" + String(weatherModel.current.condition.icon.dropFirst(2))
            self.imageCondition.imageFromURL(urlString: urlString, completionHandler: nil)
        })
    }
}

