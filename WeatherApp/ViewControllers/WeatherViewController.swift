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
    var identifier:String = "forecastCell"
    var forecastHeaderViewIdentifier:String = "forecastHeaderViewTableViewCell"
    var administrativeArea: String!
    var isFetchingData:Bool!
    var forecastWeather:forecast?
    var currentWeather:weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addProgressIndicator()
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
            WeatherAPIClient.currentWeather(latitude: String(lat), longitude: String(lon), completion: { weather in
                switch weather {
                case .success(let weather):
                    self.currentWeather = weather
                    self.lbldegrees.text = weather.main.current.toºcelsius()
                    self.lblweatherDescription.text = weather.weather[0].description.toWeatherDescription().uppercased()
                    DispatchQueue.main.async {
                       self.backgroundImage.image = UIImage(named: weather.weather[0].description.toWeatherDescription().lowercased())
                        self.view.backgroundColor = UIColor(hexString: weather.weather[0].description.color().lowercased())
                        self.tableView.backgroundColor = UIColor(hexString: weather.weather[0].description.color().lowercased())
                    }
                    self.view.dismissProgress()
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            });
            
            // Get the 5 day weather forecast
            WeatherAPIClient.forecast(latitude: String(lat), longitude: String(lon), completion: { results in
                self.isFetchingData = false
                switch results {
                case .success(let forecast):
                    self.forecastWeather = forecast
                    self.view.dismissProgress()
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.denied
        {
            self.view.dismissProgress()
            presentAlertWithTitle(title: "WeatherApp", message: "Please go to settings and allow the app to access your location", options: "Settings") { (option)  in
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
        let nib = UINib(nibName: forecastHeaderViewIdentifier, bundle: nil)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: forecastHeaderViewIdentifier)
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
        let cell: forecastTableViewCell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? forecastTableViewCell)!
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
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: forecastHeaderViewIdentifier) as! forecastHeaderViewTableViewCell
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

