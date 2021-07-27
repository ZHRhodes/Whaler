//
//  DetailsGrid.swift
//  Whaler
//
//  Created by Zachary Rhodes on 2/27/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit
import Combine

struct DetailItem {
  let image: UIImage
  let description: String
  let value: String
}

class DetailsGrid: UIView {
  private var stackView: UIStackView!
  private var detailsCancellable: AnyCancellable?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
		layer.borderWidth = UIConstants.boxBorderWidth
    layer.borderColor = UIColor.borderLineColor.cgColor
    layer.cornerRadius = 10.0
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with detailsProvider: DetailsProvider) {
    detailsCancellable = detailsProvider
      .publisher
      .sink(receiveValue: { [weak self] (detailItems) in
        self?.configureView(with: detailItems)
      })
  }
  
  private func configureView(with details: [DetailItem]) {
    var arrangedSubviews = [UIView]()
    
    for (i, detail) in details.enumerated() {
      let gridItem = DetailsGridItem(frame: .zero)
      gridItem.translatesAutoresizingMaskIntoConstraints = false
      gridItem.heightAnchor.constraint(equalToConstant: 56).isActive = true
      let isLast = i == (details.count - 1)
      gridItem.configure(with: detail, showRightLine: !isLast)
      arrangedSubviews.append(gridItem)
    }
    
    stackView?.removeFromSuperview()
    stackView = UIStackView(arrangedSubviews: arrangedSubviews)
    stackView!.axis = .horizontal
    stackView.distribution = .fillProportionally
    
    addAndAttachToEdges(view: stackView)
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
