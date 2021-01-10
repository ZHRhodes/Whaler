//
//  SplitPaneViewController.swift
//  Whaler
//
//  Created by Zachary Rhodes on 1/10/21.
//  Copyright © 2021 Whaler. All rights reserved.
//

import Foundation
import UIKit
import Combine

class SplitPaneViewController: UIViewController {
  var resizable = false
  private let viewStacker = ViewControllerViewStacker()
  private var distribution = [CGFloat]()
  private var cancellable: AnyCancellable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewStack()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard distribution.count == viewStacker.viewControllers.count else {
      Log.warning("Distribution not compatible with current number of viewControllers.")
      distributeViewsEqually()
      return
    }
    applyDistribution()
  }
  
  //Known issue: careful inserting when you should be appending
  func insertViewController(_ viewController: UIViewController, at index: Int) {
    viewStacker.insertViewController(viewController, at: index)
    viewStacker.insertView(makeDraggableSeparator(), at: index*2+1)
  }
  
  func appendViewController(_ viewController: UIViewController) {
    viewStacker.appendViewController(viewController)
    viewStacker.appendView(makeDraggableSeparator())
  }
  
  func removeViewController(at index: Int) {
    viewStacker.removeViewController(at: index)
    viewStacker.removeView(at: index*2+1)
  }
  
  func setDistribution(ratios: [CGFloat]) throws {
    guard ratios.reduce(0, { $0 + $1}) == 1.0 else { throw "Ratios do not add up to 1.0!" }
    self.distribution = ratios
    view.setNeedsLayout()
  }
  
  func applyDistribution() {
    cancellable = viewStacker.viewControllers
      .publisher
      .zip(distribution.publisher)
      .sink(receiveValue: { [weak self] (vc, ratio) in
      guard let strongSelf = self else { return }
      let width = strongSelf.calculateWidthForRatio(ratio)
      vc.view.widthAnchor.constraint(equalToConstant: width).isActive = true
    })
  }
  
  //MARK: Private Methods
  
  private func distributeViewsEqually() {
    let width = calculateEqualWidthForView()
    viewStacker.viewControllers.forEach { (vc) in
      vc.view.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
  }
  
  private func calculateEqualWidthForView() -> CGFloat {
    var width: CGFloat = view.frame.width
    let viewControllerCount = viewStacker.viewControllers.count
    
    let separators = viewStacker.viewControllers.count - 1
    if separators > 0 {
      width -= CGFloat(separators)
    }
    
    if viewControllerCount > 1 {
      width /= CGFloat(viewControllerCount)
    }
    return width
  }
  
  private func calculateWidthForRatio(_ ratio: CGFloat) -> CGFloat {
    var width: CGFloat = view.frame.width
    
    let separators = viewStacker.viewControllers.count - 1
    if separators > 0 {
      width -= CGFloat(separators)
    }
    
    return width * ratio
  }
  
  private func configureViewStack() {
    view.addAndAttachToEdges(view: viewStacker.stackView)
  }
  
  private func makeDraggableSeparator() -> UIView {
    let view = UIView()
    view.backgroundColor = .black
    if resizable {
      let hoverGesture = UIHoverGestureRecognizer(target: self,
                                                 action: #selector(hovering(_:)))
      view.addGestureRecognizer(hoverGesture)
    }
    view.widthAnchor.constraint(equalToConstant: 1).isActive = true
    return view
  }
  
  @objc
  private func hovering(_ recognizer: UIHoverGestureRecognizer) {
    #if targetEnvironment(macCatalyst)
    switch recognizer.state {
    case .began, .changed:
      NSCursor.resizeLeftRight.set()
    case .ended:
      NSCursor.arrow.set()
    default:
      break
    }
    #endif
  }
  
  //TODO: dragging when resizable is enabled (using log press gestures) should update the appropriate view constraints
}

class ViewControllerViewStacker {
  private(set) lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
//    stackView.distribution = .fillProportionally
    return stackView
  }()
  
  private(set) var viewControllers = [UIViewController]()
  
  func insertView(_ view: UIView, at index: Int) {
    stackView.insertSubview(view, at: index)
  }
  
  func appendView(_ view: UIView) {
    stackView.addArrangedSubview(view)
  }
  
  func removeView(at index: Int) {
    stackView.arrangedSubviews[index].removeFromSuperview()
  }
  
  //wont exactly work without converting index
  func insertViewController(_ viewController: UIViewController, at index: Int) {
    viewControllers.insert(viewController, at: index)
    stackView.insertSubview(viewController.view, at: index*2)
  }
  
  func appendViewController(_ viewController: UIViewController) {
    viewControllers.append(viewController)
    stackView.addArrangedSubview(viewController.view)
  }
  
  func removeViewController(at index: Int) {
    let removedVC = viewControllers.remove(at: index)
    stackView.removeArrangedSubview(removedVC.view)
    removedVC.view.removeFromSuperview()
  }
}
