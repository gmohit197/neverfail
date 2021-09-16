//
//  ViewController.swift
//  Ripple CSR
//
//  Created by aayush shukla on 21/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwiftyGif
import SwiftEventBus

class ViewController: BASEACTIVITY {
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
    var bgimg: UIImageView = {
    let imageView = UIImageView(frame: .zero)
    imageView.image = UIImage(named: "bg")
    imageView.contentMode = .scaleToFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
    }()
    var reachability: Reachability!
    override func callback() {
        print("version called ===== > ")
        self.getversion()
    }
    @objc func reachabilityChanged(_ note: NSNotification) {
    let reachability = note.object as! Reachability
        var image = UIImage(named: "")
    if reachability.connection != .unavailable {
    if reachability.connection == .wifi {
    print("Reachable via WiFi")
        AppDelegate.ntwrk = 1
        
        
    } else {
    print("Reachable via Cellular")
        AppDelegate.ntwrk = 1
        
    }
    } else {
    print("Not reachable")
        AppDelegate.ntwrk = 0
        
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.insertSubview(self.bgimg, at: 0)
        NSLayoutConstraint.activate([
            bgimg.topAnchor.constraint(equalTo: view.topAnchor),
            bgimg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgimg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgimg.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        do {
        try reachability = Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
        try reachability.startNotifier()
        } catch {
             print("This is not working.")
        }
//        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            if (AppDelegate.ntwrk > 0){
//                self.gettoken()
//            }else{
                self.gotologin()
//            }
//        }
        
        SwiftEventBus.onMainThread(self, name: "gotversion") { (result) in
//            if (){
                print("version callback -------=========")
            let appver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            if (appver != UserDefaults.standard.string(forKey: "version")!){
                let alert = UIAlertController(title: "Update Available", message: "Update to Latest version (v.\(UserDefaults.standard.string(forKey: "version")!))", preferredStyle: .alert)
                
                let yes = UIAlertAction(title: "Yes", style: .default) { (Result) in
                    if let url = URL(string: "https://apps.apple.com/in/app/wella-education-app/id1440998071") {
                        UIApplication.shared.open(url)
                    }
                }
                
                let no = UIAlertAction(title: "No", style: .cancel) { (Result) in
                    alert.dismiss(animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                          exit(0)
                         }
                    }
                }
                
                alert.addAction(yes)
                alert.addAction(no)
//                alert.present(self, animated: true, completion: nil)
                self.present(alert, animated: true, completion: nil)
                
            }else{
                let storyboard = UIStoryboard(name: "LOGIN", bundle: nil)

                //Get the VC you want to push onto the stack
                //You can use storyboard.instantiateViewController(withIdentifier: "yourStoryboardId")
                guard let vc = storyboard.instantiateInitialViewController() else { return }

                //Get the current app delegate
                guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }

                //Set the current root controller and add the animation with a
                //UIView transition
                 UIApplication.shared.windows.first?.rootViewController = vc
                 UIApplication.shared.windows.first?.makeKeyAndVisible()

                UIView.transition(with: UIApplication.shared.windows.first!,
                              duration: 1.0,
                               options: .transitionCrossDissolve,
                            animations: {
                                UIApplication.shared.windows.first?.rootViewController = vc
                },
                            completion: nil)
            // Do any additional setup after loading the view.
        }
            }
        }
    
    func gotologin(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
           // Code to push/present new view controller
            let storyboard = UIStoryboard(name: "LOGIN", bundle: nil)

            //Get the VC you want to push onto the stack
            //You can use storyboard.instantiateViewController(withIdentifier: "yourStoryboardId")
            guard let vc = storyboard.instantiateInitialViewController() else { return }

            //Get the current app delegate
            guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }

            //Set the current root controller and add the animation with a
            //UIView transition
             UIApplication.shared.windows.first?.rootViewController = vc
             UIApplication.shared.windows.first?.makeKeyAndVisible()

            UIView.transition(with: UIApplication.shared.windows.first!,
                          duration: 1.0,
                           options: .transitionCrossDissolve,
                        animations: {
                            UIApplication.shared.windows.first?.rootViewController = vc
            },
                        completion: nil)
        // Do any additional setup after loading the view.
    }
    }
}
