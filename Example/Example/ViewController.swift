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

        animatedView.font = UIFont.boldSystemFont(ofSize: 64)
        animatedView.textColor = .white
    }

    @IBAction func onPushButton(_ sender: UIButton) {
        animatedView.value = "220-548"
        animatedView.animationDuration = 5
//        animatedView.scrollingDirectionSetter = { return ScrollingDirection.down }
//        animatedView.inverseSequenceSetter = { return false }
        animatedView.startAnimation()
    }
}

