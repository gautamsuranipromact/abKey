//
//  AdaptiveLabel.swift
//  AbKey
//
//  Created by Promact on 16/10/24.
//


import UIKit

class AdaptiveLabel: UILabel { // Responsive labels for different screens

    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustFontForDevice()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        adjustFontForDevice()
    }

    private func adjustFontForDevice() {
        if Constants.IpadScreen {
            // Increase the font size for iPad
            self.font = self.font.withSize(self.font.pointSize * 1.5)
        }
    }
}
