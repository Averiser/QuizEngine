//
//  Copyright © 2020 MyMacBook. All rights reserved.
//

import UIKit
import XCTest
@testable import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTest: XCTestCase {
  
  let singleAnswerQuestion = Question.singleAnswer("Q1")
  let multipleAnswerQuestion = Question.multipleAnswer("Q2")
  
  let navigationController = NonAnimatedNavigationController()
  let factory = ViewControllerFactoryStub()
  lazy var sut: NavigationControllerRouter = {
      return NavigationControllerRouter(self.navigationController, factory: self.factory) }()
  
  func test_routeToQuestion_showsQuestionController() {
    let viewController = UIViewController()
    let secondViewController = UIViewController()

    factory.stub(question: singleAnswerQuestion, with: viewController)
    factory.stub(question: multipleAnswerQuestion, with: secondViewController)
    
    sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in })
    sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in })
    
    XCTAssertEqual(navigationController.viewControllers.count, 2)
    XCTAssertEqual(navigationController.viewControllers.first, viewController)
    XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
  }
  
  func test_routeToQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {
    var callbackWasFired = false
    sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in callbackWasFired  = true })
    factory.answerCallback[singleAnswerQuestion]!(["anything"])
    
    XCTAssertTrue(callbackWasFired)
  }
  
  func test_routeToQuestion_singleAnswer_doesNotConfigureViewControllerWithSubmitButton() {
    let viewController = UIViewController()
    factory.stub(question: Question.singleAnswer("Q1"), with: viewController)
    
    sut.routeTo(question: Question.singleAnswer ("Q1"), answerCallback: { _ in })
    
    XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
  }
  
  func test_routeToQuestion_multipleAnswer_answerCallback_doesNotProgressToNextQuestion() {
    var callbackWasFired = false
    sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in callbackWasFired = true })
    factory.answerCallback[multipleAnswerQuestion]!(["anything"])
    
    XCTAssertFalse(callbackWasFired)
  }
  
  func test_routeToQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
    let viewController = UIViewController()
    factory.stub(question: multipleAnswerQuestion, with: viewController)
    
    sut.routeTo(question: multipleAnswerQuestion  , answerCallback: { _ in })
    
    XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
  }
  
  func test_routeToQuestion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswersSelected() {
    let viewController = UIViewController()
    factory.stub(question: multipleAnswerQuestion, with: viewController)
    
    sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in })
    XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    
    factory.answerCallback[multipleAnswerQuestion]!(["A1"])
    XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    
    factory.answerCallback[multipleAnswerQuestion]!([])
    XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
  }
  
  func test_routeToQuestion_multipleAnswerSubmitButton_progressesToNextQuestion() {
    let viewController = UIViewController()
    factory.stub(question: multipleAnswerQuestion, with: viewController)
    
    var callbackWasFired = false
    sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in callbackWasFired = true} )
    
    factory.answerCallback[multipleAnswerQuestion]!(["A1"])
    viewController.navigationItem.rightBarButtonItem?.simulateTap()

    XCTAssertTrue(callbackWasFired)
  }
  
  func test_routeToResult_showsResultController() {
    let viewController = UIViewController()
    let result = Result.make(answers: [singleAnswerQuestion: ["A1"]], score: 10)
    
    let secondViewController = UIViewController()
    let secondResult = Result.make(answers: [singleAnswerQuestion: ["A2"]], score: 20)

    factory.stub(result: result, with: viewController)
    factory.stub(result: secondResult, with: secondViewController)

    sut.routeTo(result: result)
    sut.routeTo(result: secondResult) 
    
    XCTAssertEqual(navigationController.viewControllers.count, 2)
    XCTAssertEqual(navigationController.viewControllers.first, viewController)
    XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
  }
  
  // MARK: Helpers
  
    class NonAnimatedNavigationController: UINavigationController {
      override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
      }
    }
  
  class ViewControllerFactoryStub: ViewControllerFactory {
    
    private var stubbedQuestions = Dictionary<Question<String>, UIViewController>()
    private var stubbedResults = Dictionary<Result<Question<String>, [String]> , UIViewController>()
    var answerCallback = Dictionary<Question<String>, ([String])  -> Void>()
    
    func stub(question: Question<String>, with viewController: UIViewController) {
      stubbedQuestions[question] = viewController
    }
    
    func stub(result: Result<Question<String>, [String]>, with viewController: UIViewController) {
      stubbedResults[result] = viewController
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
      self.answerCallback[question] = answerCallback
      return stubbedQuestions[question] ?? UIViewController()
    }
    func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
      return stubbedResults[result] ?? UIViewController()
    }
  }
}
  
private extension UIBarButtonItem {
  func simulateTap() {
    target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
  }
}
