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

    var game: Game<Question<String>, [String], NavigationControllerRouter>?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()

        let question1 = Question.singleAnswer("What´s Mike's nationalty?")
        let question2 = Question.multipleAnswer("What are Caio's nationalities")
        let questions = [question1, question2]

        let option11 = "Canadian"
        let option12 = "American"
        let option13 = "Greek"
        let options1 = [option11, option12, option13]
        
        let option21 = "Brazilian"
        let option22 = "American"
        let option23 = "Portuguese"
        let options2 = [option21, option22, option23]

        let correctAnswers = [question1: [option13], question2: [option21, option23]]

        let factory = iOSViewControllerFactory(
            questions: questions,
            options: [question1: options1, question2: options2],
            correctAnswers: correctAnswers)

        let router = NavigationControllerRouter(
            navigationController,
            factory: factory)

        game = startGame(questions: questions, router: router, correctAnswers: correctAnswers)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

