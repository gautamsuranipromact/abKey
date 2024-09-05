//
//  HomePageVC.swift
//  AbKey
//
//  Created by Divyanah on 15/03/24.
//

import UIKit
import StoreKit

class HomePageVC: UIViewController {
    
    @IBOutlet var btnCollections: [UIButton]!
    
    @IBOutlet weak var lblAppTitle: UILabel!
    
//    @IBOutlet weak var imgBackround: UIImageView!
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblAbKeySetting: UILabel!
    
    @IBOutlet weak var viewAbKeySetting: UIView!
    @IBOutlet weak var viewAbSettingAndLanguage: UIView!
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnDefaultSet: UIButton!
    @IBOutlet weak var btnStartAbKey: UIButton!
    @IBOutlet weak var btnAbKeySetting: UIButton!
    @IBOutlet weak var btnPremium: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    var premium = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyRoundedCorners(to: lblAppTitle)
        self.applyRoundedCorners(to: viewAbKeySetting)
        
//        for button in btnCollections {
//            button.applyGradient(colors: [
//                UIColor(red: 154/255, green: 161/255, blue: 204/255, alpha: 1.00).cgColor,
//                UIColor(red: 85/255, green: 93/255, blue: 147/255, alpha: 1.00).cgColor
//            ])
//        }
        
        self.applyGradientBackground(colors: [UIColor(red: 94/255, green: 105/255, blue: 132/255, alpha: 1.00).cgColor,UIColor(red: 11/255, green: 28/255, blue: 68/255, alpha: 1.00).cgColor])

        let attributedString = attributedTextWithIcons()
        lblAbKeySetting.attributedText = attributedString
    }
    
    func attributedTextWithIcons() -> NSAttributedString {
        let keyboardIconImage = UIImage(named: "Keyboard")
        let textWithKeyboardIcon = "To open abKey Pro Settings from abKey Pro input method, Press & Hold keyboard icon "
        
        let keyboardAttachment = NSTextAttachment()
        keyboardAttachment.image = keyboardIconImage
        keyboardAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20) // Adjust bounds as needed
        
        let keyboardAttachmentString = NSAttributedString(attachment: keyboardAttachment)
        let keyboardAttributedText = NSMutableAttributedString(string: textWithKeyboardIcon)
        keyboardAttributedText.append(keyboardAttachmentString)
        
        // Combine text with setting icon
        let settingIconImage = UIImage(named: "numeric_settings")
        let textWithSettingIcon = "OR press setting icon "
        
        let settingAttachment = NSTextAttachment()
        settingAttachment.image = settingIconImage
        settingAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20) // Adjust bounds as needed
        
        let settingAttachmentString = NSAttributedString(attachment: settingAttachment)
        let settingAttributedText = NSMutableAttributedString(string: textWithSettingIcon)
        settingAttributedText.append(settingAttachmentString)
        
        keyboardAttributedText.append(settingAttributedText)
        
        return keyboardAttributedText
    }

    func applyGradientBackground(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.frame = viewBackground.bounds // Set initial frame
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        // Add gradient layer to the view's layer
        viewBackground.layer.insertSublayer(gradientLayer, at: 0)

        // Observe changes to bounds and update the gradient layer frame accordingly
        observeBoundsChanges()
    }

    private var boundsObservation: NSKeyValueObservation?

    private func observeBoundsChanges() {
        boundsObservation = viewBackground.observe(\.bounds, options: [.new]) { [weak self] _, _ in
            self?.updateGradientLayerFrame()
        }
    }

    private func updateGradientLayerFrame() {
        if let gradientLayer = viewBackground.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = viewBackground.bounds
        }
    }

    @IBAction func btnSettingAction(_ sender: Any) {
//        print("setting button clicked")
        if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                   if UIApplication.shared.canOpenURL(settingsURL) {
                       UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func promptToChangeKeyboard() {
           let alertController = UIAlertController(title: "Change Keyboard",
                                                   message: "Would you like to change your keyboard to a specific one?",
                                                   preferredStyle: .alert)
           
           alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
               if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
               }
           }))
           
           alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           present(alertController, animated: true, completion: nil)
       }
    
    func presentActivityController() {
            let textToShare = "abKey Typing Test" // Replace this with your actual text

            let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [] // You can exclude specific activities if needed

            // For iPad support
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = view
                popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }

            present(activityViewController, animated: true, completion: nil)
        }
    
    @IBAction func btnDefaultSetAction(_ sender: Any) {
//        print("default setting clicked")
        self.promptToChangeKeyboard()
    }
    
    @IBAction func btnStartAbKey(_ sender: Any) {
//        print("abkey buttom clicked")
        presentActivityController()
    }
    
    @IBAction func btnAbkeySettings(_ sender: Any) {
        print("abkey buttom clicked")
        if let vc = storyboard!.instantiateViewController(withIdentifier: "AbKeySettingVC") as? AbKeySettingVC {
                vc.premiumValueFromHomePageVC = premium // Pass the premium value here
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func btnPremiumAction(_ sender: Any) {
        premium = 1
        print("premium action buttom clicked")
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        print("close buttom clicked")
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
}

extension HomePageVC{
    func applyRoundedCorners(to view: UIView) {
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIButton {
    func applyGradientToButton(colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = bounds // Set initial frame

        // Observe changes to bounds and update the gradient layer frame accordingly
        addObserver(self, forKeyPath: "bounds", options: .new, context: nil)

        layer.insertSublayer(gradientLayer, at: 0)
    }
}
