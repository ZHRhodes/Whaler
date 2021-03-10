//
//  ContentSizedTableView.swift
//  Whaler
//
//  Created by Zachary Rhodes on 3/10/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit

final class ContentSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
