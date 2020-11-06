//
//  Copyright © 2020 MyMacBook. All rights reserved.
//

import UIKit
import QuizEngine
  
protocol ViewControllerFactory {
  func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
  
  func resultsViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}
  
