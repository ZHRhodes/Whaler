//
//  AccountWidgetCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/20/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class AccountWidgetCell: UICollectionViewCell {
  static let id = "AccountWidgetCellId"
  private var titleLabel: UILabel = UILabel()
  private var content: UIView?
  private var widthConstraint: NSLayoutConstraint?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  private func configure() {
    configureTitleLabel()
    enableContentViewSelfSizing()
  }
  
  private func enableContentViewSelfSizing() {
    widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
        contentView.leftAnchor.constraint(equalTo: leftAnchor),
        contentView.rightAnchor.constraint(equalTo: rightAnchor),
        contentView.topAnchor.constraint(equalTo: topAnchor),
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  override func updateConstraints() {
      // Set width constraint to superview's width.
      widthConstraint?.constant = superview?.bounds.width ?? 0
      widthConstraint?.isActive = true
      super.updateConstraints()
  }
  
  private func configureTitleLabel() {
    titleLabel.font = .openSans(weight: .bold, size: 18)
    contentView.addAndAttach(view: titleLabel, height: 24.0, attachingEdges: [.top(), .left(16)])
  }
  
  func configure(title: String, content: UIView) {
    titleLabel.text = title
    self.content?.removeFromSuperview()
    self.content = content
    contentView.addAndAttach(view: content, attachingEdges: [.left(16),
                                                             .right(-16),
                                                             .bottom(16),
                                                             .top(16, equalTo: titleLabel.bottomAnchor)])
  }
}
