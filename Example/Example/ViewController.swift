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

    }

    @IBAction func onPushButton(_ sender: UIButton) {
        animatedView.value = 5893
        animatedView.scrollableColumns[1].scrollingDirection = .up
        animatedView.startAnimation()
    }
    
}

