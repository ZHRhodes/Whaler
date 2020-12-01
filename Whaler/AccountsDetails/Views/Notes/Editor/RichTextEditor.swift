//
//  RichTextEditor.swift
//  Whaler
//
//  Created by Zachary Rhodes on 7/23/20.
//  Copyright © 2020 Whaler. All rights reserved.
//

import Foundation
import WebKit
import SwiftUI
import Aztec

public protocol RichTextEditorDelegate: class {
    func textDidChange(text: String)
    func heightDidChange()
}

fileprivate class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}

struct RichTextEditorRepresentable: UIViewRepresentable {
  typealias UIViewType = RichTextEditor
//  typealias Coordinator = RichTextEditorCoordinator
  
  weak var editor: RichTextEditor?
  
  func makeUIView(context: Context) -> RichTextEditor {
    return editor!
//    return RichTextEditor()
  }
  
  func updateUIView(_ uiView: RichTextEditor, context: Context) {
    
  }
  
//  func makeCoordinator() -> Coordinator {
//    return .init(self)
//  }
}

class RichTextEditorCoordinator {
  let richTextEditor: RichTextEditor
  
  init(_ richTextEditor: RichTextEditor) {
    self.richTextEditor = richTextEditor
  }
}

final class RichTextEditor: UIView, WKNavigationDelegate, UIScrollViewDelegate {
  private static let textDidChange = "textDidChange"
  private static let heightDidChange = "heightDidChange"
  private static let defaultHeight: CGFloat = 60

  public weak var delegate: RichTextEditorDelegate?
  public var height: CGFloat = RichTextEditor.defaultHeight

  public var placeholder: String? {
      didSet {
          placeholderLabel.text = placeholder
      }
  }

  private var textToLoad: String?
  public var text: String? //{
//      didSet {
//          guard let text = text else { return }
//          if editorView.isLoading {
//              textToLoad = text
//          } else {
//              editorView.evaluateJavaScript("richeditor.insertText(\"\(text.htmlEscapeQuotes)\");", completionHandler: nil)
//              placeholderLabel.isHidden = !text.htmlToPlainText.isEmpty
//          }
//      }
//  }

  private var editorView: Aztec.TextView!//WKWebView!
  private let placeholderLabel = UILabel()
  
  public override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    editorView = Aztec.TextView(defaultFont: UIFont.openSans(weight: .regular, size: 25),
                                defaultParagraphStyle: .default,
                                defaultMissingImage: UIImage(named: "bold")!)
    addSubview(editorView)
    editorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        editorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
        editorView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        editorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        editorView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

//  public override init(frame: CGRect = .zero) {
//    placeholderLabel.textColor = UIColor.lightGray.withAlphaComponent(0.65)
//
//    guard let scriptPath = Bundle.main.path(forResource: "richTextEditor", ofType: "js", inDirectory: "trix-master/dist") else { fatalError("") }
//
//    guard let scriptContent = try? String(contentsOfFile: scriptPath, encoding: String.Encoding.utf8) else { fatalError("") }
//
//    let configuration = WKWebViewConfiguration()
//    configuration.userContentController.addUserScript(
//        WKUserScript(source: scriptContent,
//                     injectionTime: .atDocumentStart,
//                     forMainFrameOnly: true
//        )
//    )
//
//    super.init(frame: frame)
//
//    [RichTextEditor.textDidChange, RichTextEditor.heightDidChange].forEach {
//        configuration.userContentController.add(self, name: $0)
//    }
//
//    editorView = WKWebView(frame: .zero, configuration: configuration)
//
//    let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
//    let script = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
//    editorView.configuration.userContentController.addUserScript(script)
//    editorView.configuration.userContentController.add(self, name: "logHandler")
//
//    let url = Bundle.main.url(forResource: "richTextEditor", withExtension: "html", subdirectory: "trix-master/dist")!
//
//    editorView.navigationDelegate = self
//    editorView.isOpaque = false
//    editorView.backgroundColor = .clear
//    editorView.scrollView.showsHorizontalScrollIndicator = false
//    editorView.scrollView.showsVerticalScrollIndicator = true
//    editorView.scrollView.bounces = true
//    editorView.scrollView.isScrollEnabled = true
//    editorView.scrollView.delegate = self
//
//    addSubview(placeholderLabel)
//    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//        placeholderLabel.topAnchor.constraint(equalTo: topAnchor),
//        placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//        placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
//    ])
//
//    addSubview(editorView)
//    editorView.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//        editorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//        editorView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//        editorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
//        editorView.bottomAnchor.constraint(equalTo: bottomAnchor)
//    ])
//
//    editorView.loadFileURL(url, allowingReadAccessTo: url)
//  }

  public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }

//  public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//      switch message.name {
//      case RichTextEditor.textDidChange:
//          guard let body = message.body as? String else { return }
//          placeholderLabel.isHidden = !body.htmlToPlainText.isEmpty
//          delegate?.textDidChange(text: body)
//      case RichTextEditor.heightDidChange:
//          guard let height = message.body as? CGFloat else { return }
//          self.height = height > RichTextEditor.defaultHeight ? height + 30 : RichTextEditor.defaultHeight
//          delegate?.heightDidChange()
//      default:
//          break
//      }
//  }

  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      if let textToLoad = textToLoad {
          self.textToLoad = nil
          text = textToLoad
      }
  }

  public func viewForZooming(in: UIScrollView) -> UIView? {
      return nil
  }
  
//  func serializeEditor(success: @escaping (String) -> Void, failure: @escaping (Error?) -> Void) {
//    editorView.evaluateJavaScript("serializeEditor()") { (response, error) in
//      guard error == nil,
//            var responseString = response as? String else { return failure(error) }
//      responseString = responseString.replacingOccurrences(of: #"\n"#, with: #"\\n"#)
//      success(responseString)
////      let utf16array = Array(responseString.utf16)
////      let string = String(utf16CodeUnits: utf16array, count: utf16array.count)
////      string.replace
////      success(string)
//    }
//  }
  
//  func restoreEditor(to state: String) {
//    editorView.evaluateJavaScript("restoreEditor('\(state)')") { (response, error) in
//      Log.debug(String(reflecting: response))
//      Log.debug(String(reflecting: error))
//    }
//  }
}

fileprivate extension String {
    var htmlToPlainText: String {
        return [
            ("(<[^>]*>)|(&\\w+;)", " "),
            ("[ ]+", " ")
        ].reduce(self) {
            try! $0.replacing(pattern: $1.0, with: $1.1)
        }.resolvedHTMLEntities
    }

    var resolvedHTMLEntities: String {
        return self
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&#x27;", with: "'")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&nbsp;", with: " ")
    }

    func replacing(pattern: String, with template: String) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(0..<self.utf16.count), withTemplate: template)
    }

    var htmlEscapeQuotes: String {
        return [
            ("\"", "\\\""),
            ("“", "&quot;"),
            ("\r", "\\r"),
            ("\n", "\\n")
        ].reduce(self) {
            return $0.replacingOccurrences(of: $1.0, with: $1.1)
        }
    }
}

extension RichTextEditor: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if message.name == "logHandler" {
      Log.info("WebKit LOG: \(message.body)", context: .textEditor)
    }
  }
}
