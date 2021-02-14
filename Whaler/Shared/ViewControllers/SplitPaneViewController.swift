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
  //Known issue: currently resizing ONLY works with two views, not more
  var resizable = false
  private let viewStacker = ViewControllerViewStacker()
  private var separators = [UIView]() //currently, these are never removed
  private var distribution = [CGFloat]()
  private var cancellable: AnyCancellable?
  private let separatorWidth: CGFloat = 5
  
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
    if viewStacker.viewControllers.count > 0 {
      viewStacker.appendView(makeDraggableSeparator())
    }
    viewStacker.appendViewController(viewController)
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
//      vc.view.removeConstraints(vc.view.constraints)
        vc.view.constraintsAffectingLayout(for: .horizontal).forEach({ $0.isActive = false })
      vc.view.widthAnchor.constraint(equalToConstant: width).isActive = true
    })
  }
  
  //MARK: Private Methods
  
  private func distributeViewsEqually() {
    let vcCount = viewStacker.viewControllers.count
    let ratio = CGFloat(1) / CGFloat(vcCount)
    let distribution = Array(repeating: ratio, count: vcCount)
    try? setDistribution(ratios: distribution)
  }
  
  private func calculateWidthForRatio(_ ratio: CGFloat) -> CGFloat {
    var width: CGFloat = view.frame.width
    
    let separators = viewStacker.viewControllers.count - 1
    if separators > 0 {
      width -= CGFloat(separators) * separatorWidth
    }
    
    return width * ratio
  }
  
  private func configureViewStack() {
    view.addAndAttachToEdges(view: viewStacker.stackView)
  }
  
  private func makeDraggableSeparator() -> UIView {
    let container = UIView()
    container.widthAnchor.constraint(equalToConstant: separatorWidth).isActive = true
    container.backgroundColor = .clear
    let line = UIView()
    line.backgroundColor = .black
    if resizable {
      let hoverGesture = UIHoverGestureRecognizer(target: self,
                                                  action: #selector(hovering(_:)))
      container.addGestureRecognizer(hoverGesture)
      
      let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                          action: #selector(handleLongPressGesture(_:)))
      longPressGesture.minimumPressDuration = 0.1
      container.addGestureRecognizer(longPressGesture)
    }
    let lineWidth: CGFloat = 1.0
    line.widthAnchor.constraint(equalToConstant: lineWidth).isActive = true
    separators.append(container)
    container.addAndAttachToEdges(view: line, inset: (separatorWidth - lineWidth) / 2)
    return container
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
  
  @objc
  private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state == UIGestureRecognizer.State.changed {
      var ratios = [CGFloat]()
      var xMax: CGFloat = 0.0
      separators.forEach { (separator) in
        var separatorX: CGFloat = separator.frame.minX
        if separator === gesture.view {
          separatorX += gesture.location(in: gesture.view).x
        }
        let xRatio = separatorX/view.frame.width
        ratios.append(xRatio - xMax)
        xMax = xRatio
      }
      ratios.append(1.0 - xMax)
      do { try setDistribution(ratios: ratios) } catch(let error) { print(error) }
    }
  }
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
