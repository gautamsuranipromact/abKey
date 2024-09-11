//
//  KeyboardViewController.swift
//  CustomKeyboardView
//
//  Created by Divyanah on 10/01/24.
//

import UIKit

class KeyboardViewController: UIInputViewController,CustomKeyboardViewDelegate{
    
    
    
//    @IBOutlet var nextKeyboardButton: UIButton!
    
    
    
    var customKeyboardView: CustomKeyboardView!
    var lexicon: UILexicon?
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        // Add CustomKeyboardView to the input view
        let nib = UINib(nibName: "CustomKeyboardView", bundle: nil)
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
        print(self.view.frame.size.width)
        print(self.view.frame.size.height)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
    }
}

extension KeyboardViewController {
    func insertCharacter(_ newCharacter: String) {
        if newCharacter == " " {
            replaceWord()
        }
        textDocumentProxy.insertText(newCharacter)
    }
    
    func removeCharacter() {
        textDocumentProxy.deleteBackward()
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

extension KeyboardViewController{
    func colonButtonTapped() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textDocumentProxy.insertText(":")
        }else{
            textDocumentProxy.insertText(";")
        }
    }
    
    func hyphenButtonTapped() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textDocumentProxy.insertText("_")
        }else{
            textDocumentProxy.insertText("-")
        }
    }
    
    func leftArrowButtonClicked() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textDocumentProxy.insertText("<")
        }else{
            textDocumentProxy.insertText(",")
        }
    }
    
    func rightArrowButtonClicked() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textDocumentProxy.insertText(">")
        }else{
            textDocumentProxy.insertText(".")
        }
    }
    
    func questionButtonClicked() {
        if customKeyboardView.isFirstCapsUppercase == true{
            textDocumentProxy.insertText("?")
        }else{
            textDocumentProxy.insertText("/")
        }
    }
    
    func enterButtonClicked() {
        textDocumentProxy.insertText("\n")
    }
    
    func moveArrowLeftButton() {
        textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)    }
    
    func specialFbutton() {
        textDocumentProxy.insertText("%")
    }
    
    func specialGbutton() {
        if customKeyboardView.isThirdCapsUppercase == true{
            textDocumentProxy.insertText("A")
        }else{
            textDocumentProxy.insertText("a")
        }
    }
    
    func specialKbutton() {
        textDocumentProxy.insertText("|")
    }
    
    func specialMbutton() {
        textDocumentProxy.insertText("☎️")
    }
    
    func specialPbutton() {
        textDocumentProxy.insertText("★")
    }
    
    func specialQbutton() {
        textDocumentProxy.insertText("☆")
    }
    
    func specialBbutton() {
        textDocumentProxy.insertText("ß")
    }
    
    func smileyButton() {
        textDocumentProxy.insertText(":-)")
    }
    
    func closeKeyboard() {
        self.dismissKeyboard()
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
    
}

