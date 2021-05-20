//
//  DetailsGridCell.swift
//  Whaler
//
//  Created by Zachary Rhodes on 5/19/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

class DetailsGridCell: UICollectionViewCell {
  private var detailsGrid: DetailsGrid?
  
  func configure(with detailsGrid: DetailsGrid) {
    self.detailsGrid?.removeFromSuperview()
    self.detailsGrid = detailsGrid
    contentView.addAndAttachToEdges(view: detailsGrid)
  }
}
