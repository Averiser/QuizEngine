//
//  UITableViewExtension.swift
//  QuizApp
//
//  Created by MyMacBook on 26.09.2020.
//  Copyright © 2020 MyMacBook. All rights reserved.
//

import UIKit

extension UITableView {
  func register(_ type: UITableViewCell.Type) {
    let className = String(describing: type)
    register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
  }
  
  func dequeueReusableCell<T>(_ type: T.Type) -> T? {
    let className = String(describing: type)
    return dequeueReusableCell(withIdentifier: className) as? T
  }
  
}
