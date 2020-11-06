  //
//  QuestionTest.swift
//  QuizAppTests
//
//  Created by MyMacBook on 10.10.2020.
//  Copyright © 2020 MyMacBook. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizApp
  
  class QuestionTest: XCTestCase {
    
    func test_hashValue_singleAnswer_returnsTypeHash() {
      let type = "a string"
      
      let sut = Question.singleAnswer(type)
      
      XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_hashValue_multipleAnswer_returnsTypeHash() {
      let type = "a string"
      
      let sut = Question.multipleAnswer(type)
      
      XCTAssertEqual(sut.hashValue, type.hashValue)
    }
  }
