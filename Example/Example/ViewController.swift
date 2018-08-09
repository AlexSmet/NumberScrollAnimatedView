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
        animatedView.value = 220548
        animatedView.scrollableColumns[0].scrollingDirection = .down
        animatedView.scrollableColumns[0].durationOffset = 1
        animatedView.scrollableColumns[1].scrollingDirection = .up
        animatedView.scrollableColumns[1].inverseSequence = true
        animatedView.scrollableColumns[1].durationOffset = 0.5
        animatedView.scrollableColumns[2].scrollingDirection = .up
        animatedView.scrollableColumns[3].scrollingDirection = .down
        animatedView.scrollableColumns[3].durationOffset = 0.5
        animatedView.scrollableColumns[4].scrollingDirection = .up
        animatedView.scrollableColumns[4].inverseSequence = true
        animatedView.scrollableColumns[4].durationOffset = 0.8
        animatedView.scrollableColumns[5].scrollingDirection = .up
        animatedView.startAnimation()
    }
    
}

