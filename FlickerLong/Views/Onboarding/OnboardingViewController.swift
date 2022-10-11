//
//  ViewController.swift
//  FlickerLong
//
//  Created by LAP15335 on 11/10/2022.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private var onboardingView : OnboardingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting View
        onboardingView = OnboardingView(view: self.view)
        onboardingView.delegate = self
        onboardingView.initViewConstraint()
    }
}

extension OnboardingViewController : OnboardingViewDelegate{
    func getStartTapped() {
        print("asdsadsad")
    }
    
    
}

