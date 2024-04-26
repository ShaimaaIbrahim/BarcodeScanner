//
//  ScannerView.swift
//  BarcodeScanner
//
//  Created by Platinum WireLess on 25/04/2024.
//

import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode : String
    @Binding var alertItem : AlertItem?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
   
    func makeUIViewController(context: Context) -> ScannerVC {
        ScannerVC(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {
        
    }
    
    final class Coordinator : NSObject , BarcodeScannerVCDelegate{
        
        private let scannerView: ScannerView
        
        init(scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(barCode: String) {
            scannerView.scannedCode = barCode;
        }
        
        func didSurface(error: CameraError) {
            switch error{
            case .invalidDeviceInput :
                scannerView.alertItem = AlertContext.invalidDeviceInput
            case .invalidScannedValue:
                scannerView.alertItem = AlertContext.invalidScannedInput
                
            }
        }
        
    }
    typealias UIViewControllerType = ScannerVC
    
}

//struct ScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScannerView(scannedCode: .constant("123456"))
//    }
//}
