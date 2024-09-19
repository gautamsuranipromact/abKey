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
  func configurePopupView(_ popupView: UIStackView)
  func openMainApp(_ hostValue: String)
}

class CustomKeyboardView: UIView {
    
    let databaseHelper = SQLiteDBHelper.shared // Database singleton instance
    
    ///Outlets
    @IBOutlet weak var btnKeyboardSwitch: UIButton!
    
    // keyboard layout views
    @IBOutlet weak var FirstKeyboardLayout: UIStackView!
    @IBOutlet weak var SecondKeyboardLayout: UIStackView!
    @IBOutlet weak var ThirdKeyboardLayout: UIStackView!
    
    // tplus view outlets
    @IBOutlet weak var TPlusPopupView: UIStackView!
    @IBOutlet weak var TPlusViewTextField: UITextField!
    @IBOutlet weak var TPlusViewSaveBtn: UIButton!
    @IBOutlet weak var TPlusViewCloseBtn: UIButton!
    
    
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
    
    // First and Third keyboard keys collection
    @IBOutlet var KeysCollectionFirstKeyboard: [CustomButton]!
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
    var tRTapped: Bool = false
    var tPlusTapped: Bool = false
    var storeBtnTap: String = ""

    
    var isFirstCapsUppercase: Bool = false
    var isFirstCapsLocked: Bool = false
    var isThirdCapsUppercase: Bool = false
    var isThirdCapsLocked: Bool = false
    
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

// objective c functions
extension CustomKeyboardView {
    
    func shouldCapitalizeNextCharacter() -> Bool {
        guard let contextBeforeInput = self.inputViewController?.textDocumentProxy.documentContextBeforeInput else {
                return true // Capitalize at the start of the document
            }

            // Trim whitespaces and check for sentence-ending punctuation marks
            let trimmedContext = contextBeforeInput.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let lastCharacter = trimmedContext.last {
                // Capitalize if the last character was a period, question mark, or exclamation mark
                return [".", "!", "?"].contains(lastCharacter)
            }

            // If there's no content before input, capitalize (i.e., beginning of the document)
            return contextBeforeInput.isEmpty
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
}

//MARK: - Button Actions
extension CustomKeyboardView {
    
    @IBAction func btnLetterTap(_ sender: UIButton) {
        if(tPlusTapped) {
            TPlusViewTextField.becomeFirstResponder()
            TPlusPopupView.alpha = 1
            print(sender.titleLabel?.text ?? "No title on the button")
            tPlusTapped = false
            storeBtnTap = sender.titleLabel?.text ?? " "
            return
        }
        
        if(tRTapped) {
            storeBtnTap = sender.titleLabel?.text ?? " "
            if let storedValue = databaseHelper.value(forKey: storeBtnTap) {
                print("Retrieved value: \(storedValue)")
                delegate?.insertCharacter(storedValue)
            } else {
                print("No value found for the given key.")
            }
            tRTapped = false
            return
        }
        
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
        tRTapped = false
        tPlusTapped = false
        delegate?.removeCharacter()
    }
    
    @IBAction func btnSpaceTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        delegate?.insertCharacter(" ")
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
    
    @IBAction func btnEnterTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.enterButtonClicked()
    }
    
    @IBAction func btnColonTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.colonButtonTapped()
    }
    
    @IBAction func btnHyphenTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.hyphenButtonTapped()
    }
    
    @IBAction func btnLeftArrowTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.leftArrowButtonClicked()
    }
    
    @IBAction func btnRightArrowTap(_ sender: UIButton) {
        tRTapped = false
        tPlusTapped = false
        self.delegate?.rightArrowButtonClicked()
    }
    
    @IBAction func btnQuestionMarkTap(_ sender: UIButton){
        tRTapped = false
        tPlusTapped = false
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
        tRTapped = false
        tPlusTapped = false
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
            print(storeBtnTap , "hello world")
            if let char = storeBtnTap.first {
                if char.isLetter && ((char >= "a" && char <= "z") || (char >= "A" && char <= "Z")){
                    databaseHelper.insertOrUpdate(key: storeBtnTap, value: value, keyboardType: "alphabetic")
                } else if char.isNumber {
                    databaseHelper.insertOrUpdate(key: storeBtnTap, value: value, keyboardType: "numeric")
                } else {
                    databaseHelper.insertOrUpdate(key: storeBtnTap, value: value, keyboardType: "accent")
                }
            } else {
                print("storeBtnTap is nil")
            }
            TPlusViewTextField.text = ""
            TPlusPopupView.alpha = 0
            tPlusTapped = false
        }
    }
    
    @IBAction func closeTPlusPopupView() {
        TPlusViewTextField.text = ""
        TPlusViewTextField.resignFirstResponder()
        TPlusPopupView.alpha = 0
        tPlusTapped = false
    }
    
    @IBAction func btnTRTap() {
        tPlusTapped = false
        tRTapped = true
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
