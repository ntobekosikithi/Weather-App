//
//  WeatherViewController.swift.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/13.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import iProgressHUD

class WeatherViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var lblweatherDescription: UILabel!
    @IBOutlet weak var lbldegrees: UILabel!
    var locationManager: CLLocationManager!
    var administrativeArea: String!
    var isFetchingData:Bool!
    var forecastWeather = forecast()
    var currentWeather = weather()
    var WeatherClient = WeatherAPIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showActivityIndicatory()
        self.setUpView()
        self.setupLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - location delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        if !self.isFetchingData {
            self.isFetchingData = true
            WeatherClient.current(weatherData: .getCurrentWeather, lat: String(lat), lon: String(lon)) { results in
                switch results {
                case .success(let weatherResults):
                    guard let weatherResult = weatherResults else { return }
                    self.currentWeather = weatherResult
                    self.lbldegrees.text = self.currentWeather?.main.current.toºcelsius()
                    self.lblweatherDescription.text = self.currentWeather?.weather[0].description.toWeatherDescription().uppercased()
                    DispatchQueue.main.async {
                        self.backgroundImage.image = UIImage(named: (self.currentWeather?.weather[0].description.toWeatherDescription().lowercased())!)
                        self.view.backgroundColor = UIColor(hexString: (self.currentWeather?.weather[0].description.color().lowercased())!)
                        self.tableView.backgroundColor = UIColor(hexString: (self.currentWeather?.weather[0].description.color().lowercased())!)
                    }
                    self.tableView.reloadData()
                case .failure(let error):
                    print("the error \(error)")
                }
            }
            // Get the 5 day weather forecast
            WeatherClient.forecast(weatherData: .getForecast, lat: String(lat), lon: String(lon)) { results in
                self.isFetchingData = false
                switch results {
                case .success(let forecast):
                    self.forecastWeather = forecast
                    self.hideActivityIndicatory()
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.denied
        {
            self.view.dismissProgress()
            presentAlertWithTitle(title: "WeatherApp", message: constants.errorLocation, options: "Settings") { (option)  in
                switch(option) {
                case 0:
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl)
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    func setupLocation(){
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func addProgressIndicator(){
        let iprogress: iProgressHUD = iProgressHUD()
        iprogress.attachProgress(toViews: self.view)
        iprogress.isShowModal = true
        view.updateCaption(text: "")
        self.view.updateIndicator(style:.lineScale)
        self.view.showProgress()
    }
    
    func setUpView(){
        self.tableView.registerHeader(forecastHeaderView.self)
        self.tableView.register(forecastTableViewCell.self)
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        if Connectivity.isConnected() {
            self.isFetchingData = false
        }else{
            self.isFetchingData = true
            self.view.dismissProgress()
        }
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        self.isFetchingData = true
        locationManager.startUpdatingLocation()
        let locValue: CLLocationCoordinate2D = self.locationManager.location!.coordinate
        return locValue
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecastWeather == nil ? 0:(self.forecastWeather?.list.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(forIndexPath: indexPath) as forecastTableViewCell
        let forecast = self.forecastWeather!.list[indexPath.row] as weather
        let date = forecast.date?.toFullDate()
        let currentDate = Date()
        if date?.toDay() != currentDate.toDay() && date?.toHours() == "12:00" {
            let currentWeather = self.currentWeather!.weather[0] as description
            cell.lblDay.text = date!.toDay()
            cell.lblDegrees.text = forecast.main.current.toºcelsius()
            cell.forecastIcon.image = UIImage(named: (forecast.weather[0].description.toWeatherDescription().lowercased())+"_icon")
            cell.backgroundColor = UIColor(hexString: currentWeather.description.color().lowercased())
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeader() as forecastHeaderView
        let description = self.currentWeather?.weather[0].description
        header.lblMinTemp.text = self.currentWeather?.main.min.toºcelsius()
        header.lblCurrentTemp.text = self.currentWeather?.main.current.toºcelsius()
        header.lblMaxTemp.text = self.currentWeather?.main.max.toºcelsius()
        if description != nil{
            header.currentWeatherView.addBottomBorderWithColor(color: .white, width: CGFloat(1.0))
            header.contentView.backgroundColor = UIColor(hexString: (description?.color().lowercased())!)
        }
        header.layer.masksToBounds = false
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let forecast = self.forecastWeather?.list[indexPath.row]
        let date = forecast?.date?.toFullDate()
        let currentDate = Date()
        if date?.toDay() != currentDate.toDay() && date?.toHours() == "12:00" {
            return 50
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
}

