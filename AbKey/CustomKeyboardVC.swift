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
        if customKeyboardView.isUpperCase == true{
            textField.insertText(":")
        }else{
            textField.insertText(";")
        }
    }
    
    func hyphenButtonTapped() {
        if customKeyboardView.isUpperCase == true{
            textField.insertText("_")
        }else{
            textField.insertText("-")
        }
    }
    
    func leftArrowButtonClicked() {
        if customKeyboardView.isUpperCase == true{
            textField.insertText("<")
        }else{
            textField.insertText(",")
        }
    }
    
    func rightArrowButtonClicked() {
        if customKeyboardView.isUpperCase == true{
            textField.insertText(">")
        }else{
            textField.insertText(".")
        }
    }
    
    func questionButtonClicked() {
        if customKeyboardView.isUpperCase == true{
            textField.insertText("?")
        }else{
            textField.insertText("/")
        }
    }
    
    func enterButtonClicked(){
        textField.text! += "\n"
    }
    
    func moveArroeLeftButton(){
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
        if customKeyboardView.isUpperCase == true{
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
}
