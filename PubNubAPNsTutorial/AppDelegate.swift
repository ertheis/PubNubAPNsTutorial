//
//  AppDelegate.swift
//  PubNub Data Stream Tutorial
//
//  Created by Eric Theis on 6/26/14.
//  Copyright (c) 2014 PubNub. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNDelegate, UIAlertViewDelegate {
                            
    var window: UIWindow?
    var dToken: NSData = NSData()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        println("launchOptions")
        if(UIDevice.currentDevice().systemVersion.substringToIndex(1).toInt() >= 8){
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: (UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound), categories: nil))
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound | UIRemoteNotificationType.Alert)
        }
        
        PubNub.setDelegate(self)
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("DELEGATE: Device Token is: \(deviceToken)")
        self.dToken = deviceToken
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("DELEGATE: Failed to get token, error: \(error)")
        self.dToken = NSData()
    }
    
    //This method shouldn't need to exist, but apple broke the initializer for UIAlertViews in iOS 8...
    func setupAlert(message: String) -> UIAlertView {
        var alertView = UIAlertView()
        alertView.title = message
        alertView.message = "Sent Via PubNub Mobile Gateway!"
        alertView.addButtonWithTitle("Dismiss")
        return alertView
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: NSDictionary) {
        var alert: AnyObject? = userInfo.objectForKey("aps")
        var alertView:UIAlertView
        if let message = alert as? String {
            alertView = setupAlert(message)
            alertView.show()
        } else if let message = alert as? NSDictionary {
            alertView = setupAlert(message.objectForKey("alert") as String)
            alertView.show()
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func pubNubClient(client: PubNub!, didEnablePushNotificationsOnChannels channels: Array<PNChannel>!) {
        println("DELEGATE: Enabled push notifications on channels: \(channels)")
    }
    
    func pubnubClient(client: PubNub!, didReceivePushNotificationEnabledChannels channels: Array<PNChannel>!) {
        println("DELEGATE: Received push notifications for these enabled channels: \(channels)")
    }
    
    func pubnubClient(client: PubNub!, pushNotificationEnableDidFailWithError error: PNError!) {
        println("DELEGATE: Failed push notification enable. error: \(error)")
    }
    
    func pubnubClient(client: PubNub!, didDisablePushNotificationsOnChannels channels: Array<PNChannel>) {
        println("DELEGATE: Disabled push notifications on channels: \(channels)")
    }
    
    func pubnubClient(client: PubNub!, pushNotificationDisableDidFailWithError error: PNError!) {
        println("DELEGATE: Failed to disable push notifications because of error: \(error)")
    }
    
    func pubnubClientDidRemovePushNotifications(client: PubNub!)
    {
        println("DELEGATE: Removed push notifications from all channels")
    }
    
    func pubnubClient(client: PubNub!, pushNotificationsRemoveFromChannelsDidFailWithError error: PNError!) {
        println("DELEGATE: Failed remove push notifications from channels because of error: \(error)")
    }
    
    func pubnubClient(client: PubNub!, pushNotificationEnabledChannelsReceiveDidFailWithError error: PNError!) {
        println("DELEGATE: Failed to receive list of channels because of error: \(error)")
    }
    
    func pubnubClient(client: PubNub!, didConnectToOrigin origin: String!) {
        println("DELEGATE: Connected to origin \(origin)")
    }
    
    func pubnubClient(client: PubNub!, didSubscribeOnChannels channels: Array<PNChannel>!) {
        println("DELEGATE: Subscribed to channel(s): \(channels[0])")
    }
    
    func pubnubClient(client: PubNub!, didUnsubscribeOnChannels channels: Array<PNChannel>!) {
        println("DELEGATE: Unsubscribed from channel(s): \(channels[0])")
    }
    
    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!) {
        println("DELEGATE: Message received.")
    }
    
    func pubnubClient(client: PubNub!, didSendMessage message: PNMessage!) {
        println("DELEGATE: client sent message: \(message.message)")
    }
}

