//
//  KeyboardViewController.swift
//  CustomKeyboardView
//
//  Created by Divyanah on 10/01/24.
//

import UIKit

class KeyboardViewController: UIInputViewController,CustomKeyboardViewDelegate{
    
    var customKeyboardView: CustomKeyboardView!
    var lexicon: UILexicon?
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        // Add CustomKeyboardView to the input view
        let nib = UINib(nibName: Constants.CustomKeyboardNibIdentifier, bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        customKeyboardView = objects.first as? CustomKeyboardView
        customKeyboardView.delegate = self
        
        guard let inputView = inputView else { return }
        inputView.addSubview(customKeyboardView)
        customKeyboardView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customKeyboardView.leftAnchor.constraint(equalTo: inputView.leftAnchor),
            customKeyboardView.topAnchor.constraint(equalTo: inputView.topAnchor),
            customKeyboardView.rightAnchor.constraint(equalTo: inputView.rightAnchor),
            customKeyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor)
          ])

        requestSupplementaryLexicon { lexicon in
          self.lexicon = lexicon
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}

//MARK: Insert or remove a character
extension KeyboardViewController {
    func insertCharacter(_ newCharacter: String) {
        if customKeyboardView.TPlusPopupView.isHidden == false {
            customKeyboardView.TPlusViewTextField.insertText(newCharacter)
        }
        else{
            textDocumentProxy.insertText(newCharacter)
        }
    }
    
    func removeCharacter() {
        if(customKeyboardView.TPlusPopupView.isHidden == false) {
            customKeyboardView.TPlusViewTextField.deleteBackward()
        }
        else{
            textDocumentProxy.deleteBackward()
        }
    }
}

//MARK: - For text replace UILexicon
extension KeyboardViewController {
    func replaceWord() {
        if let entries = lexicon?.entries,
           let currentWord = textDocumentProxy.documentContextBeforeInput?.lowercased() {
            let replaceEntries = entries.filter {
                $0.userInput.lowercased() == currentWord
            }
            if let replacement = replaceEntries.first {
                for _ in 0..<currentWord.count {
                    textDocumentProxy.deleteBackward()
                }
                textDocumentProxy.insertText(replacement.documentText)
            }
        }
    }
}

// MARK: Utility functions
extension KeyboardViewController{
    func colonButtonTapped() {
        if(!customKeyboardView.TPlusPopupView.isHidden) {
            if customKeyboardView.isFirstCapsUppercase == true{
                customKeyboardView.TPlusViewTextField.insertText(":")
            }else{
                customKeyboardView.TPlusViewTextField.insertText(";")
            }
        }
        else{
            if customKeyboardView.isFirstCapsUppercase == true{
                textDocumentProxy.insertText(":")
            }else{
                textDocumentProxy.insertText(";")
            }
        }
    }
    
    func hyphenButtonTapped() {
        if(!customKeyboardView.TPlusPopupView.isHidden) {
            if customKeyboardView.isFirstCapsUppercase == true{
                customKeyboardView.TPlusViewTextField.insertText("_")
            }else{
                customKeyboardView.TPlusViewTextField.insertText("-")
            }
        }
        else{
            if customKeyboardView.isFirstCapsUppercase == true{
                textDocumentProxy.insertText("_")
            }else{
                textDocumentProxy.insertText("-")
            }
        }
    }
    
    func leftArrowButtonClicked() {
        if(!customKeyboardView.TPlusPopupView.isHidden) {
            if customKeyboardView.isFirstCapsUppercase == true{
                customKeyboardView.TPlusViewTextField.insertText("<")
            }else{
                customKeyboardView.TPlusViewTextField.insertText(",")
            }
        }
        else{
            if customKeyboardView.isFirstCapsUppercase == true{
                textDocumentProxy.insertText("<")
            }else{
                textDocumentProxy.insertText(",")
            }
        }
    }
    
    func rightArrowButtonClicked() {
        if(!customKeyboardView.TPlusPopupView.isHidden) {
            if customKeyboardView.isFirstCapsUppercase == true{
                customKeyboardView.TPlusViewTextField.insertText(">")
            }else{
                customKeyboardView.TPlusViewTextField.insertText(".")
            }
        }
        else{
            if customKeyboardView.isFirstCapsUppercase == true{
                textDocumentProxy.insertText(">")
            }else{
                textDocumentProxy.insertText(".")
            }
        }
    }
    
    func questionButtonClicked() {
        if(!customKeyboardView.TPlusPopupView.isHidden) {
            if customKeyboardView.isFirstCapsUppercase == true{
                customKeyboardView.TPlusViewTextField.insertText("?")
            }else{
                customKeyboardView.TPlusViewTextField.insertText("/")
            }
        }
        else{
            if customKeyboardView.isFirstCapsUppercase == true{
                textDocumentProxy.insertText("?")
            }else{
                textDocumentProxy.insertText("/")
            }
        }
    }
    
    func enterButtonClicked() {
        if(!customKeyboardView.TPlusPopupView.isHidden){
            customKeyboardView.TPlusViewTextField.insertText("\n")
        }
        else{
            textDocumentProxy.insertText("\n")
        }
    }
        
    func moveArrowLeftButton() {
        textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
    }
        
    func moveArrowRightButton() {
        textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
    }
    
    func specialFbutton() {
        if(!customKeyboardView.TPlusPopupView.isHidden){
            customKeyboardView.TPlusViewTextField.insertText("%")
        }
        else{
            textDocumentProxy.insertText("%")
        }
    }
    
    func specialGbutton() {
        if(!customKeyboardView.TPlusPopupView.isHidden) {
            if(customKeyboardView.isThirdCapsUppercase){
                customKeyboardView.TPlusViewTextField.insertText("A")
            }
            else{
                customKeyboardView.TPlusViewTextField.insertText("a")
            }
        }
        else{
            if(customKeyboardView.isThirdCapsUppercase) {
                textDocumentProxy.insertText("A")
            }
            else{
                textDocumentProxy.insertText("a")
            }
        }
    }
    
    func specialKbutton() {
        if(!customKeyboardView.TPlusPopupView.isHidden){
            customKeyboardView.TPlusViewTextField.insertText("|")
        }
        else{
            textDocumentProxy.insertText("|")
        }
    }
    
    func specialMbutton() {
        if(!customKeyboardView.TPlusPopupView.isHidden){
            customKeyboardView.TPlusViewTextField.insertText("☎️")
        }
        else{
            textDocumentProxy.insertText("☎️")
        }
    }
    
    func specialPbutton() {
        if(!customKeyboardView.TPlusPopupView.isHidden){
            customKeyboardView.TPlusViewTextField.insertText("★")
        }
        else{
            textDocumentProxy.insertText("★")
        }
    }
    
    func specialQbutton() {
        if(!customKeyboardView.TPlusPopupView.isHidden){
            customKeyboardView.TPlusViewTextField.insertText("☆")
        }
        else{
            textDocumentProxy.insertText("☆")
        }
    }
    
    func specialBbutton() {
        if(!customKeyboardView.TPlusPopupView.isHidden){
            customKeyboardView.TPlusViewTextField.insertText("ß")
        }
        else{
            textDocumentProxy.insertText("ß")
        }
    }
    
    func smileyButton() {
        if(!customKeyboardView.TPlusPopupView.isHidden){
            customKeyboardView.TPlusViewTextField.insertText("🙂")
        }
        else{
            textDocumentProxy.insertText("🙂")
        }
    }
    
    func closeKeyboard() {
        self.dismissKeyboard()
    }
    
    func configureLongPressPopupView(_ popupView: UIStackView) {
        popupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        popupView.isLayoutMarginsRelativeArrangement = true
        popupView.layer.borderColor = UIColor.lightGray.cgColor
        popupView.layer.borderWidth = 2.0
        popupView.layer.cornerRadius = 5
        popupView.isHidden = false
        customKeyboardView.OverlayView.isHidden = false
    }
    
    // Open main application from its url scheme
    func openMainApp(_ hostValue: String) {
        guard let url = URL(string: "\(Constants.AppUrlSchemeIdentifier)\(hostValue)") else { return }
        
        openURL(url)
    }
    
    // Navigate to the main app using its url scheme
    @discardableResult
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(url, options: [:]) { success in
                    if success {
                        print("App opened successfully")
                    } else {
                        print("Failed to open app")
                    }
                }
                return true
            }
            responder = responder?.next
        }
        return false
    }
    
    // Check whether the next character should be capitalized or not
    func shouldCapitalizeNextCharacter() -> Bool {
        guard let contextBeforeInput = textDocumentProxy.documentContextBeforeInput else {
            return true
        }
        let trimmedContext = contextBeforeInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let lastCharacter = trimmedContext.last {
            return [".", "!", "?"].contains(lastCharacter)
        }
        return contextBeforeInput.isEmpty
    }
}

