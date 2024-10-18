//
//  AbKeySettingVC.swift
//  AbKey
//
//  Created by Divyanah on 18/03/24.
//

import UIKit
import UniformTypeIdentifiers

class AbKeySettingVC: UIViewController {

    @IBOutlet weak var viewAutoSelect: UIView!
    @IBOutlet weak var viewSpaceWillSelect: UIView!
    @IBOutlet weak var viewCorrectsCommonly: UIView!
    
    @IBOutlet weak var lblTr: UILabel!
    @IBOutlet weak var imgViewCheck: UIImageView!
    
    @IBOutlet weak var lblTPlus: UILabel!
    @IBOutlet weak var imgViewTplus: UIImageView!
    
    @IBOutlet weak var lblRTPlusManager: UILabel!
    @IBOutlet weak var imgViewRTPlusManager: UIImageView!
        
    @IBOutlet weak var lblHeadingTitle: UILabel!
    @IBOutlet weak var lblAbkeyTitle: UILabel!
    
    @IBOutlet weak var imgViewAutoCapitalizationManager: UIImageView!
    
    var viewSpace = 0
    var quickFixes = 0
    
    var premiumValueFromHomePageVC: Int = 0

    let sharedDefaults = UserDefaults(suiteName: Constants.AppGroupSuiteName)
    var enableAutoCapitalization = UserDefaults(suiteName: Constants.AppGroupSuiteName)?.bool(forKey: Constants.AutoCapitalizationKey) ?? false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSpaceWillSelect.isHidden = true
        viewCorrectsCommonly.isHidden = true
        
        if premiumValueFromHomePageVC >= 1{
            lblHeadingTitle.text = Constants.PremiumUserHeading
            lblAbkeyTitle.text = Constants.PremiumUserHeading
        }else{
            lblHeadingTitle.text = Constants.LiteUserHeading
            lblAbkeyTitle.text = Constants.LiteUserHeading
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isTrEnabled = sharedDefaults?.bool(forKey: Constants.TrEnabledKey) ?? false
        updateTrFunctionalityUI(isTrEnabled: isTrEnabled)
        
        let isTPlusEnabled = sharedDefaults?.bool(forKey: Constants.TPlusEnabledKey) ?? false
        updateTPlusFunctionalityUI(isTPlusEnabled: isTPlusEnabled)
        
        let isRTPlusManager = sharedDefaults?.bool(forKey: Constants.RTPlusEnabledKey) ?? false
        updateRTPlusManagerUI(isRTPlusManager: isRTPlusManager)
        
        let isAutoCapEnabled = sharedDefaults?.bool(forKey: Constants.AutoCapitalizationKey) ?? false
        updateAutoCapFunctionalityUI(isAutoCapEnabled: isAutoCapEnabled)
    }

    func updateTrFunctionalityUI(isTrEnabled: Bool) {
        if isTrEnabled {
            imgViewCheck.image = UIImage(named: Constants.CheckSquareImg)
            lblTr.text = Constants.DisableTrFunctionMsg
        } else {
            imgViewCheck.image = UIImage(systemName: Constants.SquareImg)
            lblTr.text = Constants.EnableTrFunctionMsg
        }
    }
    
    func updateTPlusFunctionalityUI(isTPlusEnabled: Bool) {
        if isTPlusEnabled {
            imgViewTplus.image = UIImage(named: Constants.CheckSquareImg)
            lblTPlus.text = Constants.DisableTPlusFunctionMsg
        } else {
            imgViewTplus.image = UIImage(systemName: Constants.SquareImg)
            lblTPlus.text = Constants.EnableTPlusFunctionMsg
        }
    }
    
    func  updateRTPlusManagerUI(isRTPlusManager: Bool) {
        if isRTPlusManager {
            imgViewRTPlusManager.image = UIImage(named: Constants.CheckSquareImg)
            lblRTPlusManager.text = Constants.DisableRTPlusManagerMsg
        } else {
            imgViewRTPlusManager.image = UIImage(systemName: Constants.SquareImg)
            lblRTPlusManager.text = Constants.EnableRTPlusManagerMsg
        }
    }
    
    func updateAutoCapFunctionalityUI(isAutoCapEnabled: Bool) {
        if(isAutoCapEnabled){
            imgViewAutoCapitalizationManager.image = UIImage(named: Constants.CheckSquareImg)
        }
        else{
            imgViewAutoCapitalizationManager.image = UIImage(systemName: Constants.SquareImg)
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAutoSelect(_ sender: Any) {
        viewSpace = 1
        
        if(viewSpace == 1){
            viewSpaceWillSelect.isHidden = false
        }else{
            viewSpaceWillSelect.isHidden = false
        }
        viewSpace = 0
    }
    
    @IBAction func btnQuickFixes(_ sender: Any){
        quickFixes = 1
        if(quickFixes == 1){
            viewCorrectsCommonly.isHidden = false
        }else{
            viewCorrectsCommonly.isHidden = false
        }
        quickFixes = 0
    }
    
    @IBAction func btnTrEnable(_ sender: Any) {
        let isTrEnabled = !(sharedDefaults?.bool(forKey: Constants.TrEnabledKey) ?? false)
        sharedDefaults?.set(isTrEnabled, forKey: Constants.TrEnabledKey)
        updateTrFunctionalityUI(isTrEnabled: isTrEnabled)
    }
    
    @IBAction func btnTPlusEnable(_ sender: Any){
        let isTPlusEnabled = !(sharedDefaults?.bool(forKey: Constants.TPlusEnabledKey) ?? false)
        sharedDefaults?.set(isTPlusEnabled, forKey: Constants.TPlusEnabledKey)
        updateTPlusFunctionalityUI(isTPlusEnabled: isTPlusEnabled)
    }
    
    @IBAction func btnRTPlusManager(_ sender: Any){
        let isRTPlusManager = !(sharedDefaults?.bool(forKey: Constants.RTPlusEnabledKey) ?? false)
        sharedDefaults?.set(isRTPlusManager, forKey: Constants.RTPlusEnabledKey)
        updateRTPlusManagerUI(isRTPlusManager: isRTPlusManager)
    }
    
    
    @IBAction func btnAutoCapitalizationManager(_ sender: Any) {
        let isAutoCapitalizationEnabled = !(sharedDefaults?.bool(forKey: Constants.AutoCapitalizationKey) ?? false)
        sharedDefaults?.setValue(isAutoCapitalizationEnabled, forKey: Constants.AutoCapitalizationKey)
        updateAutoCapFunctionalityUI(isAutoCapEnabled: isAutoCapitalizationEnabled)
    }
    
    @IBAction func btnRTShowReplaceDelete(_ sender: Any){
        if let vc = storyboard!.instantiateViewController(withIdentifier: Constants.SettingVCIdentifier) as? SettingViewController {
                vc.premiumValueFromRTPlusManager = premiumValueFromHomePageVC // Pass the premium value here
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func btnBackupAction(_ sender: Any) {
        // Ensure this runs on the main thread
            DispatchQueue.main.async {
                guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppGroupSuiteName) else {
                    print("App Group container is not available.")
                    return
                }
                
                let fileURL = containerURL.appendingPathComponent(Constants.DBFileName)

                // Check if file exists to avoid sharing nonexistent file
                guard FileManager.default.fileExists(atPath: fileURL.path) else {
                    print("Database file does not exist.")
                    return
                }
                
                let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
                
                // If you're using this code in a UIViewController subclass
                self.present(activityViewController, animated: true, completion: nil)
                
                // For iPad, you might need to configure the popover presentation controller
                if let popoverController = activityViewController.popoverPresentationController {
                    popoverController.sourceView = self.view // or UIButton instance
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = [] // No arrow
                }
            }
    }
    
    @IBAction func btnRestoreAction(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func aboutABKeyAction(_ sender: Any) {
        if let vc = storyboard!.instantiateViewController(withIdentifier: Constants.AboutAbKeyVCIdentifier) as? AboutAbkeyVC {
                vc.premiumValueFromAboutAbkeyVC = premiumValueFromHomePageVC // Pass the premium value here
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
}

// Conform to UIDocumentPickerDelegate
extension AbKeySettingVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            print("No file selected.")
            return
        }
        
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.AppGroupSuiteName) else {
            print("App Group container is not available.")
            return
        }
        
        let destinationURL = containerURL.appendingPathComponent(Constants.DBFileName)
        
        // Replace the existing database with the selected one
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: selectedFileURL, to: destinationURL)
            
            // Show alert to notify the user to close and reopen the app
            showRestartAlert()
            
        } catch {
            print("Error restoring database: \(error.localizedDescription)")
        }
    }

    func showRestartAlert() {
        let alert = UIAlertController(title: "Restart Required", message: Constants.RestartApplicationMsg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        // Add a "Learn How" button for users unfamiliar with force quitting apps
        let learnHowAction = UIAlertAction(title: "Learn How", style: .default) { _ in
            self.showInstructionsForRestart()
        }
        
        alert.addAction(okAction)
        alert.addAction(learnHowAction)
        
        present(alert, animated: true, completion: nil)
    }

    // A separate alert to guide the user on how to restart the app
    func showInstructionsForRestart() {
        let alert = UIAlertController(
            title: "How to Restart",
            message: Constants.RestartApplicationProcessMsg,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Got It", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }
}
