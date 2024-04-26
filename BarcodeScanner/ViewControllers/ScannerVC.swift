//
//  BarcodeVC.swift
//  BarcodeScanner
//
//  Created by Platinum WireLess on 04/04/2024.
//

import UIKit
import AVFoundation

protocol BarcodeScannerVCDelegate : class{
    func didFind(barCode: String)
    func didSurface(error: CameraError)
}

enum CameraError : String {
 case invalidDeviceInput
 case invalidScannedValue
    
}

final class ScannerVC : UIViewController{
 
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    weak var scannerDelegate : BarcodeScannerVCDelegate?
    
    init(scannerDelegate: BarcodeScannerVCDelegate){
        super.init(nibName: nil, bundle: nil)
        self.scannerDelegate = scannerDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
      super.viewDidLoad()
      setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
       
        guard let previewLayer = previewLayer else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession(){
        //1-define videoCaptureDevice
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        //2-define videoCaptureDeviceInput
        let videoInput: AVCaptureDeviceInput
        do{
            try videoInput = AVCaptureDeviceInput(device: videoCaptureDevice)
            
        }catch{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        //3-add videoInput to captureSession
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        //4-add metaDataOutput to captureSession
        let metaDataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metaDataOutput){
            captureSession.addOutput(metaDataOutput)
            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.ean8, .ean13]
        }else{
            scannerDelegate?.didSurface(error: .invalidDeviceInput)
            return
        }
        
        //5-define previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        
        //6-start capture.
        captureSession.startRunning()
        
    }
                            
}

extension ScannerVC : AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let object = metadataObjects.first else{
           scannerDelegate?.didSurface(error: .invalidScannedValue)
           return
        }
        
        guard let machineReadableObject = object as? AVMetadataMachineReadableCodeObject else{
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        guard let barcode = machineReadableObject.stringValue else{
            scannerDelegate?.didSurface(error: .invalidScannedValue)
            return
        }
        
        captureSession.stopRunning()
        scannerDelegate?.didFind(barCode: barcode)
    }
}
