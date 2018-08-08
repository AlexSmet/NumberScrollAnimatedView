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
    }

    @IBAction func onPushButton(_ sender: UIButton) {
        animatedView.startAnimation()
    }
    
}

