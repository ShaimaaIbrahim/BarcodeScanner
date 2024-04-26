//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Platinum WireLess on 04/04/2024.
//

import SwiftUI


struct BarcodeScannerView: View {

    @StateObject var viewModel = BarcodeScannerViewModel()
    
    var body: some View {
        NavigationView{
            VStack(){
                ScannerView(scannedCode: $viewModel.scannedCode, alertItem: $viewModel.alertItem).frame(maxWidth: .infinity,maxHeight: 300)
                Spacer().frame(height: 60)
                Label("ScannedBarcode:", systemImage: "barcode.viewfinder").font(.title)
                Text(viewModel.statusText)
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(viewModel.statusTextColor)
                    .padding()
                
                Button{
                  
                }label: {
                    Text("Tap Me")
                }
            }
            .navigationTitle("Barcode Scanner")
            .alert(item: $viewModel.alertItem){ alertItem in
                Alert(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: alertItem.dismissButton)
            }
        
        }
    }
}

