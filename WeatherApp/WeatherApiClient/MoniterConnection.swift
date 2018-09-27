//
//  MoniterConnection.swift
//  WeatherApp
//
//  Created by Ntobeko on 2018/09/24.
//  Copyright © 2018 ntobekosikithi. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    class func startMonitoringNetwork() {
        let network = NetworkReachabilityManager()
        network?.startListening()
        
        network?.listener = { status in
            if network?.isReachable ?? false {
                
                switch status {
                case .notReachable:
                    print("alert the user")
                case .unknown:
                    print("alert the user about slow connection")
                case .reachable(.ethernetOrWiFi):
                    print("Start network services")
                case .reachable(.wwan):
                    print("Start network services")
                }
            }
            
        }
    }
}
