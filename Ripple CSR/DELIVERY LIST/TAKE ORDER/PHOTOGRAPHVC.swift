//
//  PHOTOGRAPHVC.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 10/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class PHOTOGRAPHVC: BASEACTIVITY {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Photograph Methods
      private func initialSetup() {
          view.backgroundColor = .white
          title = "Capture Photo"
          
          let takePhotoButton = UIButton(type: .system)
          takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
          takePhotoButton.setTitle("Take Photo", for: .normal)
          takePhotoButton.setTitleColor(.white, for: .normal)
          takePhotoButton.backgroundColor = UIColor.darkGray
          takePhotoButton.layer.cornerRadius = 5
          takePhotoButton.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
          view.addSubview(takePhotoButton)
          
          takePhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
          takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
          takePhotoButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
          takePhotoButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
      }
      
      @objc private func handleTakePhoto() {
        if #available(iOS 13.0, *) {
            let controller = CustomCameraController()
            self.present(controller, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
          
      }
}
