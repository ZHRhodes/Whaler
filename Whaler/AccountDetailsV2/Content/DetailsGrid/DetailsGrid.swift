//
//  DetailsGrid.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

struct DetailItem {
  let image: UIImage
  let description: String
  let value: String
  var showBottomLine: Bool = true
  var showRightLine: Bool = true
}

class DetailsGrid: UIView {
  private var stackView: UIStackView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.borderLineColor.cgColor
    layer.cornerRadius = 10.0
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with details: [DetailItem]) {
    var arrangedSubviews = [UIView]()
    for pair in details.unfoldSubSequences(limitedTo: 2) {
      arrangedSubviews.append(makeRowStack(with: pair))
    }
    
    stackView?.removeFromSuperview()
    stackView = UIStackView(arrangedSubviews: arrangedSubviews)
    stackView!.axis = .vertical
    
    addAndAttachToEdges(view: stackView)
  }
  
  private func makeRowStack(with details: ArraySlice<DetailItem>) -> UIStackView {
    var arrangedSubviews = [UIView]()
    for detail in details {
      let gridItem = DetailsGridItem(frame: .zero)
      gridItem.translatesAutoresizingMaskIntoConstraints = false
      gridItem.heightAnchor.constraint(equalToConstant: 70).isActive = true
      gridItem.configure(with: detail)
      arrangedSubviews.append(gridItem)
    }
    
    let rowStack = UIStackView(arrangedSubviews: arrangedSubviews)
    rowStack.axis = .horizontal
    rowStack.distribution = .fillEqually
    return rowStack
  }
}

extension Collection {
    func unfoldSubSequences(limitedTo maxLength: Int) -> UnfoldSequence<SubSequence,Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: maxLength, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return self[start..<end]
        }
    }
}
