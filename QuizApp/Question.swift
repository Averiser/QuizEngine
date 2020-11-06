//
//  Copyright © 2020 MyMacBook. All rights reserved.
//

import Foundation

enum Question<T: Hashable>: Hashable {
  case singleAnswer(T)
  case multipleAnswer(T)


var hashValue: Int {
  switch self {
  case .singleAnswer(let value):
    return value.hashValue
  case .multipleAnswer(let value):
    return value.hashValue
    }
  }

}
