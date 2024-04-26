//
//  BarcodeScannerViewModel.swift
//  BarcodeScanner
//
//  Created by Platinum WireLess on 26/04/2024.
//

import Foundation
import SwiftUI

class BarcodeScannerViewModel : ObservableObject{
    @Published  var scannedCode = ""
    @Published  var alertItem : AlertItem?
    
    var statusText: String{
        return scannedCode.isEmpty ? "Not Yet scanned!" : scannedCode;
    }
    
    var statusTextColor : Color {
        scannedCode.isEmpty ? .red : .green
    }
}
