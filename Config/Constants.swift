//
//  Constants.swift
//  AbKey
//
//  Created by Promact on 15/10/24.
//

import UIKit

struct Constants {
    static let IpadScreen = UIDevice.current.userInterfaceIdiom == .pad // Check whether the device is Ipad
    
    static let AccentKeyboardTypeIdentifier = "accent"
    static let AlphabetKeyboardTypeIdentifier = "alphabetic"
    static let NumericKeyboardTypeIdentifier = "numeric"
    static let AccentsCellIdentifier = "accentsCell"
    static let AlphabetsCellIdentifier = "alphabetCell"
    static let NumbersCellIdentifier = "numberCell"
    
    static let PremiumUserHeading = "abKey Pro(Premium)"
    static let LiteUserHeading = "abKey Pro(Lite)"
    
    static let MainAppStoryboardIdentifier = "Main"
    static let AlphabetVCIdentifier = "AlphabetViewController"
    static let NumberVCIdentifier = "NumbersViewController"
    static let AccentVCIdentifier = "AccentsViewController"
    static let AbKeySettingVCIdentifier = "AbKeySettingVC"
    static let SettingVCIdentifier = "SettingViewController"
    static let AboutAbKeyVCIdentifier = "AboutAbkeyVC"
    static let WelcomeVCIdentifier = "WelcomeVC"
    static let HowToVCIdentifier = "HowToVC"
    static let AgreementVCIdentifier = "AggrementVC"
    
    static let AlphabetVCTitle = "Alphabets"
    static let NumberVCTitle = "Numbers"
    static let AccentVCTitle = "Accents"
    static let WelcomeVCTitle = "WELCOME"
    static let HowToVCTitle = "HOW TO"
    static let AgreementVCTitle = "AGREEMENT"
    
    static let MultipleRowEditErrorMsg = "Please select a single cell to edit from either Alphabets, Numbers, or Accents."
    static let ConfirmDeleteMsg = "Do you want to delete selected items?"
    static let ChangeKeyboardPromptMsg = "Would you like to change your keyboard to a specific one?"
    static let AlreadyPurchasedPremiumMsg = "You are already a premium user. Enjoy your features!"
    static let AbKeyTypingTestMsg = "abKey Typing Test"
    static let EnableTrFunctionMsg = "Check to enable Tr function"
    static let DisableTrFunctionMsg = "Uncheck to disable Tr function"
    static let DisableTPlusFunctionMsg = "Uncheck to disable T+ function"
    static let EnableTPlusFunctionMsg = "Check to enable T+ function"
    static let DisableRTPlusManagerMsg = "Uncheck to disable rT+ Manager from keyboard"
    static let EnableRTPlusManagerMsg = "Check to enable rT+ Manager from keyboard"
    static let RestartApplicationMsg = "To apply the restored changes, please close the app and reopen it."
    static let RestartApplicationProcessMsg = "To restart the app, swipe up from the bottom of your screen (or double-click the home button on older devices), then swipe the app away to close it. Reopen it from the home screen."
    
    static let AttributedTextWithKeyboardIcon = "To open abKey Pro Settings from abKey Pro input method, Press & Hold keyboard icon   "
    static let AttributedTextWithSettingIcon = "   OR press setting icon  "
    
    static let PremiumProductIdentifier = "abkeypro.bobskteo.com.premium"
    static let AppUrlSchemeIdentifier = "abkeyapp://"
    static let AppGroupSuiteName = "group.abkeypro"
    static let PremiumUserKey = "premiumKey"
    static let AutoCapitalizationKey = "isAutoCapEnabled"
    static let TrEnabledKey = "isTrEnabled"
    static let TPlusEnabledKey = "isTPlusEnabled"
    static let RTPlusEnabledKey = "isRTPlusManager"
    
    static let CheckSquareImg = "check_square"
    static let SquareImg = "square"
    static let KeyboardImg = "Keyboard"
    static let NumericSettingsImg = "numeric_settings"
    
    static let DBFileName = "CustomKeyboard.sqlite"
    
    static let HtmlMetaData = "<head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
    
    static let CustomKeyboardNibIdentifier = "CustomKeyboardView"
    
    static let FirstKeyboardHost = "firstKeyboard"
    static let SecondKeyboardHost = "secondKeyboard"
    static let ThirdKeyboardHost = "thirdKeyboard"
}
