//
//  CustomButton.swift
//  CustomKeyboard
//
//  Created by Yudiz Solutions Ltd on 20/02/23.
//

import UIKit


class ButtonPopupAnimation: UIView {
    private var clonedButton: UIButton!

    init(button: UIButton) {
        super.init(frame: .zero)
        cloneButtonAppearance(button)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func cloneButtonAppearance(_ button: UIButton) {
        // Clone the button's appearance
        clonedButton = UIButton(type: .custom)
        clonedButton.setTitle(button.title(for: .normal), for: .normal)
        clonedButton.setTitleColor(button.titleColor(for: .normal), for: .normal)
        clonedButton.setImage(button.image(for: .normal), for: .normal)
        clonedButton.backgroundColor = button.backgroundColor
        clonedButton.titleLabel?.font = button.titleLabel?.font
        clonedButton.layer.cornerRadius = 10
        clonedButton.layer.borderWidth = button.layer.borderWidth
        clonedButton.layer.borderColor = button.layer.borderColor
        clonedButton.layer.masksToBounds = true
        clonedButton.contentMode = button.contentMode
        clonedButton.tintColor = button.tintColor
        clonedButton.setBackgroundImage(button.backgroundImage(for: .normal), for: .normal)
        
        // Add the cloned button to the popup view
        addSubview(clonedButton)
        clonedButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clonedButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            clonedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            clonedButton.topAnchor.constraint(equalTo: self.topAnchor),
            clonedButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}


class CustomButton: UIButton {
    @IBInspectable var borderWidth: CGFloat {
           set {
               layer.borderWidth = newValue
           }
           get {
               return layer.borderWidth
           }
       }

       @IBInspectable var cornerRadius: CGFloat {
           set {
               layer.cornerRadius = newValue
           }
           get {
               return layer.cornerRadius
           }
       }

       @IBInspectable var borderColor: UIColor? {
           set {
               guard let uiColor = newValue else { return }
               layer.borderColor = uiColor.cgColor
           }
           get {
               guard let color = layer.borderColor else { return nil }
               return UIColor(cgColor: color)
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Constants.IpadScreen {
            self.titleLabel?.font = self.titleLabel?.font.withSize(28)
            self.layer.borderWidth = 2
        }
        self.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
    }
    
    @objc func btnPressed() {
        UIView.animate(withDuration: 0.01, animations: {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (finish: Bool) in
            UIView.animate(withDuration: 0.05, animations: {
                self.transform = CGAffineTransform.identity
            })
        })

        showPopup()
    }

    private func showPopup() {
        guard let superview = self.superview else { return }

        // Create the popup with the exact appearance of the button
        let popup = ButtonPopupAnimation(button: self)
        popup.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(popup)

        // Set constraints to match the button's size and position the popup above the button
        NSLayoutConstraint.activate([
            popup.widthAnchor.constraint(equalTo: self.widthAnchor),
            popup.heightAnchor.constraint(equalTo: self.heightAnchor),
            popup.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            popup.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 5)
        ])

        // Fade-in animation
        UIView.animate(withDuration: 0.05, animations: {
            popup.alpha = 1.0
        }, completion: { _ in
            // Delay for 0.1 seconds before fading out
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.05, animations: {
                    popup.alpha = 0.0
                }, completion: { _ in
                    popup.removeFromSuperview()
                })
            }
        })
    }
}

