//
//  UploadViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 14/10/2022.
//

import UIKit
import PhotosUI

class UploadViewController: UIViewController, InformationViewDelegate {
    
    private var informationView: InformationView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        informationView = InformationView(frame: .zero, isHaveSubtitle: true)
        informationView.config(nameImage: "PermissionSymbol", title: "Allow your Photo Library", subtitle: "We will need your photo permission to be able to upload photos", buttonTitle: "GRANT ACCESS", type: .haveSubtitle)
        informationView.delegate = self
        view.addSubview(informationView)
        informationView.translatesAutoresizingMaskIntoConstraints = false
        informationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        informationView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        informationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.66).isActive = true
        informationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        informationView.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Request permission to access photo library
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [unowned self] (status) in
                DispatchQueue.main.async { [unowned self] in
                    showUI(for: status)
                }
            }
        } else {
            // Fallback on earlier versions
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({ [self]status in
                    DispatchQueue.main.async { [unowned self] in
                        showUI(for: status)
                    }
                })
            }
            else{
                showPhotoPicker()
            }
        }
    }
    
    func showUI(for status: PHAuthorizationStatus) {
        
        switch status {
        case .authorized:
            showPhotoPicker()
            
        case .limited:
            print("2")
            
        case .restricted:
            print("3")
            
        case .denied:
            informationView.isHidden = false
            
        case .notDetermined:
            break
            
        @unknown default:
            break
        }
    }
    
    func showPhotoPicker(){
        let vc = PhotoPickerViewController()
        vc.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func actionButton() {
        let alert = UIAlertController(title: "Allow access to your photos",
                                      message: "This lets you share from your camera roll and enables other features for photos and videos. Go to your settings and tap \"Photos\".",
                                      preferredStyle: .alert)
        
        let notNowAction = UIAlertAction(title: "Not Now",
                                         style: .cancel,
                                         handler: nil)
        alert.addAction(notNowAction)
        
        let openSettingsAction = UIAlertAction(title: "Open Settings",
                                               style: .default) { [unowned self] (_) in
            // Open app privacy settings
            gotoAppPrivacySettings()
        }
        alert.addAction(openSettingsAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            assertionFailure("Not able to open App privacy settings")
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

