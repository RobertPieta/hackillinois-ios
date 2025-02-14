//
//  AppDelegate.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 4/16/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import UIKit
import CoreLocation
import UserNotifications
import HIAPI
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var obfuscatedApiKey: [UInt8] = [92, 213, 228, 193, 244, 27, 239, 139, 188, 14, 85, 191, 47, 237, 55, 13, 85, 89, 111, 212, 35, 80, 45, 104, 189, 229,
                                   33, 32, 70, 63, 90, 163, 173, 232, 167, 90, 203, 22, 169, 29, 156, 158, 160, 167, 98,
                                   174, 239, 247, 118, 96, 207, 104, 180, 14, 90, 58, 61, 89, 186, 89, 7, 114, 25, 255, 141,
                                   115, 113, 117, 78, 10, 150, 197, 161, 158, 98, 129, 87, 228]
    // Handle remote notification registration.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let user = HIApplicationStateController.shared.user else { return }
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

        // Send the token to notifications server
        AnnouncementService.sendToken(deviceToken: token)
            .onCompletion { result in
                do {
                    _ = try result.get()
                } catch {
                    print(error)
                }
            }
            .authorize(with: user)
            .launch()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBarAppearance()
        setupTableViewAppearance()
        _ = HIThemeEngine.shared
        _ = HICoreDataController.shared
        _ = HILocalNotificationController.shared
        GMSServices.provideAPIKey(String(bytes: obfuscatedApiKey.deobfuscated, encoding: .utf8)!)
        HIApplicationStateController.shared.initalize()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        do {
            try HICoreDataController.shared.viewContext.save()
        } catch {
            print(error)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        do {
            try HICoreDataController.shared.viewContext.save()
        } catch {
            print(error)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.registerForRemoteNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        do {
            try HICoreDataController.shared.viewContext.save()
        } catch {
            print(error)
        }
    }
}

// MARK: - Appearance Customization
extension AppDelegate {
    func setupNavigationBarAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.titleTextAttributes = [
            NSAttributedString.Key.font: HIAppearance.Font.navigationTitle as Any,
            NSAttributedString.Key.foregroundColor: (\HIAppearance.titleText).value as Any
        ]
        navigationBarAppearace.shadowImage = UIImage()
        navigationBarAppearace.isTranslucent = false
    }

    func setupTableViewAppearance() {
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.separatorStyle = .none
        tableViewAppearance.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
        tableViewAppearance.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNonzeroMagnitude, height: CGFloat.leastNonzeroMagnitude))
        tableViewAppearance.showsHorizontalScrollIndicator = false
    }
}
