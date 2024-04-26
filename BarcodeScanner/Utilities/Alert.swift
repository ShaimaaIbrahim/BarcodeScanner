//
//  Alert.swift
//  BarcodeScanner
//
//  Created by Platinum WireLess on 26/04/2024.
//

import Foundation
import SwiftUI

struct AlertItem :  Identifiable{
     let id = UUID()
     var title: String
     var message: String
     var dismissButton: Alert.Button
}

struct AlertContext{
  static let invalidDeviceInput = AlertItem(
    title: "Inavalid Device Input",
    message: "Inavalid Device Input",
    dismissButton: .default(Text("ok")))
    
    static  let invalidScannedInput = AlertItem(
       title: "invalidScannedInput",
       message: "invalidScannedInput",
       dismissButton: .default(Text("ok")))
}
