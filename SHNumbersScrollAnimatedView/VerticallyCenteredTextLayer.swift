//
//  VerticallyCenteredTextLayer.swift
//
//
//  Created by Alexander Smetannikov on 13/08/2018.
//  Copyright © 2018 Alexander Smetannikov. All rights reserved.
//

import UIKit

class VerticallyCenteredTextLayer: CATextLayer {
    override open func draw(in ctx: CGContext) {
        if let attributedString = self.string as? NSAttributedString {
            let height = self.bounds.size.height
            let stringSize = attributedString.size()
            let yDiff = (height - stringSize.height) / 2

            ctx.saveGState()
            ctx.translateBy(x: 0.0, y: yDiff)
            super.draw(in: ctx)
            ctx.restoreGState()
        }
    }
}
