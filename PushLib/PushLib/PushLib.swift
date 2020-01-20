//
//  PushLib.swift
//  PushLib
//
//  Created by 株式会社シナブル on 2019/09/13.
//  Copyright © 2019 株式会社シナブル. All rights reserved.
//

import UserNotifications
import Firebase
import FirebaseMessaging
import Alamofire

@objc public class PushLib: NSObject, UIApplicationDelegate {
    
    var count = 1
    
    @objc public func setBadgeCount(count:Int){
        self.count = count
    }
    
    @objc public func setUpPush(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /**************************** Push service start *****************************/
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        return true
        
        // iOS 13 support
        if #available(iOS 13, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerForRemoteNotifications()
            
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        /***************************** Push service end ******************************/
        return true
    }
    
    // Called when APNs has assigned the device a unique token
    @objc public func makeToken(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    // Called when APNs failed to register the device for push notifications
    @objc public func registerFail(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
 
    // Push notification received
    @objc public func receiveMessage(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any], fetchCompletionHandler: @escaping(UIBackgroundFetchResult)->Void) {
        // Print notification payload data
        print("Push notification received: \(data)")
        count += 1
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    
    func sendRegistrationToServer(_ token: String) {
        let parameters = [
            "id": "javaBarista",
            "Token": token,
            "Platform": "iOS"
        ]
        
        Alamofire.request("https://nobles1030.cafe24.com/register.php", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["Content-Tyle":"application/json", "Accept":"application/json"]).validate(statusCode: 200..<300).responseJSON{(response) in if let JSOn = response.result.value {
            print(JSOn)
            }
        }
    }
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

extension PushLib: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("\(#function)")
        
        completionHandler([.alert, .sound])
    }
}

extension PushLib: MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        sendRegistrationToServer(fcmToken)
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

