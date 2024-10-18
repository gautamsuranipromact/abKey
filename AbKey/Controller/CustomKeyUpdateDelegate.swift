//
//  CustomKeyUpdateDelegate.swift
//  AbKey
//
//  Created by Divyanah on 02/04/24.
//

import Foundation

// CustomKeyUpdate.swift

public protocol CustomKeyUpdateDelegate: AnyObject {
    func updateCustomKey(with key: String, newValue: String, keyboardType: String)
}
