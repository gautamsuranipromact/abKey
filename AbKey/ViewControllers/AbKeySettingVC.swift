//
//  AbKeySettingVC.swift
//  AbKey
//
//  Created by Divyanah on 18/03/24.
//

import UIKit

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
    
    var viewSpace = 0
    var quickFixes = 0
    
    var premiumValueFromHomePageVC: Int = 0

    let sharedDefaults = UserDefaults(suiteName: "group.abKey.promact")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSpaceWillSelect.isHidden = true
        viewCorrectsCommonly.isHidden = true
        
        if premiumValueFromHomePageVC >= 1{
            lblHeadingTitle.text = "abKey Pro(Premium)"
            lblAbkeyTitle.text = "abKey Pro(Premium)"
        }else{
            lblHeadingTitle.text = "abKey Pro(Lite)"
            lblAbkeyTitle.text = "abKey Pro(Lite)"
        }
        
        print(premiumValueFromHomePageVC)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isTrEnabled = sharedDefaults?.bool(forKey: "isTrEnabled") ?? false
        updateTrFunctionalityUI(isTrEnabled: isTrEnabled)
        
        let isTPlusEnabled = sharedDefaults?.bool(forKey: "isTPlusEnabled") ?? false
        updateTPlusFunctionalityUI(isTPlusEnabled: isTPlusEnabled)
        
        let isRTPlusManager = sharedDefaults?.bool(forKey: "isRTPlusManager") ?? false
        updateRTPlusManagerUI(isRTPlusManager: isRTPlusManager)
    }

    func updateTrFunctionalityUI(isTrEnabled: Bool) {
        if isTrEnabled {
            imgViewCheck.image = UIImage(named: "check_square")
            lblTr.text = "Uncheck to disable Tr function"
        } else {
            imgViewCheck.image = UIImage(systemName: "square")
            lblTr.text = "Check to enable Tr function"
        }
    }
    
    func updateTPlusFunctionalityUI(isTPlusEnabled: Bool) {
        if isTPlusEnabled {
            imgViewTplus.image = UIImage(named: "check_square")
            lblTPlus.text = "Uncheck to disable T+ function"
        } else {
            imgViewTplus.image = UIImage(systemName: "square")
            lblTPlus.text = "Check to enable T+ function"
        }
    }
    
    func  updateRTPlusManagerUI(isRTPlusManager: Bool) {
        if isRTPlusManager {
            imgViewRTPlusManager.image = UIImage(named: "check_square")
            lblRTPlusManager.text = "Uncheck to disable rT+ Manager from keyboard"
        } else {
            imgViewRTPlusManager.image = UIImage(systemName: "square")
            lblRTPlusManager.text = "Check to enable rT+ Manager from keyboard"
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAutoSelect(_ sender: Any) {
        print("btton clicked")
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
        print("button clicked")

        let isTrEnabled = !(sharedDefaults?.bool(forKey: "isTrEnabled") ?? false)
        sharedDefaults?.set(isTrEnabled, forKey: "isTrEnabled")
        updateTrFunctionalityUI(isTrEnabled: isTrEnabled)
    }
    
    @IBAction func btnTPlusEnable(_ sender: Any){
        print("tplus clicked")
        
        let isTPlusEnabled = !(sharedDefaults?.bool(forKey: "isTPlusEnabled") ?? false)
        sharedDefaults?.set(isTPlusEnabled, forKey: "isTPlusEnabled")
        updateTPlusFunctionalityUI(isTPlusEnabled: isTPlusEnabled)
    }
    
    @IBAction func btnRTPlusManager(_ sender: Any){
        
        let isRTPlusManager = !(sharedDefaults?.bool(forKey: "isRTPlusManager") ?? false)
        sharedDefaults?.set(isRTPlusManager, forKey: "isRTPlusManager")
        updateRTPlusManagerUI(isRTPlusManager: isRTPlusManager)
    }
    
    @IBAction func btnRTShowReplaceDelete(_ sender: Any){
        if let vc = storyboard!.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController {
                vc.premiumValueFromRTPlusManager = premiumValueFromHomePageVC // Pass the premium value here
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @IBAction func btnBackupAction(_ sender: Any) {
        // Ensure this runs on the main thread
            DispatchQueue.main.async {
                guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.abKey.promact") else {
                    print("App Group container is not available.")
                    return
                }
                
                let fileURL = containerURL.appendingPathComponent("CustomKeyboard.sqlite")

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
        // Present a document picker to select the backup file
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = .formSheet
            self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func aboutABKeyAction(_ sender: Any) {
        if let vc = storyboard!.instantiateViewController(withIdentifier: "AboutAbkeyVC") as? AboutAbkeyVC {
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
        
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.abKey.promact") else {
            print("App Group container is not available.")
            return
        }
        
        let destinationURL = containerURL.appendingPathComponent("CustomKeyboard.sqlite")
        
        // Replace the existing database with the selected one
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: selectedFileURL, to: destinationURL)
            print("Database restored successfully.")
        } catch {
            print("Error restoring database: \(error.localizedDescription)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }
}
