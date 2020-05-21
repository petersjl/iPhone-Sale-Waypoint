//
//  Rosefire.swift
//  Rosefire_Example
//
//  Created by David Fisher on 4/12/18.
//  Copyright © 2018 RoseHulman. All rights reserved.
//

import UIKit
import WebKit

public typealias RosefireCallback = ((NSError?, RosefireResult?) -> ())?

@objc
public class Rosefire : NSObject {

  private static var rosefire : Rosefire?

  @objc public class func sharedDelegate() -> Rosefire! {
    if rosefire == nil {
      rosefire = Rosefire()
    }
    return rosefire!
  }

  public var uiDelegate : UIViewController?
  private var webview : WebviewController!

  private override init() {
    super.init()
  }

  @objc public func signIn(registryToken : String!, withClosure closure: RosefireCallback) {
    if uiDelegate == nil {
      let err = NSError(domain: "Failed to set UI Delegate for Rosefire", code: 500, userInfo: nil)
      closure!(err, nil)
      return
    }
    webview = WebviewController()
    webview.registryToken = registryToken
    webview.callback = { (err, result) in
      self.uiDelegate!.dismiss(animated: true, completion: nil)
      closure!(err, result)
    }
    // Is this robust?
    let rootCtrl = UINavigationController(rootViewController: webview)
    webview.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(cancelled))
    uiDelegate!.present(rootCtrl, animated: true, completion: nil)
  }

  @objc private func cancelled() {

    let err = NSError(domain: "User cancelled login", code: 0, userInfo: nil)
    self.webview?.callback!(err, nil)
  }

}

@objc public class RosefireResult : NSObject {
  public var token : String!
  public var username : String!
  public var name : String!
  public var email : String!
  public var group : String!

  init(token: String?) {
    self.token = token
    if token == nil {
      return
    }
    var payload = token!.split{$0 == "."}.map(String.init)[1]
    var paddingNeeded = payload.count % 4
    while paddingNeeded > 0 {
      payload = payload + "="
      paddingNeeded = paddingNeeded - 1
    }
    let decodedData = NSData(base64Encoded: payload, options: NSData.Base64DecodingOptions(rawValue: 0))
    var json : [String:Any]
    do {
      json = try JSONSerialization.jsonObject(with: decodedData! as Data, options: []) as! [String:Any]
      if json["d"] != nil {
        // old format
        json = json["d"] as! [String:AnyObject]
      } else {
        // new format
        let username = json["uid"] as! String
        json = json["claims"] as! [String:Any]
        json["uid"] = username
      }
      self.username = (json["uid"] as! String)
      self.name = (json["name"] as! String)
      self.email = (json["email"] as! String)
      self.group = (json["group"] as! String)

    } catch {
      print("Error: Couldn't parse Rosefire JWT")
    }


  }
}

private class WebviewController : UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {

  var webview: WKWebView?
  var registryToken: String?
    var callback: RosefireCallback = nil

  fileprivate override func loadView() {
    super.loadView()
    let contentController = WKUserContentController()
    contentController.add(
      self,
      name: "rosefire"
    )
    let config = WKWebViewConfiguration()
    config.userContentController = contentController
    webview = WKWebView(
      frame: view.bounds,
      configuration: config
    )
    view = webview!
  }

  fileprivate override func viewDidLoad() {
    super.viewDidLoad()

    let token = registryToken!.stringByAddingPercentEncodingForRFC3986()!
    let rosefireUrl = "https://rosefire.csse.rose-hulman.edu/webview/login?registryToken=\(token)&platform=ios"
    let url = URL(string: rosefireUrl)
    let req = URLRequest(url: url!)
    webview!.load(req)
  }

  @objc func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if(message.name == "rosefire") {
      let token = message.body as! String
      callback!(nil, RosefireResult(token: token))
    }
  }
}

// From http://useyourloaf.com/blog/how-to-percent-encode-a-url-string/
extension String {
  func stringByAddingPercentEncodingForRFC3986() -> String? {
    let unreserved = "-._~/?"
    let allowed = NSMutableCharacterSet.alphanumeric()
    allowed.addCharacters(in: unreserved)
    return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
  }
}
