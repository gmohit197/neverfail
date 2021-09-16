//
//  CHECKINOUTVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 21/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import MaterialComponents.MDCBottomNavigationBar
class CHECKINOUTVC: UITabBarController,MDCBottomNavigationBarDelegate {
  let bottomNavBar = MDCBottomNavigationBar()

  override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
  }

  override func viewWillAppear(_ animated: Bool)
  {
      super.viewWillAppear(animated)
      self.navigationController?.setNavigationBarHidden( true, animated: animated )
  }

  //Initialize Bottom Bar
  init()
  {
      super.init(nibName: nil, bundle: nil)
      commonBottomNavigationTypicalUseSwiftExampleInit()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder)
  {
      super.init(coder: aDecoder)
      commonBottomNavigationTypicalUseSwiftExampleInit()
  }

  // Bottom Bar Customization
  func commonBottomNavigationTypicalUseSwiftExampleInit()
  {
      view.backgroundColor = .lightGray
      view.addSubview(bottomNavBar)

      // Always show bottom navigation bar item titles.
      bottomNavBar.titleVisibility = .always

      // Cluster and center the bottom navigation bar items.
      bottomNavBar.alignment = .centered

      // Add items to the bottom navigation bar.
      let tabBarItem1 = UITabBarItem( title: "Driver",  image: UIImage(named: "driver"), tag: 0 )
      let tabBarItem2 = UITabBarItem( title: "Checker",   image: UIImage(named: "checker"), tag: 1 )
      let tabBarItem3 = UITabBarItem( title: "Top Ups", image: UIImage(named: "topups"), tag: 2 )
       let tabBarItem4 = UITabBarItem( title: "Statement", image: UIImage(named: "statement"), tag: 3 )
      bottomNavBar.items = [ tabBarItem1, tabBarItem2, tabBarItem3,tabBarItem4 ]

      // Select a bottom navigation bar item.
      bottomNavBar.selectedItem = tabBarItem1;
      bottomNavBar.delegate = self
  }


  func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem)
  {
    guard let fromView = selectedViewController?.view, let toView = customizableViewControllers?[item.tag].view else {
               return
           }

           if fromView != toView {
               UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
           }
      self.selectedIndex = item.tag
    
  }

  override func viewWillLayoutSubviews()
  {
      super.viewWillLayoutSubviews()
      layoutBottomNavBar()
  }

  #if swift(>=3.2)
  @available(iOS 11, *)
  override func viewSafeAreaInsetsDidChange()
  {
      super.viewSafeAreaInsetsDidChange()
      layoutBottomNavBar()
  }
  #endif

  // Setting Bottom Bar
  func layoutBottomNavBar()
  {
      let size = bottomNavBar.sizeThatFits(view.bounds.size)
      let bottomNavBarFrame = CGRect( x: 0,
                                     y: view.bounds.height - size.height - 4,
                                      width: size.width,
                                      height: size.height + 4)
      bottomNavBar.frame = bottomNavBarFrame
  }
}