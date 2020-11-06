//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by MyMacBook on 23.09.2020.
//  Copyright © 2020 MyMacBook. All rights reserved.
//

import UIKit
import QuizEngine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
   var window: UIWindow?
  
  var game: Game<Question<String>, [String], NavigationControllerRouter>?

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  
  let question1 = Question.singleAnswer("What's Mike's nationality?")
  let question2 = Question.multipleAnswer("What are Caio's nationalities?")
  let questions = [question1, question2]
  
  let option1 = "Canadian"
  let option2 = "American"
  let option3 = "Greek"
  let options1 = [option1, option2, option3]
  
  let option4 = "Portuguese"
  let option5 = "American"
  let option6 = "Brazilian"
  let options2 = [option4, option5, option6]
  
  let correctAnswers = [question1: [option3], question2: [option4, option6]]
  
  let navigationController = UINavigationController()
  let factory = iOSViewControllerFactory(questions: questions, options: [question1: options1, question2: options2], correctAnswers: correctAnswers)
  
  let router = NavigationControllerRouter(navigationController, factory: factory)
  
  window = UIWindow(frame: UIScreen.main.bounds)
  window?.rootViewController = navigationController
  window?.makeKeyAndVisible()
  
  game = startGame(questions: questions, router: router, correctAnswers: correctAnswers)
          
  return true
}
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let windowScene = (scene as? UIWindowScene) else { return }

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.windowScene = windowScene



    let viewController = ResultsViewController(summary: "You got 1/2 correct", answers: [
        PresentableAnswer(question: "Question?? Question?? Question?? Question?? Question??", answer: "Yeah! Yeah! Yeah! Yeah! Yeah! Yeah!Yeah! Yeah! Yeah!", wrongAnswer: nil),
        PresentableAnswer(question: "Another Question??", answer: "Hell yeah!", wrongAnswer: "Hell no!")
    ])

//    let window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = viewController
//    self.window = window
    window?.makeKeyAndVisible()
  }
}


