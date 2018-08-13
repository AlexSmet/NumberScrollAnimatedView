//
//  String+Extension.swift
//
//
//  Created by Alexander Smetannikov on 13/08/2018.
//  Copyright © 2018 Alexander Smetannikov. All rights reserved.
//

import UIKit

extension String {
    func size(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size
    }

    func width(usingFont font: UIFont) -> CGFloat {
        return size(usingFont: font).width
    }

    func height(usingFont font: UIFont) -> CGFloat {
        return size(usingFont: font).height
    }

    static func numericSymbolsMaxWidth(usingFont font: UIFont) -> CGFloat {
        var maxWidth:CGFloat = 0

        for symbol in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] {
            maxWidth = Swift.max(maxWidth, symbol.width(usingFont: font))
        }

        return maxWidth
    }
}
