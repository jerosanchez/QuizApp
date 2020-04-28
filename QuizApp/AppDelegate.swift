//
//  AppDelegate.swift
//  QuizApp
//
//  Created by Jero Sánchez on 17/04/2020.
//  Copyright © 2020 Jero Sánchez. All rights reserved.
//

import UIKit
import QuizEngine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()

//        let question1 = Question.singleAnswer("What´s Mike nationalty?")
//        let questions = [question1]
//
//        let option1 = "Canadian"
//        let option2 = "American"
//        let option3 = "Greek"
//        let options = [option1, option2, option3]
//
//        let correctAnswers = [question1: [option3]]
//
//        let factory = iOSViewControllerFactory(
//            questions: questions,
//            options: [question1: options],
//            correctAnswers: correctAnswers)
//
//        let router = NavigationControllerRouter(
//            navigationController,
//            factory: factory)
//
//        startGame(questions: questions, router: router, correctAnswers: correctAnswers)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

