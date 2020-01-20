//
//  WebViewController.swift
//  PushLib
//
//  Created by 株式会社シナブル on 2019/10/18.
//  Copyright © 2019 株式会社シナブル. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet var myWebView: WKWebView!
    var userUrl = String()
    
    override func loadView() {
        myWebView = WKWebView()
        myWebView.uiDelegate =  self
        myWebView.navigationDelegate = self
              
        let spref = UserDefaults.standard
        userUrl = spref.string(forKey: "userUrl") ?? ""
             
        self.view = self.myWebView
    }
    
    override func viewDidLoad() {
                super.viewDidLoad()

                print(userUrl)
                let url = URL(string: userUrl)
                let request = URLRequest(url: url!)
                myWebView.load(request)
                // Do any additional setup after loading the view.
            }
            
            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
            }
            
            func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
                
                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler()
                    
                }))
               
                self.present(alertController, animated: true, completion: nil)
                
            }
           
            func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
                
                let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
               
                alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler(true)
                    
                }))
               
                alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(false)
                    
                }))
               
                self.present(alertController, animated: true, completion: nil)
                
            }
            
            func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
                
                let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
                
                alertController.addTextField { (textField) in textField.text = defaultText }
               
                alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
                    if let text = alertController.textFields?.first?.text {
                        completionHandler(text)
                        
                    }
                    else {
                        completionHandler(defaultText)
                        
                    }
                    
                }))
                
                alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(nil) }))
               
                self.present(alertController, animated: true, completion: nil)
                
            }
            
            func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
               
                if navigationAction.targetFrame == nil {
                    webView.load(navigationAction.request)
                    
                }
                
                return nil
                
            }
            
            public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
                
                webView.reload()
            }

        }
