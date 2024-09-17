//
//  CustomKeyboardVC.swift
//  CustomKeyboard
//
//  Created by Yudiz Solutions Ltd on 20/02/23.
//

import UIKit

class CustomKeyboardVC: UIViewController, CustomKeyboardViewDelegate {
    
    
    ///Outlets
    @IBOutlet weak var textField: UITextField!
    ///Variables
    var customKeyboardView: CustomKeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add CustomKeyboardView to the input view of text field
        let nib = UINib(nibName: "CustomKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        customKeyboardView = objects.first as? CustomKeyboardView
        customKeyboardView.delegate = self
        
        let keyboardContainerView = UIView(frame: customKeyboardView.frame)
        keyboardContainerView.addSubview(customKeyboardView)
        textField.inputView = keyboardContainerView
    }
    
    
}

//MARK: - Delegate Methods
extension CustomKeyboardVC {
    func insertCharacter(_ newCharacter: String) {
        textField.insertText(newCharacter)
    }
    
    func removeCharacter() {
        textField.deleteBackward()
    }
    
    func dismissKeyboard(){
        textField.endEditing(true)
    }
    
    func colonButtonTapped() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textField.insertText(":")
        }else{
            textField.insertText(";")
        }
    }
    
    func hyphenButtonTapped() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textField.insertText("_")
        }else{
            textField.insertText("-")
        }
    }
    
    func leftArrowButtonClicked() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textField.insertText("<")
        }else{
            textField.insertText(",")
        }
    }
    
    func rightArrowButtonClicked() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textField.insertText(">")
        }else{
            textField.insertText(".")
        }
    }
    
    func questionButtonClicked() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textField.insertText("?")
        }else{
            textField.insertText("/")
        }
    }
    
    func enterButtonClicked(){
        textField.text! += "\n"
    }
    
    func moveArrowLeftButton(){
        if let textField = textField {
                if let selectedRange = textField.selectedTextRange {
                    let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
                    if cursorPosition > 0 {
                        let newPosition = textField.position(from: selectedRange.start, offset: -1)
                        textField.selectedTextRange = textField.textRange(from: newPosition!, to: newPosition!)
                    }
                }
            }
    }
    
    func specialFbutton() {
        textField.text! += "%"
    }
    func specialGbutton() {
        if customKeyboardView.isThirdCapsUppercase == true{
            textField.insertText("A")
        }else{
            textField.insertText("a")
        }
    }
    func specialKbutton() {
        textField.text! += "|"
    }
    func specialMbutton() {
        textField.text! += "☎️"
    }
    func specialPbutton() {
        textField.text! += "★"
    }
    func specialQbutton() {
        textField.text! += "☆"
    }
    func specialBbutton() {
        textField.text! += "ß"
    }
    func smileyButton() {
        textField.text! += ":-)"
    }
    func closeKeyboard() {
        
    }
    
    func configurePopupView(_ popupView: UIStackView) {
        popupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        popupView.isLayoutMarginsRelativeArrangement = true
        popupView.layer.borderColor = UIColor.lightGray.cgColor
        popupView.layer.borderWidth = 2.0
        popupView.layer.cornerRadius = 5
        popupView.isHidden = false
        customKeyboardView.OverlayView.isHidden = false
    }
    
    func openMainApp() {
        // Create a URL with the custom scheme 'abkeyapp'
        guard let url = URL(string: "abkeyapp://") else { return }

        // Attempt to open the URL using the extension context
        extensionContext?.open(url, completionHandler: { success in
            if !success {
                // If the URL couldn't be opened, check the responder chain
                var responder = self as UIResponder?
                while responder != nil {
                    let selectorOpenURL = NSSelectorFromString("openURL:")
                    if responder?.responds(to: selectorOpenURL) == true {
                        _ = responder?.perform(selectorOpenURL, with: url)
                        return
                    }
                    responder = responder?.next
                }
                print("Failed to open URL: \(url)")
            } else {
                print("Successfully opened URL: \(url)")
            }
        })

    }
    
}
