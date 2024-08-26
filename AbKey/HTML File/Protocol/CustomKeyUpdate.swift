//
//  CustomKeyUpdate.swift
//  AbKey
//
//  Created by Divyanah on 02/04/24.
//

import Foundation
protocol CustomKeyUpdateDelegate: AnyObject {
    func updateCustomKey(id: Int, withKey key: String, newValue: String, newKeyboardType: String)
}
