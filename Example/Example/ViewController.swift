//
//  ViewController.swift
//  Example
//
//  Created by Alexander Smetannikov on 07/08/2018.
//  Copyright © 2018 Alexander Smetannikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animatedView: SHNumbersScrollAnimatedView!


    override func viewDidLoad() {
        super.viewDidLoad()

        animatedView.font = UIFont.boldSystemFont(ofSize: 72)
        animatedView.textColor = .white
        animatedView.value = 89
        animatedView.minLength = 2
        animatedView.duration = 1.5
        animatedView.durationOffset = 0.2
        animatedView.density = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onPushButton(_ sender: UIButton) {
        animatedView.startAnimation()
    }
    
}

