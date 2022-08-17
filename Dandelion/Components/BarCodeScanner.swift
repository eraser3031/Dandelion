//
//  BarCodeScanner.swift
//  Dandelion
//
//  Created by 김예훈 on 2022/08/14.
//

import AVKit
import SwiftUI

struct BarCodeScanner: UIViewControllerRepresentable {
    
    @Binding var selectedItems: [Item]
    @Binding var isbns: [String]
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.black
        context.coordinator.captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError(",,")
        }
        
        let videoInput: AVCaptureDeviceInput
        videoInput = try! AVCaptureDeviceInput(device: videoCaptureDevice)
        
        if (context.coordinator.captureSession.canAddInput(videoInput)) {
            context.coordinator.captureSession.addInput(videoInput)
        } else {
            print("could not add video input")
        }
        
        let metaDataOutput = AVCaptureMetadataOutput()
        
        if (context.coordinator.captureSession.canAddOutput(metaDataOutput)) {
            context.coordinator.captureSession.addOutput(metaDataOutput)
            
            metaDataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
            metaDataOutput.metadataObjectTypes = [.ean13]
            metaDataOutput.rectOfInterest = CGRectMake(0, 0, 1, 1)
        } else {
            print("could not add video output")
        }
        
        context.coordinator.previewLayer = AVCaptureVideoPreviewLayer(session: context.coordinator.captureSession)
        context.coordinator.previewLayer.frame = vc.view.layer.bounds
        context.coordinator.previewLayer.videoGravity = .resizeAspectFill
        vc.view.layer.addSublayer(context.coordinator.previewLayer)
        
        context.coordinator.captureSession.startRunning()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        if selectedItems.count == 0 {
//            context.coordinator.previewLayer.cornerRadius = 0
//            context.coordinator.previewLayer.frame = UIScreen.main.bounds
//        } else {
//            context.coordinator.previewLayer.cornerRadius = 32
//            context.coordinator.previewLayer.frame = uiViewController.view.layer.bounds
//        }
    }
    
    class Coordinator : NSObject, AVCaptureMetadataOutputObjectsDelegate {
        let parent: BarCodeScanner
        var captureSession: AVCaptureSession!
        var previewLayer: AVCaptureVideoPreviewLayer!
        init(_ parent: BarCodeScanner) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metaDataObject = metadataObjects.first {
                guard let readableObject = metaDataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                found(code: stringValue)
                if parent.isbns.count > 4 {
                    captureSession.stopRunning()
                    parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        
        func found(code: String) {
            if !parent.isbns.contains(code) {
                print(code)
                parent.isbns.append(code)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

