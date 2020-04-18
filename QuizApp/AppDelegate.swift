//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Jero Sánchez on 17/04/2020.
//  Copyright © 2020 Jero Sánchez. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let vc = QuestionViewController(question: "A question", options: ["Option 1", "Option 2", "Option 3"]) { print($0) }
        vc.loadViewIfNeeded()
//        vc.tableView.allowsMultipleSelection = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
}

