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
        
        let vc = ResultViewController(summary: "You got 1/2 correct", answers: [
            PresentableAnswer(question: "One question", answer: "Oh, yeah!", wrongAnswer: nil),
            PresentableAnswer(question: "Another question", answer: "Oh, yeah", wrongAnswer: "Hell, no!")
        ])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
}

