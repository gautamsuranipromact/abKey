//
//  HomePageVC.swift
//  AbKey
//
//  Created by Divyanah on 15/03/24.
//

import UIKit
import StoreKit

class HomePageVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet var btnCollections: [UIButton]!
    
    @IBOutlet weak var lblAppTitle: UILabel!
    
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
    var premiumProduct: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        premium = UserDefaults(suiteName: Constants.AppGroupSuiteName)?.integer(forKey: Constants.PremiumUserKey) ?? 0
        
        self.applyRoundedCorners(to: lblAppTitle)
        self.applyRoundedCorners(to: viewAbKeySetting)
        
        // Set up in-app purchase
        SKPaymentQueue.default().add(self)
        fetchPremiumProduct()

        // Check if the user already purchased premium and restore if needed
        checkAndRestorePurchases()
        
        let gradientColors = [
            UIColor(red: 154/255, green: 161/255, blue: 204/255, alpha: 1.00),
            UIColor(red: 85/255, green: 93/255, blue: 147/255, alpha: 1.00)
        ]

        // Ensure buttons are properly laid out before applying gradient
        DispatchQueue.main.async {
            self.setGradientBackground(for: self.btnCollections, colors: gradientColors)
        }

        self.applyGradientBackground(colors: [UIColor(red: 94/255, green: 105/255, blue: 132/255, alpha: 1.00).cgColor,UIColor(red: 11/255, green: 28/255, blue: 68/255, alpha: 1.00).cgColor])

        let attributedString = attributedTextWithIcons()
        lblAbKeySetting.attributedText = attributedString
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SKPaymentQueue.default().remove(self)
    }

    private var boundsObservation: NSKeyValueObservation?

    // Observes changes to the bounds property of the viewBackground.
    private func observeBoundsChanges() {
        boundsObservation = viewBackground.observe(\.bounds, options: [.new]) { [weak self] _, _ in
            self?.updateGradientLayerFrame()
        }
    }

    // Updates the frame of the gradient layer to match the current bounds of the viewBackground.
    private func updateGradientLayerFrame() {
        if let gradientLayer = viewBackground.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = viewBackground.bounds
        }
    }

    @IBAction func btnSettingAction(_ sender: Any) {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
                   if UIApplication.shared.canOpenURL(settingsURL) {
                       UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // Preset a prompt to change the default keyboard
    func promptToChangeKeyboard() {
        let alertController = UIAlertController(title: "Change Keyboard",
                                                message: Constants.ChangeKeyboardPromptMsg,
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
        let textToShare = Constants.AbKeyTypingTestMsg // Replace this with your actual text
        
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
        self.promptToChangeKeyboard()
    }
    
    @IBAction func btnStartAbKey(_ sender: Any) {
        presentActivityController()
    }
    
    // Ab Key setting button action
    @IBAction func btnAbkeySettings(_ sender: Any) {
        if let vc = storyboard!.instantiateViewController(withIdentifier: Constants.AbKeySettingVCIdentifier) as? AbKeySettingVC {
                vc.premiumValueFromHomePageVC = premium // Pass the premium value here
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    // Upgrade to premium action
    @IBAction func btnPremiumAction(_ sender: Any) {
        if premium == 1 {
            // Show an alert informing the user that they already have premium
            let alert = UIAlertController(title: "Already Premium",
                                          message: Constants.AlreadyPurchasedPremiumMsg,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Proceed with the purchase if user is not premium
        guard let product = premiumProduct else {
            print("Premium product not available")
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // Send the app to background
    @IBAction func btnCloseAction(_ sender: Any) {
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
    }
}

//MARK: In App Purchase Implementation
extension HomePageVC {
    // Fetch the premium product from App Store
    func fetchPremiumProduct() {
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: [Constants.PremiumProductIdentifier])
            productRequest.delegate = self
            productRequest.start()
        } else {
            print("In-app purchases are disabled on this device.")
        }
    }
    
    // SKProductsRequestDelegate - Receive the available products
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            premiumProduct = product
            print("Premium product available: \(product.localizedTitle) - \(product.price)")
        }
    }
    
    // Check whether user has already purchased premium
    func checkAndRestorePurchases() {
        if premium == 1 {
            // If the user already has premium saved in UserDefaults, no need to restore
            print("Premium already purchased, no need to restore.")
        } else {
            // If premium isn't saved, attempt to restore purchases
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
    }
    
    // SKPaymentTransactionObserver - Handle completed transactions
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completePurchase()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                completePurchase()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let error = transaction.error {
                    print("Transaction failed: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    // Update user default to reflect premium status
    func completePurchase() {
        premium = 1
        let sharedDefaults = UserDefaults(suiteName: Constants.AppGroupSuiteName)
        sharedDefaults?.set(premium, forKey: Constants.PremiumUserKey)
        print("Premium purchase completed and saved!")
    }
}

//MARK: Utility functionas
extension HomePageVC {
    // Applies rounded corners to a given view
    func applyRoundedCorners(to view: UIView) {
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
    }
    
    // Sets a gradient background for an array of buttons.
    func setGradientBackground(for buttons: [UIButton], colors: [UIColor]) {
        for button in buttons {
            // Ensure the button's size is valid
            let buttonSize = button.bounds.size
            if buttonSize.width > 0 && buttonSize.height > 0 {
                if let gradientImage = createGradientImage(size: buttonSize, colors: colors) {
                    button.setBackgroundImage(gradientImage, for: .normal)
                }
            }
        }
    }
    
    // converting gradient to image
    func createGradientImage(size: CGSize, colors: [UIColor], locations: [NSNumber]? = nil) -> UIImage? {
        guard size.width > 0 && size.height > 0 else { // Ensuring size is valid
            return nil
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        gradientLayer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    // Creating attributed text with icons
    func attributedTextWithIcons() -> NSAttributedString {
        let keyboardIconImage = UIImage(named: Constants.KeyboardImg)
        let textWithKeyboardIcon = Constants.AttributedTextWithKeyboardIcon
        
        let keyboardAttachment = NSTextAttachment()
        keyboardAttachment.image = keyboardIconImage
        keyboardAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
        
        let keyboardAttachmentString = NSAttributedString(attachment: keyboardAttachment)
        let keyboardAttributedText = NSMutableAttributedString(string: textWithKeyboardIcon)
        keyboardAttributedText.append(keyboardAttachmentString)
        
        // Combine text with setting icon
        let settingIconImage = UIImage(named: Constants.NumericSettingsImg)
        let textWithSettingIcon = Constants.AttributedTextWithSettingIcon
        
        let settingAttachment = NSTextAttachment()
        settingAttachment.image = settingIconImage
        settingAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20) // Adjust bounds as needed
        
        let settingAttachmentString = NSAttributedString(attachment: settingAttachment)
        let settingAttributedText = NSMutableAttributedString(string: textWithSettingIcon)
        settingAttributedText.append(settingAttachmentString)
        
        keyboardAttributedText.append(settingAttributedText)
        
        return keyboardAttributedText
    }
    
    // Creating desired backgroup with gradients
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
}

//MARK: UIColor extension that initializes a color from a hex string.
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

//MARK: Apply gradient background to buttons
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
