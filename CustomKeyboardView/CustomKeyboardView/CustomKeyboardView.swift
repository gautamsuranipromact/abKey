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
  func moveArrowRightButton()
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
  func configurePopupView(_ popupView: UIStackView)
  func openMainApp(_ hostValue: String)
  func shouldCapitalizeNextCharacter() -> Bool
}

class CustomKeyboardView: UIView {
    
    let databaseHelper = SQLiteDBHelper.shared // Database singleton instance
    let sharedDefaults = UserDefaults(suiteName: "group.abKey.promact")
    
    ///Outlets
    @IBOutlet weak var btnKeyboardSwitch: UIButton!
    
    // keyboard layout views
    @IBOutlet weak var FirstKeyboardLayout: UIStackView!
    @IBOutlet weak var SecondKeyboardLayout: UIStackView!
    @IBOutlet weak var ThirdKeyboardLayout: UIStackView!
    @IBOutlet weak var PremiumEntriesPopupView: UIView!
    
    // tplus view outlets
    @IBOutlet weak var TPlusPopupView: UIStackView!
    @IBOutlet weak var TPlusPopupViewTitle: UILabel!
    @IBOutlet weak var TPlusViewTextField: UITextField!
    @IBOutlet weak var TPlusViewWarningLabel: UILabel!
    @IBOutlet weak var TPlusViewSaveBtn: UIButton!
    @IBOutlet weak var TPlusViewCloseBtn: UIButton!
    
    // purchase premium notifier outlets
    @IBOutlet weak var PurchasePremiumNotifierPopup: UIStackView!
    @IBOutlet weak var ClosePremiumPurchasePopup: CustomButton!
    @IBOutlet weak var UpgradeToPremium: CustomButton!
    
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
    @IBOutlet weak var SmileyButtonPopupView: UIStackView!
    @IBOutlet weak var Latin_L_PopupView: UIStackView!
    @IBOutlet weak var SpecialMPopupView: UIStackView!
    
    @IBOutlet weak var Latin_N_PopupView: UIStackView!
    @IBOutlet weak var Latin_E_PopupView: UIStackView!
    @IBOutlet weak var Latin_I_PopupView: UIStackView!
    @IBOutlet weak var Latin_O_PopupView: UIStackView!
    @IBOutlet weak var LatinCentPopupView: UIStackView!
    
    @IBOutlet weak var Latin_R_PopupView: UIStackView!
    @IBOutlet weak var Latin_S_PopupView: UIStackView!
    @IBOutlet weak var Latin_T_PopupView: UIStackView!
    @IBOutlet weak var Latin_A_PopupView: UIStackView!
    @IBOutlet weak var Latin_C_PopupView: UIStackView!
    @IBOutlet weak var Latin_U_PopupView: UIStackView!
    
    @IBOutlet weak var LatinPipePopupView: UIStackView!
    @IBOutlet weak var LatinBackslashPopupView: UIStackView!
    @IBOutlet weak var LatinOpeningCurlyBracketsPopupView: UIStackView!
    @IBOutlet weak var LatinClosingCurlyBracketsPopupView: UIStackView!
    @IBOutlet weak var LatinDotPopupView: UIStackView!
    @IBOutlet weak var LatinOpeningSquareBracketPopupView: UIStackView!
    
    
    // collections
    @IBOutlet var KeysCollectionFirstKeyboard: [CustomButton]!
    @IBOutlet var KeysCollectionThirdKeyboard: [CustomButton]!
    @IBOutlet var BackspaceBtnCollection: [CustomButton]!
    @IBOutlet var MoveCursorLeftBtnCollection: [CustomButton]!
    @IBOutlet var TrBtnCollection: [CustomButton]!
    @IBOutlet var TPlusBtnCollection: [CustomButton]!
    @IBOutlet var SettingsBtnCollection: [CustomButton]!
    
    // keyboard keys outlets for special gestures
    @IBOutlet weak var FirstKeyboardCapsBtn: CustomButton!
    @IBOutlet weak var ThirdKeyboardCapsBtn: CustomButton!
    @IBOutlet weak var AtTheRateBtn: CustomButton!
    @IBOutlet weak var ColonBtn: CustomButton!
    @IBOutlet weak var UnderscoreBtn: CustomButton!
    @IBOutlet weak var LeftArrowBtn: CustomButton!
    @IBOutlet weak var RightArrowBtn: CustomButton!
    @IBOutlet weak var QuestionMarkBtn: CustomButton!
    
    @IBOutlet weak var MoveCursorRightBtn: CustomButton!
    @IBOutlet weak var SpecialFBtn: CustomButton!
    @IBOutlet weak var SpecialGBtn: CustomButton!
    @IBOutlet weak var SmileyBtn: CustomButton!
    @IBOutlet weak var Latin_L_Btn: CustomButton!
    @IBOutlet weak var SpecialMBtn: CustomButton!
    @IBOutlet weak var Latin_N_Btn: CustomButton!
    
    @IBOutlet weak var Latin_E_Btn: CustomButton!
    @IBOutlet weak var Latin_I_Btn: CustomButton!
    @IBOutlet weak var Latin_O_Btn: CustomButton!
    @IBOutlet weak var LatinCentBtn: CustomButton!
    @IBOutlet weak var Latin_R_Btn: CustomButton!
    @IBOutlet weak var Latin_S_Btn: CustomButton!
    @IBOutlet weak var Latin_T_Btn: CustomButton!

    @IBOutlet weak var Latin_A_Btn: CustomButton!
    @IBOutlet weak var Latin_C_Btn: CustomButton!
    @IBOutlet weak var Latin_U_Btn: CustomButton!
    @IBOutlet weak var LatinPipeBtn: CustomButton!
    @IBOutlet weak var LatinBackslashBtn: CustomButton!
    
    @IBOutlet weak var LatinOpeningCurlyBracketBtn: CustomButton!
    @IBOutlet weak var LatinClosingCurlyBracketBtn: CustomButton!
    @IBOutlet weak var LatinDotBtn: CustomButton!
    @IBOutlet weak var LatinOpeningSquareBracketBtn: CustomButton!
    
    
    // variables
    var permissibleEntriesForLiteUsers = 6
    var tRTapped: Bool = false
    var tPlusTapped: Bool = false
    var storeBtnTap: String = ""
    var backspaceRepeatTimer: Timer?
    var moveCursorLeftRepeatTimer: Timer?
    var moveCursorRightRepeatTimer: Timer?

    
    var isFirstCapsUppercase: Bool = true
    var isFirstCapsLocked: Bool = false
    var isThirdCapsUppercase: Bool = true
    var isThirdCapsLocked: Bool = false
    var isStoringSpecialCharacter: Bool = false
    
    weak var delegate: CustomKeyboardViewDelegate?
    
    
    @IBAction func displayFirstKeyboard(_ sender: UIButton) {
        if(ThirdKeyboardLayout.isHidden == false){
            tRTapped = false
            tPlusTapped = false
        }
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
        tRTapped = false
        tPlusTapped = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for button in KeysCollectionFirstKeyboard {
            if let title = button.titleLabel?.text {
                button.setTitle(isFirstCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
            }
        }
        
        for button in KeysCollectionThirdKeyboard {
            if let title = button.titleLabel?.text {
                button.setTitle(isThirdCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
            }
        }
        
        for button in TrBtnCollection {
            let isTrEnabled = sharedDefaults?.bool(forKey: "isTrEnabled")
            button.isEnabled = isTrEnabled!
        }
        
        for button in TPlusBtnCollection {
            let isTPlusEnabled = sharedDefaults?.bool(forKey: "isTPlusEnabled")
            button.isEnabled = isTPlusEnabled!
        }
        
        for button in SettingsBtnCollection {
            let isRTPlusManager = sharedDefaults?.bool(forKey: "isRTPlusManager")
            button.isEnabled = isRTPlusManager!
        }
        
        for button in BackspaceBtnCollection {
            button.addTarget(self, action: #selector(backspaceBtnTapped), for: .touchDown)
            button.addTarget(self, action: #selector(backspaceBtnReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
        
        for button in MoveCursorLeftBtnCollection {
            button.addTarget(self, action: #selector(moveCursorLeftBtnTapped), for: .touchDown)
            button.addTarget(self, action: #selector(moveCursorLeftBtnReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        }
        
        
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
        
        MoveCursorRightBtn.addTarget(self, action: #selector(moveCursorRightBtnTapped), for: .touchDown)
        MoveCursorRightBtn.addTarget(self, action: #selector(moveCursorRightBtnReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
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
        
        let smileyLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleSmileyLongPress))
        SmileyBtn.addGestureRecognizer(smileyLongPressGesture)
        
        let latin_L_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_L_LongPress))
        Latin_L_Btn.addGestureRecognizer(latin_L_LongPressGesture)
        
        let specialMLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleSpecialMLongPress))
        SpecialMBtn.addGestureRecognizer(specialMLongPressGesture)
        
        let latin_N_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_N_LongPress))
        Latin_N_Btn.addGestureRecognizer(latin_N_LongPressGesture)
        
        let latin_E_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_E_LongPress))
        Latin_E_Btn.addGestureRecognizer(latin_E_LongPressGesture)
        
        let latin_I_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_I_LongPress))
        Latin_I_Btn.addGestureRecognizer(latin_I_LongPressGesture)
        
        let latin_O_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_O_LongPress))
        Latin_O_Btn.addGestureRecognizer(latin_O_LongPressGesture)
        
        let latinCentLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleCentLongPress))
        LatinCentBtn.addGestureRecognizer(latinCentLongPressGesture)
        
        let latin_R_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_R_LongPress))
        Latin_R_Btn.addGestureRecognizer(latin_R_LongPressGesture)
        
        let latin_S_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_S_LongPress))
        Latin_S_Btn.addGestureRecognizer(latin_S_LongPressGesture)
        
        let latin_T_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_T_LongPress))
        Latin_T_Btn.addGestureRecognizer(latin_T_LongPressGesture)
        
        let latin_A_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_A_LongPress))
        Latin_A_Btn.addGestureRecognizer(latin_A_LongPressGesture)
        
        let latin_C_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_C_LongPress))
        Latin_C_Btn.addGestureRecognizer(latin_C_LongPressGesture)
        
        let latin_U_LongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatin_U_LongPress))
        Latin_U_Btn.addGestureRecognizer(latin_U_LongPressGesture)
        
        let latinPipeLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatinPipeLongPress))
        LatinPipeBtn.addGestureRecognizer(latinPipeLongPressGesture)
        
        let latinBackslashLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatinBackslashLongPress))
        LatinBackslashBtn.addGestureRecognizer(latinBackslashLongPressGesture)
        
        let latinOpeningCurlyBracketLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatinOpeningCurlyBracketLongPress))
        LatinOpeningCurlyBracketBtn.addGestureRecognizer(latinOpeningCurlyBracketLongPressGesture)
        
        let latinClosingCurlyBracketLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatinClosingCurlyBracketLongPress))
        LatinClosingCurlyBracketBtn.addGestureRecognizer(latinClosingCurlyBracketLongPressGesture)
        
        let latinDotLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatinDotLongPress))
        LatinDotBtn.addGestureRecognizer(latinDotLongPressGesture)
        
        let latinOpeningSquareBracketLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLatinOpeningSquareBracketLongPress))
        LatinOpeningSquareBracketBtn.addGestureRecognizer(latinOpeningSquareBracketLongPressGesture)
    }
}

// utility functions
extension CustomKeyboardView {
    
    @objc func backspaceBtnTapped(_ sender: UIButton) {
        backspaceRepeatTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(repeatedBackspaceAction), userInfo: nil, repeats: true)
    }
    
    @objc func backspaceBtnReleased(_ sender: UIButton) {
            backspaceRepeatTimer?.invalidate()
            backspaceRepeatTimer = nil
    }
        
    @objc func repeatedBackspaceAction() {
            delegate?.removeCharacter()
    }
    
    @objc func moveCursorLeftBtnTapped(_ sender: UIButton) {
        moveCursorLeftRepeatTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(repeatedMoveCursorLeftAction), userInfo: nil, repeats: true)
    }
    
    @objc func moveCursorLeftBtnReleased(_ sender: UIButton) {
        moveCursorLeftRepeatTimer?.invalidate()
        moveCursorLeftRepeatTimer = nil
    }
    
    @objc func repeatedMoveCursorLeftAction() {
        delegate?.moveArrowLeftButton()
    }
    
    @objc func moveCursorRightBtnTapped(_ sender: UIButton) {
        moveCursorRightRepeatTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(repeatedMoveCursorRightAction), userInfo: nil, repeats: true)
    }
    
    @objc func moveCursorRightBtnReleased(_ sender: UIButton) {
        moveCursorRightRepeatTimer?.invalidate()
        moveCursorRightRepeatTimer = nil
    }
    
    @objc func repeatedMoveCursorRightAction() {
        delegate?.moveArrowRightButton()
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
        delegate?.configurePopupView(AtTheRatePopupView)
    }
    
    @objc func handleColonLongPress() {
        delegate?.configurePopupView(ColonPopupView)
    }
    
    @objc func handleUnderscoreLongPress() {
        delegate?.configurePopupView(UnderscorePopupView)
    }
    
    @objc func handleLeftArrowLongPress() {
        delegate?.configurePopupView(LeftArrowPopupView)
    }
    
    @objc func handleRightArrowLongPress() {
        delegate?.configurePopupView(RightArrowPopupView)
    }
    
    @objc func handleQuestionMarkLongPress() {
        delegate?.configurePopupView(QuestionMarkPopupView)
    }
    
    @objc func handleSpecialFLongPress() {
        delegate?.configurePopupView(SpecialFPopupView)
    }
    
    @objc func handleSpecialGLongPress() {
        delegate?.configurePopupView(SpecialGPopupView)
    }
    
    @objc func handleSmileyLongPress() {
        delegate?.configurePopupView(SmileyButtonPopupView)
    }
    
    @objc func handleLatin_L_LongPress() {
        delegate?.configurePopupView(Latin_L_PopupView)
    }
    
    @objc func handleSpecialMLongPress() {
        delegate?.configurePopupView(SpecialMPopupView)
    }
    
    @objc func handleLatin_N_LongPress() {
        delegate?.configurePopupView(Latin_N_PopupView)
    }
    
    @objc func handleLatin_E_LongPress() {
        delegate?.configurePopupView(Latin_E_PopupView)
    }
    
    @objc func handleLatin_I_LongPress() {
        delegate?.configurePopupView(Latin_I_PopupView)
    }
    
    @objc func handleLatin_O_LongPress() {
        delegate?.configurePopupView(Latin_O_PopupView)
    }
    
    @objc func handleCentLongPress() {
        delegate?.configurePopupView(LatinCentPopupView)
    }
    
    @objc func handleLatin_R_LongPress() {
        delegate?.configurePopupView(Latin_R_PopupView)
    }
    
    @objc func handleLatin_S_LongPress() {
        delegate?.configurePopupView(Latin_S_PopupView)
    }
    
    @objc func handleLatin_T_LongPress() {
        delegate?.configurePopupView(Latin_T_PopupView)
    }
    
    @objc func handleLatin_A_LongPress() {
        delegate?.configurePopupView(Latin_A_PopupView)
    }
    
    @objc func handleLatin_C_LongPress() {
        delegate?.configurePopupView(Latin_C_PopupView)
    }
    
    @objc func handleLatin_U_LongPress() {
        delegate?.configurePopupView(Latin_U_PopupView)
    }
    
    @objc func handleLatinPipeLongPress() {
        delegate?.configurePopupView(LatinPipePopupView)
    }
    
    @objc func handleLatinBackslashLongPress() {
        delegate?.configurePopupView(LatinBackslashPopupView)
    }
    
    @objc func handleLatinOpeningCurlyBracketLongPress() {
        delegate?.configurePopupView(LatinOpeningCurlyBracketsPopupView)
    }
    
    @objc func handleLatinClosingCurlyBracketLongPress() {
        delegate?.configurePopupView(LatinClosingCurlyBracketsPopupView)
    }
    
    @objc func handleLatinDotLongPress() {
        delegate?.configurePopupView(LatinDotPopupView)
    }
    
    @objc func handleLatinOpeningSquareBracketLongPress() {
        delegate?.configurePopupView(LatinOpeningSquareBracketPopupView)
    }
    
    func characterInsertion(_ sender: UIButton) {
        if let txt = sender.titleLabel?.text {
            delegate?.insertCharacter(txt)
            
            changeKeysCase()
        }
    }
    
    func changeKeysCase() {
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
    
    func configurePremiumPurchaseView() {
        // 1. Configure Popup Background (Navy Blue)
        PurchasePremiumNotifierPopup.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        PurchasePremiumNotifierPopup.layer.cornerRadius = 12
        PurchasePremiumNotifierPopup.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        PurchasePremiumNotifierPopup.isLayoutMarginsRelativeArrangement = true
        
        // 2. Configure Upgrade to Premium Button (Soothing Green)
        UpgradeToPremium.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0) // Hex: #4CAF50
        UpgradeToPremium.setTitleColor(.white, for: .normal) // White Text
        UpgradeToPremium.layer.cornerRadius = 10
        UpgradeToPremium.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        // Adding a subtle shadow for a premium look
        UpgradeToPremium.layer.shadowColor = UIColor.black.cgColor
        UpgradeToPremium.layer.shadowOpacity = 0.2
        UpgradeToPremium.layer.shadowOffset = CGSize(width: 0, height: 3)
        UpgradeToPremium.layer.shadowRadius = 4
        
        // 3. Configure Close Button (Soft Gray)
        ClosePremiumPurchasePopup.backgroundColor = UIColor(red: 176/255, green: 190/255, blue: 197/255, alpha: 1.0) // Hex: #B0BEC5
        ClosePremiumPurchasePopup.setTitleColor(UIColor(red: 55/255, green: 71/255, blue: 79/255, alpha: 1.0), for: .normal) // Dark Gray Text #37474F
        ClosePremiumPurchasePopup.layer.cornerRadius = 10
        ClosePremiumPurchasePopup.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        // 4. Adding a similar shadow to match Upgrade button style
        ClosePremiumPurchasePopup.layer.shadowColor = UIColor.black.cgColor
        ClosePremiumPurchasePopup.layer.shadowOpacity = 0.2
        ClosePremiumPurchasePopup.layer.shadowOffset = CGSize(width: 0, height: 3)
        ClosePremiumPurchasePopup.layer.shadowRadius = 4
    }

    
    func styleTPlusPopupView() {
            TPlusPopupView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            TPlusPopupView.layer.cornerRadius = 12
            TPlusPopupView.layer.shadowColor = UIColor.black.cgColor
            TPlusPopupView.layer.shadowOpacity = 0.2
            TPlusPopupView.layer.shadowOffset = CGSize(width: 0, height: 2)
            TPlusPopupView.layer.shadowRadius = 4
            TPlusPopupView.layer.masksToBounds = false
            TPlusPopupView.isLayoutMarginsRelativeArrangement = true
            TPlusPopupView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        
            TPlusPopupViewTitle.text = "TPlus Input Key : \(storeBtnTap)"

            // Style TextField
            TPlusViewTextField.backgroundColor = UIColor.white
            TPlusViewTextField.textColor = UIColor.black
            TPlusViewTextField.layer.borderColor = UIColor.lightGray.cgColor
            TPlusViewTextField.layer.borderWidth = 1.0
            TPlusViewTextField.layer.cornerRadius = 8
            TPlusViewTextField.layer.masksToBounds = true

            // Style Warning Label
            TPlusViewWarningLabel.textColor = UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0)
            TPlusViewWarningLabel.font = UIFont.boldSystemFont(ofSize: 16)

            TPlusViewSaveBtn.backgroundColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
            TPlusViewSaveBtn.setTitleColor(.white, for: .normal)
            TPlusViewSaveBtn.layer.cornerRadius = 8
            TPlusViewSaveBtn.layer.masksToBounds = true
            TPlusViewSaveBtn.layer.shadowColor = UIColor.black.cgColor
            TPlusViewSaveBtn.layer.shadowOpacity = 0.2
            TPlusViewSaveBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
            TPlusViewSaveBtn.layer.shadowRadius = 3

            // Style Close Button
            TPlusViewCloseBtn.backgroundColor = UIColor(red: 176/255, green: 190/255, blue: 197/255, alpha: 1)
            TPlusViewCloseBtn.setTitleColor(.black, for: .normal)
            TPlusViewCloseBtn.layer.cornerRadius = 8
            TPlusViewCloseBtn.layer.masksToBounds = true
            TPlusViewCloseBtn.layer.shadowColor = UIColor.black.cgColor
            TPlusViewCloseBtn.layer.shadowOpacity = 0.2
            TPlusViewCloseBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
            TPlusViewCloseBtn.layer.shadowRadius = 3

    }
    
    func retrieveStoredData(_ key: String) {
        let storedValues = databaseHelper.values(forKey: key)
        print("retrieved values : \(storedValues)")
        tRTapped = false
        
        if(storedValues.count == 1){
            delegate?.insertCharacter(storedValues[0])
        }
        else if (storedValues.count > 1){
            if(!TPlusPopupView.isHidden){
                TPlusPopupView.alpha = 0
            }
            // Remove any existing subviews in the PremiumEntriesPopupView (if necessary)
            PremiumEntriesPopupView.subviews.forEach { $0.removeFromSuperview() }
            
            // Create a title container to hold the label and cross button
            let titleContainer = UIStackView()
            titleContainer.axis = .horizontal
            titleContainer.distribution = .equalSpacing
            titleContainer.translatesAutoresizingMaskIntoConstraints = false
            PremiumEntriesPopupView.addSubview(titleContainer)
            
            // Create a title label
            let titleLabel = UILabel()
            titleLabel.text = "Select any one"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
            titleLabel.textColor = .white
            
            // Create a cross button
            let crossButton = UIButton(type: .system)
            crossButton.setTitle("✖️", for: .normal)
            crossButton.setTitleColor(.white, for: .normal)
            crossButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
            
            titleContainer.addArrangedSubview(titleLabel)
            titleContainer.addArrangedSubview(crossButton)
            
            // Constraints for titleContainer
            NSLayoutConstraint.activate([
                titleContainer.topAnchor.constraint(equalTo: PremiumEntriesPopupView.topAnchor, constant: 2),
                titleContainer.leadingAnchor.constraint(equalTo: PremiumEntriesPopupView.leadingAnchor, constant: 8),
                titleContainer.trailingAnchor.constraint(equalTo: PremiumEntriesPopupView.trailingAnchor, constant: -8),
            ])
            
            // Create a vertical UIScrollView
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.showsVerticalScrollIndicator = true
            scrollView.alwaysBounceVertical = true
            PremiumEntriesPopupView.addSubview(scrollView)
            
            // Constraints for scrollView
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 8),
                scrollView.leadingAnchor.constraint(equalTo: PremiumEntriesPopupView.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: PremiumEntriesPopupView.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: PremiumEntriesPopupView.bottomAnchor)
            ])
            
            // Create buttons for each stored value and add them to the scroll view
            let buttonWidth: CGFloat = PremiumEntriesPopupView.frame.width - 20 // Adjust width as needed
            let buttonHeight: CGFloat = 35
            let buttonSpacing: CGFloat = 5
            
            var yPosition: CGFloat = 0 // Start position
            
            for (index, value) in storedValues.enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(value, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                button.frame = CGRect(x: 10, y: yPosition, width: buttonWidth, height: buttonHeight)
                button.tag = index
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                button.contentHorizontalAlignment = .left // Left align the title
                
                // Add a bottom border to the button
                if(index < storedValues.count - 1){
                    let borderHeight: CGFloat = 1.0
                    let borderView = UIView()
                    borderView.translatesAutoresizingMaskIntoConstraints = false
                    borderView.backgroundColor = .white
                    button.addSubview(borderView)
                    
                    // Set border constraints
                    NSLayoutConstraint.activate([
                        borderView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
                        borderView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                        borderView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                        borderView.heightAnchor.constraint(equalToConstant: borderHeight)
                    ])
                }
                
                scrollView.addSubview(button)
                
                // Update yPosition for the next button
                yPosition += buttonHeight + buttonSpacing
            }
            
            // Update the scrollView's content size based on the number of buttons
            let totalContentHeight = yPosition + 8 // Add padding to the total height
            scrollView.contentSize = CGSize(width: buttonWidth, height: totalContentHeight)
            
            PremiumEntriesPopupView.isHidden = false
        }
        else{
            print("No values for this key")
        }
    }

    // Button action handler for cross button
    @objc func crossButtonTapped() {
        PremiumEntriesPopupView.isHidden = true
        if(!TPlusPopupView.isHidden && TPlusPopupView.alpha == 0){
            TPlusPopupView.alpha = 1
        }
    }

    // Button action handler for other buttons
    @objc func buttonTapped(_ sender: UIButton) {
        btnLetterTap(sender)
        PremiumEntriesPopupView.isHidden = true
        if(!TPlusPopupView.isHidden && TPlusPopupView.alpha == 0){
            TPlusPopupView.alpha = 1
        }
    }
}

//MARK: - Button Actions
extension CustomKeyboardView {
    
    @IBAction func btnLetterTap(_ sender: UIButton) {
        if(tPlusTapped) {
            tPlusTapped = false
            storeBtnTap = (sender.titleLabel?.text ?? " ").lowercased()
            if let premium = sharedDefaults?.integer(forKey: "premiumKey"), (premium == 0) {
                let values = databaseHelper.values(forKey: storeBtnTap)
                if(values.count > 0){
                    TPlusViewWarningLabel.isHidden = false
                }
                else {
                    let allStoredValues = databaseHelper.readAllValues()
                    if(allStoredValues.count >= permissibleEntriesForLiteUsers) {
                        TPlusPopupView.isHidden = true
                        configurePremiumPurchaseView()
                        PurchasePremiumNotifierPopup.isHidden = false
                        return
                    }
                }
            }
            styleTPlusPopupView()
            TPlusViewTextField.becomeFirstResponder()
            TPlusPopupView.isHidden = false
        }
        else if(tRTapped) {
            retrieveStoredData(sender.titleLabel?.text?.lowercased() ?? " ")
        }
        else{
            characterInsertion(sender)
        }
    }
    
    @IBAction func btnLetterTapAndNullifyRTPlus(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        
        characterInsertion(sender)
    }
    
    @IBAction func btnClearTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        delegate?.removeCharacter()
        if let shouldCapitalize = delegate?.shouldCapitalizeNextCharacter(), shouldCapitalize == true {
            isFirstCapsUppercase = true
            isThirdCapsUppercase = true
            
            for button in KeysCollectionFirstKeyboard {
                if let title = button.titleLabel?.text {
                    button.setTitle(isFirstCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
                }
            }
            
            for button in KeysCollectionThirdKeyboard {
                if let title = button.titleLabel?.text {
                    button.setTitle(isThirdCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
                }
            }
        }
    }
    
    @IBAction func btnSpaceTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        delegate?.insertCharacter(" ")
        if let shouldCapitalize = delegate?.shouldCapitalizeNextCharacter(), shouldCapitalize == true {
            isFirstCapsUppercase = true
            isThirdCapsUppercase = true
            
            for button in KeysCollectionFirstKeyboard {
                if let title = button.titleLabel?.text {
                    button.setTitle(isFirstCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
                }
            }
            
            for button in KeysCollectionThirdKeyboard {
                if let title = button.titleLabel?.text {
                    button.setTitle(isThirdCapsUppercase ? title.uppercased() : title.lowercased(), for: .normal)
                }
            }
        }
    }
    
    @IBAction func btnCloseKeyboard(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.closeKeyboard()
    }
    
    @IBAction func btnMoveCursorLeft(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.moveArrowLeftButton()
    }
    
    @IBAction func btnMoveCursorRight(_ sender: UIButton){
        tRTapped = false
        tPlusTapped = false
        self.delegate?.moveArrowRightButton()
    }
    
    @IBAction func btnEnterTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.enterButtonClicked()
    }
    
    @IBAction func btnColonTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.colonButtonTapped()
        changeKeysCase()
    }
    
    @IBAction func btnHyphenTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.hyphenButtonTapped()
        changeKeysCase()
    }
    
    @IBAction func btnLeftArrowTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.leftArrowButtonClicked()
        changeKeysCase()
    }
    
    @IBAction func btnRightArrowTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.rightArrowButtonClicked()
        changeKeysCase()
    }
    
    @IBAction func btnQuestionMarkTap(_ sender: UIButton){
        tRTapped = false
        tPlusTapped = false
        self.delegate?.questionButtonClicked()
        changeKeysCase()
    }
    
    @IBAction func btnSpecialFTap(_ sender: UIButton){
        if(tPlusTapped) {
            TPlusViewTextField.becomeFirstResponder()
            TPlusPopupView.isHidden = false
            storeBtnTap = "sf"
            tPlusTapped = false
        }
        else if(tRTapped){
            retrieveStoredData("sf")
        }
        else{
            self.delegate?.specialFbutton()
            changeKeysCase()
        }
    }
    
    @IBAction func btnSpecialGTap(_ sender: UIButton) {
        if(tPlusTapped) {
            TPlusViewTextField.becomeFirstResponder()
            TPlusPopupView.isHidden = false
            storeBtnTap = "sg"
            tPlusTapped = false
        }
        else if(tRTapped){
            retrieveStoredData("sg")
        }
        else{
            self.delegate?.specialGbutton()
            changeKeysCase()
        }
    }
    
    @IBAction func btnSpecialKTap(_ sender: UIButton) {
        if(tPlusTapped) {
            TPlusViewTextField.becomeFirstResponder()
            TPlusPopupView.isHidden = false
            storeBtnTap = "sk"
            tPlusTapped = false
        }
        else if(tRTapped) {
            retrieveStoredData("sk")
        }
        else{
            self.delegate?.specialKbutton()
            changeKeysCase()
        }
    }
    
    @IBAction func btnSpecialMTap(_ sender: UIButton) {
        if(tPlusTapped) {
            TPlusViewTextField.becomeFirstResponder()
            TPlusPopupView.isHidden = false
            storeBtnTap = "sm"
            tPlusTapped = false
        }
        else if(tRTapped) {
            retrieveStoredData("sm")
        }
        else{
            self.delegate?.specialMbutton()
            changeKeysCase()
        }
    }
    
    @IBAction func btnSpecialPTap(_ sender: UIButton) {
        if(tPlusTapped) {
            TPlusViewTextField.becomeFirstResponder()
            TPlusPopupView.isHidden = false
            storeBtnTap = "sp"
            tPlusTapped = false
        }
        else if(tRTapped) {
            retrieveStoredData("sp")
        }
        else{
            self.delegate?.specialPbutton()
            changeKeysCase()
        }
    }
    
    @IBAction func btnSpecialQTap(_ sender: UIButton) {
        if(tPlusTapped) {
            TPlusViewTextField.becomeFirstResponder()
            TPlusPopupView.isHidden = false
            storeBtnTap = "sq"
            tPlusTapped = false
        }
        else if(tRTapped) {
            retrieveStoredData("sq")
        }
        else{
            self.delegate?.specialQbutton()
            changeKeysCase()
        }
    }
    
    @IBAction func btnSpecialBTap(_ sender: UIButton) {
        tPlusTapped = false
        tRTapped = false
        self.delegate?.specialBbutton()
        changeKeysCase()
    }
    
    @IBAction func btnSmileyTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.smileyButton()
        changeKeysCase()
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
    
    @IBAction func btnSmileyPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        SmileyButtonPopupView.isHidden = true
    }
    
    @IBAction func btnLatin_L_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_L_PopupView.isHidden = true
    }
    
    @IBAction func btnSpecialMPopupClose(_ sender: UIButton){
        OverlayView.isHidden = true
        SpecialMPopupView.isHidden = true
    }
    
    @IBAction func btnLatin_N_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_N_PopupView.isHidden = true
    }
    
    @IBAction func btnLatin_E_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_E_PopupView.isHidden = true
    }
    
    @IBAction func btnLatin_I_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_I_PopupView.isHidden = true
    }
    
    @IBAction func btnLatin_O_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_O_PopupView.isHidden = true
    }
    
    @IBAction func btnLatinCentPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        LatinCentPopupView.isHidden = true
    }
    
    @IBAction func btnLatin_R_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_R_PopupView.isHidden = true
    }
    
    @IBAction func btnLatin_S_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_S_PopupView.isHidden = true
    }
    
    @IBAction func btnLatin_T_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_T_PopupView.isHidden = true
    }
    
    @IBAction func btnLatin_A_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_A_PopupView.isHidden = true
    }
    
    @IBAction func btnLatin_C_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_C_PopupView.isHidden = true
    }
    
    @IBAction func btnLatin_U_PopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        Latin_U_PopupView.isHidden = true
    }
    
    @IBAction func btnLatinPipePopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        LatinPipePopupView.isHidden = true
    }
    
    @IBAction func btnLatinBackslashPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        LatinBackslashPopupView.isHidden = true
    }
    
    @IBAction func btnLatinOpeningCurlyBrackets(_ sender: UIButton) {
        OverlayView.isHidden = true
        LatinOpeningCurlyBracketsPopupView.isHidden = true
    }
    
    @IBAction func btnLatinClosingCurlyBrackets(_ sender: UIButton) {
        OverlayView.isHidden = true
        LatinClosingCurlyBracketsPopupView.isHidden = true
    }
    
    @IBAction func btnLatinDotPopupClose(_ sender: UIButton) {
        OverlayView.isHidden = true
        LatinDotPopupView.isHidden = true
    }
    
    @IBAction func btnLatinOpeningSquareBracketsClosePopup(_ sender: UIButton) {
        OverlayView.isHidden = true
        LatinOpeningSquareBracketPopupView.isHidden = true
    }
    
    @IBAction func btnTPlusTap() {
        tPlusTapped = true
        tRTapped = false
    }
    
    @IBAction func tPlusViewSaveBtn() {
        if let value = TPlusViewTextField.text {
            print("value from extension \(value)")
            if let isPremiumCustomer = sharedDefaults?.integer(forKey: "premiumKey"), (isPremiumCustomer != 0) {
                print(isPremiumCustomer)
                if let char = storeBtnTap.first {
                    if char.isLetter && (storeBtnTap.count == 1) && ((char >= "a" && char <= "z") || (char >= "A" && char <= "Z")){
                        databaseHelper.insert(key: storeBtnTap, value: value, keyboardType: "alphabetic")
                    } else if char.isNumber && (storeBtnTap.count == 1) {
                        databaseHelper.insert(key: storeBtnTap, value: value, keyboardType: "numeric")
                    } else {
                        databaseHelper.insert(key: storeBtnTap, value: value, keyboardType: "accent")
                    }
                }
            }
            else{
                if let char = storeBtnTap.first {
                    if char.isLetter && (storeBtnTap.count == 1) && ((char >= "a" && char <= "z") || (char >= "A" && char <= "Z")){
                        databaseHelper.insertOrUpdate(key: storeBtnTap, value: value, keyboardType: "alphabetic")
                    } else if char.isNumber && (storeBtnTap.count == 1) {
                        databaseHelper.insertOrUpdate(key: storeBtnTap, value: value, keyboardType: "numeric")
                    } else {
                        databaseHelper.insertOrUpdate(key: storeBtnTap, value: value, keyboardType: "accent")
                    }
                }
            }
            TPlusViewTextField.text = ""
            TPlusPopupView.isHidden = true
            tPlusTapped = false
        }
    }
    
    @IBAction func closeTPlusPopupView() {
        TPlusViewTextField.text = ""
        TPlusViewTextField.resignFirstResponder()
        TPlusPopupView.isHidden = true
        tPlusTapped = false
    }
    
    @IBAction func btnTRTap() {
        tPlusTapped = false
        tRTapped = true
    }
    
    @IBAction func closePurchasePremiumNotifier() {
        PurchasePremiumNotifierPopup.isHidden = true
    }
    
    @IBAction func upgradeToPremium() {
        delegate?.openMainApp("")
    }
    
    @IBAction func btnSettingsTap() {
        if(!FirstKeyboardLayout.isHidden) {
            delegate?.openMainApp("firstKeyboard")
        }
        else if(!SecondKeyboardLayout.isHidden) {
            delegate?.openMainApp("secondKeyboard")
        }
        else{
            delegate?.openMainApp("thirdKeyboard")
        }
    }
}
