//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by MyMacBook on 16.09.2020.
//  Copyright © 2020 MyMacBook. All rights reserved.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  private(set) var question = ""
  private(set) var options = [String]()
  private(set) var allowsMultipleSelection = false
  private var selection: (([String]) -> Void)? = nil
  private let reuseIdentifier = "Cell"
  
  convenience init(question: String, options: [String], allowsMultipleSelection: Bool,   selection: @escaping ([String]) -> Void) {
    self.init()
    self.question = question
    self.options = options
    self.allowsMultipleSelection = allowsMultipleSelection
    self.selection = selection
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelection = allowsMultipleSelection
    headerLabel.text = question
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = dequeueCell(in: tableView)
    cell.textLabel?.text = options[indexPath.row]
    return cell   
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selection?(selectedOptions(in: tableView))
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if tableView.allowsMultipleSelection {
      selection?(selectedOptions(in: tableView))
    }
  }
  
  private func selectedOptions(in tableView: UITableView) -> [String] {
    guard let indexPaths = tableView.indexPathsForSelectedRows else {
      return []
    }
    return indexPaths.map { options[$0.row] }
  }
  
  private func dequeueCell(in tableView: UITableView) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) {
      return cell
    }
    return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
  }
}
