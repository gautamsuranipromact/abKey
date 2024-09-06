//
//  CustomKeyboardView.swift
//  CustomKeyboard
//
//  Created by Yudiz Solutions Ltd on 20/02/23.
//

import UIKit

protocol CustomKeyboardViewDelegate: AnyObject {
  func insertCharacter(_ newCharacter: String)
  func removeCharacter()
  func closeKeyboard()
  func moveArrowLeftButton()
  func enterButtonClicked()
  func colonButtonTapped()
  func hyphenButtonTapped()
  func leftArrowButtonClicked()
  func rightArrowButtonClicked()
  func questionButtonClicked()
  func specialFbutton()
  func specialGbutton()
  func specialKbutton()
  func specialMbutton()
  func specialPbutton()
  func specialQbutton()
  func specialBbutton()
  func smileyButton()
}

class CustomKeyboardView: UIView {
    ///Outlets
    @IBOutlet weak var btnKeyboardSwitch: UIButton!
    
    // keyboard layout views
    @IBOutlet weak var FirstKeyboardLayout: UIStackView!
    @IBOutlet weak var SecondKeyboardLayout: UIStackView!
    @IBOutlet weak var ThirdKeyboardLayout: UIStackView!
    
    // outlet long press key popups
    @IBOutlet weak var AtTheRatePopupView: UIStackView!
    
    @IBOutlet weak var ColonPopupView: UIStackView!
    
    
    // First keyboard keys collection
    @IBOutlet var KeysCollectionFirstKeyboard: [CustomButton]!
    
    // Third keyboard keys collection
    @IBOutlet var KeysCollectionThirdKeyboard: [CustomButton]!
    
    // keyboard keys outlets for special gestures
    @IBOutlet weak var FirstKeyboardCapsBtn: CustomButton!
    
    @IBOutlet weak var ThirdKeyboardCapsBtn: CustomButton!
    
    @IBOutlet weak var AtTheRateBtn: CustomButton!
    
    @IBOutlet weak var ColonBtn: CustomButton!
    
    
    ///Variables
//    var isUpperCase: Bool = false
    
    var isFirstCapsUppercase: Bool = false
    var isFirstCapsLocked: Bool = false
    
    var isThirdCapsUppercase: Bool = false
    var isThirdCapsLocked: Bool = false
    
    weak var delegate: CustomKeyboardViewDelegate?
    
    
    @IBAction func displayFirstKeyboard(_ sender: UIButton) {
        FirstKeyboardLayout.isHidden = false
        SecondKeyboardLayout.isHidden = true
        ThirdKeyboardLayout.isHidden = true
    }
    
    @IBAction func displaySecondKeyboard(_ sender: UIButton) {
        FirstKeyboardLayout.isHidden = true
        SecondKeyboardLayout.isHidden = false
        ThirdKeyboardLayout.isHidden = true
    }
    
    @IBAction func displayThirdKeyboard(_ sender:UIButton) {
        FirstKeyboardLayout.isHidden = true
        SecondKeyboardLayout.isHidden = true
        ThirdKeyboardLayout.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Attaching single and double tap gestures to the first and third keyboard caps lock button
        let firstCapsSingleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFirstCapsSingleTap))
        firstCapsSingleTapRecognizer.numberOfTapsRequired = 1
            
        let firstCapsDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleFirstCapsDoubleTap))
        firstCapsDoubleTapRecognizer.numberOfTapsRequired = 2
            
        firstCapsSingleTapRecognizer.require(toFail: firstCapsDoubleTapRecognizer)
            
        FirstKeyboardCapsBtn.addGestureRecognizer(firstCapsSingleTapRecognizer)
        FirstKeyboardCapsBtn.addGestureRecognizer(firstCapsDoubleTapRecognizer)
        
        
        let thirdCapsSingleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleThirdCapsSingleTap))
        thirdCapsSingleTapRecognizer.numberOfTapsRequired = 1
            
        let thirdCapsDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleThirdCapsDoubleTap))
        thirdCapsDoubleTapRecognizer.numberOfTapsRequired = 2
            
        thirdCapsSingleTapRecognizer.require(toFail: thirdCapsDoubleTapRecognizer)
            
        ThirdKeyboardCapsBtn.addGestureRecognizer(thirdCapsSingleTapRecognizer)
        ThirdKeyboardCapsBtn.addGestureRecognizer(thirdCapsDoubleTapRecognizer)
        
        // Attaching Long press keys gesture to the buttons.
        let atTheRateLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleAtTheRateLongPress))
        AtTheRateBtn.addGestureRecognizer(atTheRateLongPressGesture)
        
        let colonLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleColonLongPress))
        ColonBtn.addGestureRecognizer(colonLongPressGesture)

    }
    
    @objc func handleFirstCapsSingleTap() {
        if(!isFirstCapsLocked){
            isFirstCapsUppercase.toggle()
            
            for button in KeysCollectionFirstKeyboard {
                if let title = button.titleLabel?.text {
                    button.setTitle(isFirstCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
                }
            }
        }
    }
    
    @objc func handleFirstCapsDoubleTap() {
        isFirstCapsLocked.toggle()
        isFirstCapsUppercase = isFirstCapsLocked
        
        for button in KeysCollectionFirstKeyboard {
            if let title = button.titleLabel?.text {
                button.setTitle(isFirstCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
            }
        }
    }
    
    @objc func handleThirdCapsSingleTap() {
        if(!isThirdCapsLocked){
            isThirdCapsUppercase.toggle()
            
            for button in KeysCollectionThirdKeyboard {
                if let title = button.titleLabel?.text {
                    button.setTitle(isThirdCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
                }
            }
        }
    }
    
    @objc func handleThirdCapsDoubleTap() {
        isThirdCapsLocked.toggle()
        isThirdCapsUppercase = isThirdCapsLocked
        
        for button in KeysCollectionThirdKeyboard {
            if let title = button.titleLabel?.text {
                button.setTitle(isThirdCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
            }
        }
    }
    
    @objc func handleAtTheRateLongPress() {
        AtTheRatePopupView.isHidden = false
    }
    
    @objc func handleColonLongPress() {
        ColonPopupView.isHidden = false
    }
}

//MARK: - Button Actions
extension CustomKeyboardView {
    
    
    @IBAction func btnLetterTap(_ sender: UIButton) {
        if let txt = sender.titleLabel?.text {
            delegate?.insertCharacter(txt)
            
            if(!isFirstCapsLocked && isFirstCapsUppercase){
                isFirstCapsUppercase.toggle()
                
                for button in KeysCollectionFirstKeyboard {
                    if let title = button.titleLabel?.text {
                        button.setTitle(isFirstCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
                    }
                }
            }
            
            if(!isThirdCapsLocked && isThirdCapsUppercase) {
                isThirdCapsUppercase.toggle()
                
                for button in KeysCollectionThirdKeyboard {
                    if let title = button.titleLabel?.text {
                        button.setTitle(isThirdCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
                    }
                }
            }
        }
    }
    
    @IBAction func btnClearTap(_ sender: UIButton) {
        delegate?.removeCharacter()
    }
    
    @IBAction func btnSpaceTap(_ sender: UIButton) {
        delegate?.insertCharacter(" ")
    }
    
    @IBAction func btnCloseKeyboard(_ sender: UIButton) {
        self.delegate?.closeKeyboard()
    }
    
    @IBAction func btnMoveCursorLeft(_ sender: UIButton) {
        self.delegate?.moveArrowLeftButton()
    }
    
    @IBAction func btnEnterTap(_ sender: UIButton) {
        self.delegate?.enterButtonClicked()
    }
    
    @IBAction func btnColonTap(_ sender: UIButton) {
        self.delegate?.colonButtonTapped()
    }
    
    @IBAction func btnHyphenTap(_ sender: UIButton) {
        self.delegate?.hyphenButtonTapped()
    }
    
    @IBAction func btnLeftArrowTap(_ sender: UIButton) {
        self.delegate?.leftArrowButtonClicked()
    }
    
    @IBAction func btnRightArrowTap(_ sender: UIButton) {
        self.delegate?.rightArrowButtonClicked()
    }
    
    @IBAction func btnQuestionMarkTap(_ sender: UIButton){
        self.delegate?.questionButtonClicked()
    }
    
    @IBAction func btnSpecialFTap(_ sender: UIButton){
        self.delegate?.specialFbutton()
    }
    
    @IBAction func btnSpecialGTap(_ sender: UIButton) {
        self.delegate?.specialGbutton()
    }
    
    @IBAction func btnSpecialKTap(_ sender: UIButton) {
        self.delegate?.specialKbutton()
    }
    
    @IBAction func btnSpecialMTap(_ sender: UIButton) {
        self.delegate?.specialMbutton()
    }
    
    @IBAction func btnSpecialPTap(_ sender: UIButton) {
        self.delegate?.specialPbutton()
    }
    
    @IBAction func btnSpecialQTap(_ sender: UIButton) {
        self.delegate?.specialQbutton()
    }
    
    @IBAction func btnSpecialBTap(_ sender: UIButton) {
        self.delegate?.specialBbutton()
    }
    
    @IBAction func btnSmileyTap(_ sender: UIButton) {
        self.delegate?.smileyButton()
    }
    
    @IBAction func btnAtTheRatePopupClose(_ sender: UIButton) {
        AtTheRatePopupView.isHidden = true
    }
    
    @IBAction func btnColonPopupClose(_ sender: UIButton) {
        ColonPopupView.isHidden = true
    }
}

