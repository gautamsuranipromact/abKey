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
    @IBOutlet weak var OverlayView: UIView!
    
    @IBOutlet weak var AtTheRatePopupView: UIStackView!
    
    @IBOutlet weak var ColonPopupView: UIStackView!
    
    @IBOutlet weak var UnderscorePopupView: UIStackView!
    
    @IBOutlet weak var LeftArrowPopupView: UIStackView!
    
    @IBOutlet weak var RightArrowPopupView: UIStackView!
    
    @IBOutlet weak var QuestionMarkPopupView: UIStackView!
    
    @IBOutlet weak var SpecialFPopupView: UIStackView!
    
    @IBOutlet weak var SpecialGPopupView: UIStackView!
    
    
    
    // First keyboard keys collection
    @IBOutlet var KeysCollectionFirstKeyboard: [CustomButton]!
    
    // Third keyboard keys collection
    @IBOutlet var KeysCollectionThirdKeyboard: [CustomButton]!
    
    // keyboard keys outlets for special gestures
    @IBOutlet weak var FirstKeyboardCapsBtn: CustomButton!
    
    @IBOutlet weak var ThirdKeyboardCapsBtn: CustomButton!
    
    @IBOutlet weak var AtTheRateBtn: CustomButton!
    
    @IBOutlet weak var ColonBtn: CustomButton!
    
    @IBOutlet weak var UnderscoreBtn: CustomButton!
    
    @IBOutlet weak var LeftArrowBtn: CustomButton!
    
    @IBOutlet weak var RightArrowBtn: CustomButton!
    
    @IBOutlet weak var QuestionMarkBtn: CustomButton!
    
    @IBOutlet weak var SpecialFBtn: CustomButton!
    
    @IBOutlet weak var SpecialGBtn: CustomButton!
    
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
        
        let underscoreLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleUnderscoreLongPress))
        UnderscoreBtn.addGestureRecognizer(underscoreLongPressGesture)
        
        let leftArrowLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLeftArrowLongPress))
        LeftArrowBtn.addGestureRecognizer(leftArrowLongPressGesture)
        
        let rightArrowLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleRightArrowLongPress))
        RightArrowBtn.addGestureRecognizer(rightArrowLongPressGesture)
        
        let questionMarkLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleQuestionMarkLongPress))
        QuestionMarkBtn.addGestureRecognizer(questionMarkLongPressGesture)
        
        let specialFLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleSpecialFLongPress))
        SpecialFBtn.addGestureRecognizer(specialFLongPressGesture)
        
        let specialGLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleSpecialGLongPress))
        SpecialGBtn.addGestureRecognizer(specialGLongPressGesture)

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
        AtTheRatePopupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        AtTheRatePopupView.isLayoutMarginsRelativeArrangement = true
        AtTheRatePopupView.layer.borderColor = UIColor.lightGray.cgColor
        AtTheRatePopupView.layer.borderWidth = 2.0
        AtTheRatePopupView.layer.cornerRadius = 5
        
        OverlayView.isHidden = false
        AtTheRatePopupView.isHidden = false
    }
    
    @objc func handleColonLongPress() {
        ColonPopupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        ColonPopupView.isLayoutMarginsRelativeArrangement = true
        ColonPopupView.layer.borderColor = UIColor.lightGray.cgColor
        ColonPopupView.layer.borderWidth = 2.0
        ColonPopupView.layer.cornerRadius = 5
        
        OverlayView.isHidden = false
        ColonPopupView.isHidden = false
    }
    
    @objc func handleUnderscoreLongPress() {
        UnderscorePopupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        UnderscorePopupView.isLayoutMarginsRelativeArrangement = true
        UnderscorePopupView.layer.borderColor = UIColor.lightGray.cgColor
        UnderscorePopupView.layer.borderWidth = 2.0
        UnderscorePopupView.layer.cornerRadius = 5
        
        OverlayView.isHidden = false
        UnderscorePopupView.isHidden = false
    }
    
    @objc func handleLeftArrowLongPress() {
        LeftArrowPopupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        LeftArrowPopupView.isLayoutMarginsRelativeArrangement = true
        LeftArrowPopupView.layer.borderColor = UIColor.lightGray.cgColor
        LeftArrowPopupView.layer.borderWidth = 2.0
        LeftArrowPopupView.layer.cornerRadius = 5
        
        OverlayView.isHidden = false
        LeftArrowPopupView.isHidden = false
    }
    
    @objc func handleRightArrowLongPress() {
        RightArrowPopupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        RightArrowPopupView.isLayoutMarginsRelativeArrangement = true
        RightArrowPopupView.layer.borderColor = UIColor.lightGray.cgColor
        RightArrowPopupView.layer.borderWidth = 2.0
        RightArrowPopupView.layer.cornerRadius = 5
        
        OverlayView.isHidden = false
        RightArrowPopupView.isHidden = false
    }
    
    @objc func handleQuestionMarkLongPress() {
        QuestionMarkPopupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        QuestionMarkPopupView.isLayoutMarginsRelativeArrangement = true
        QuestionMarkPopupView.layer.borderColor = UIColor.lightGray.cgColor
        QuestionMarkPopupView.layer.borderWidth = 2.0
        QuestionMarkPopupView.layer.cornerRadius = 5
        
        OverlayView.isHidden = false
        QuestionMarkPopupView.isHidden = false
    }
    
    @objc func handleSpecialFLongPress() {
        SpecialFPopupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        SpecialFPopupView.isLayoutMarginsRelativeArrangement = true
        SpecialFPopupView.layer.borderColor = UIColor.lightGray.cgColor
        SpecialFPopupView.layer.borderWidth = 2.0
        SpecialFPopupView.layer.cornerRadius = 5
        
        OverlayView.isHidden = false
        SpecialFPopupView.isHidden = false
    }
    
    @objc func handleSpecialGLongPress() {
        SpecialGPopupView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        SpecialGPopupView.isLayoutMarginsRelativeArrangement = true
        SpecialGPopupView.layer.borderColor = UIColor.lightGray.cgColor
        SpecialGPopupView.layer.borderWidth = 2.0
        SpecialGPopupView.layer.cornerRadius = 5
        
        OverlayView.isHidden = false
        SpecialGPopupView.isHidden = false
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
        OverlayView.isHidden = true
        AtTheRatePopupView.isHidden = true
    }
    
    @IBAction func btnColonPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        ColonPopupView.isHidden = true
    }
    
    @IBAction func btnUnderscorePopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        UnderscorePopupView.isHidden = true
    }
    
    @IBAction func btnLeftArrowPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        LeftArrowPopupView.isHidden = true
    }
    
    @IBAction func btnRightArrowPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        RightArrowPopupView.isHidden = true
    }
    
    @IBAction func btnQuestionMarkPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        QuestionMarkPopupView.isHidden = true
    }
    
    @IBAction func btnSpecialFPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        SpecialFPopupView.isHidden = true
    }
    
    @IBAction func btnSpecialGPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        SpecialGPopupView.isHidden = true
    }
    
}

