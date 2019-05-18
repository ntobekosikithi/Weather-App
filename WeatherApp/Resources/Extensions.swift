//
//  Extensions.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/15.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//
import UIKit
import Foundation

//Date extensions
extension Date{
    func toDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let strDate = dateFormatter.string(from: (self))
        return strDate
    }
    
    func toHours() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let strDate = dateFormatter.string(from: (self))
        return strDate
    }
}

//Double extensions
extension Double{
    func toºcelsius() -> String {
        return String(format: "%.0f\("º")",self)
    }
    
    func toZeroDecimal() -> String {
        return  String(format: "%.0f",self)
    }
}

//UIColor extensions
extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars.flatMap { [$0, $0] }
            fallthrough
        case 6:
            chars = ["F","F"] + chars
            fallthrough
        case 8:
            alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
            red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
            green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
            blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        default:
            return nil
        }
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}

//UIView extensions
extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}

//UIViewController extensions
extension UIViewController {
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showActivityIndicatory() {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0);
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.tag = 111
        self.view.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func hideActivityIndicatory() {
        if let actInd = self.view.viewWithTag(111) {
            actInd.removeFromSuperview()
        }
    }
}

//UITableView extensions
extension UITableView {
    func register<T: UITableViewCell & ReusableView & NibView>(_: T.Type) {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerHeader<T: UITableViewHeaderFooterView & ReusableView & NibView>(_: T.Type){
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell & ReusableView>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableHeader<T: UITableViewHeaderFooterView & ReusableView>() -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Unable to dequeue header with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}

//String extensions
extension   String {
    func toFullDate() -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:self)!
        return date
    }
    
    func toWeatherDescription() -> String {
        switch self {
        case "clear", "clear sky", "haze":
            return "Sunny"
        case "rain", "moderate rain", "light rain":
            return "Rainy"
        case "clouds", "broken clouds", "few clouds":
            return "Cloudy"
        default:
            return "Cloudy"
        }
    }
    
    func color() -> String {
        switch self {
        case "clear", "clear sky", "haze":
            return "47AB3F"
        case "rain", "moderate rain", "light rain":
            return "57575D"
        case "clouds", "broken clouds", "few clouds":
            return "54717A"
        default:
            return "54717A"
        }
    }
}

