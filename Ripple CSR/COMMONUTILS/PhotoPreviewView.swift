//
//  PhotoPreviewView.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 10/08/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SwiftEventBus
import Photos

class PhotoPreviewView: UIView {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "xmark"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy private var savePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(photoImageView, cancelButton, savePhotoButton)
        
        photoImageView.makeConstraints(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 0, width: 0, height: 0)
        
        if #available(iOS 11.0, *) {
            cancelButton.makeConstraints(top: safeAreaLayoutGuide.topAnchor, left: nil, right: rightAnchor, bottom: nil, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 50, height: 50)
        } else {
            // Fallback on earlier versions
        }
        
        savePhotoButton.makeConstraints(top: nil, left: nil, right: cancelButton.leftAnchor, bottom: nil, topMargin: 0, leftMargin: 0, rightMargin: 5, bottomMargin: 0, width: 50, height: 50)
        savePhotoButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func handleCancel() {
//        DispatchQueue.main.async {
//            self.removeFromSuperview()
//        }
        self.handleDismiss()
    }
    
    @objc private func handleDismiss() {
        DispatchQueue.main.async {
            
            if (self.photoImageView.image != nil){
                
                let alert  = UIAlertController(title: "Save Photo", message: "Do you want to save this Photo?", preferredStyle: .alert)
                let base = BASEACTIVITY()
                let db = Databaseconnection()
                let id = db.getlastactivityid(orderid: CUSTORDERVC.custid!)
                let yes = UIAlertAction(title: "Yes", style: .default) { Result in
                    db.insertimage(ordernum: CUSTORDERVC.custid!, image: base.imagetobase(image: self.photoImageView.image!), type: "2", date: base.getdate(format: "yyyy-MM-dd"), activity: id,post: "0")
                    alert.dismiss(animated: true) {
                        self.removeFromSuperview()
                    }
                   
                }
                let no = UIAlertAction(title: "No", style: .destructive) { Result in
                    alert.dismiss(animated: true) {
                        self.removeFromSuperview()
                    }
                }
                alert.addAction(yes)
                alert.addAction(no)
                
                let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                let ordervc = rootViewController.children[1].children[2]
                ordervc.presentedViewController!.present(alert, animated: true, completion: nil)
            }else{
                self.removeFromSuperview()
            }
        }
    }
    
    @objc private func handleSavePhoto() {
        
        guard let previewImage = self.photoImageView.image else { return }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
                        print("photo has saved in library...")
                        self.handleCancel()
                    }
                } catch let error {
                    print("failed to save photo in library: ", error)
                }
            } else {
                print("Something went wrong with permission...")
            }
        }
    }
}

