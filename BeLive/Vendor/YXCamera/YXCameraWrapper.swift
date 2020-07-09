//
//  YXCameraView.swift
//  SwiftCustomCamera
//
//  Created by tezwez on 2019/10/15.
//  Copyright © 2019 tezwez. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore
import CoreGraphics
import SnapKit

class YXCameraWrapper: NSObject {
    
    // MARK: - Camera
    ///捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
    lazy var device: AVCaptureDevice? = {
        let dev = AVCaptureDevice.default(for: .video) ;
        return dev
    }()
    ///AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
    lazy var input: AVCaptureDeviceInput? = {
        do{
            if device == nil {
                return nil
            }
            let inp = try AVCaptureDeviceInput(device: self.device!)
        return inp
        } catch{
            return nil
        }
    }()
    ///当启动摄像头开始捕获输入
    lazy var output: AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        return out
    }()
    lazy var imageOutPut: AVCaptureStillImageOutput = {
        let out = AVCaptureStillImageOutput()
        return out
    }()
    ///session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
    lazy var session: AVCaptureSession = {
        let se = AVCaptureSession()
        return se
    }()
    
    ///图像预览层，实时显示捕获的图像
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: session)
        return layer
    }()
    
    // MARK: - UI Property
    
    var cropSize: CGSize = CGSize(width: 228/375*screenWidth, height: 362/667*screenWidth)
    
    var isFlashOn = false
    var isCanCa = false
    var image: UIImage?
    var showImage: UIImage?
    
    var takeImageFinish: ((_ image: UIImage?) -> Void)?
   
    init(videoPreView: UIView) {
        super.init()
        setupCamera(videoPreView: videoPreView)
    }
    
    //MARK: - setup
    func setupCamera(videoPreView: UIView){
        if self.session.canSetSessionPreset(AVCaptureSession.Preset.high) {
            self.session.sessionPreset = .high
        }
        if input != nil {
            if self.session.canAddInput(self.input!) {
                self.session.addInput(self.input!)
            }
            if self.session.canAddOutput(self.imageOutPut) {
                self.session.addOutput(imageOutPut)
            }
        }
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = videoPreView.bounds
        videoPreView.layer.addSublayer(previewLayer)
        
        do{
            try device?.lockForConfiguration()
            if device?.isFlashModeSupported(AVCaptureDevice.FlashMode.auto) ?? false {
                device?.flashMode = .auto
            }
            if device?.isWhiteBalanceModeSupported(AVCaptureDevice.WhiteBalanceMode.autoWhiteBalance) ?? false {
                device?.whiteBalanceMode = .autoWhiteBalance
            }
            device?.unlockForConfiguration()
        }catch{
            print("摄像头打开失败")
        }
    }
    
    /// 前后摄像头切换
    func changeCamera(){
        let cameraCount = AVCaptureDevice.devices(for: .video).count
        if cameraCount > 1 {
            let animation = CATransition()
            animation.duration = 5
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.type = CATransitionType(rawValue: "oglFlip")
            
            var newCamera: AVCaptureDevice?
            var newInput: AVCaptureDeviceInput?
            let position = input?.device.position
            if position == .front {
                newCamera = camera(position: .back)
                animation.subtype = .fromLeft
            } else {
                newCamera = camera(position: .front)
                animation.subtype = .fromRight
            }
            
            do {
                try newInput = AVCaptureDeviceInput(device: newCamera!)
                self.previewLayer.add(animation, forKey: nil)
                if newInput != nil {
                    self.session.beginConfiguration()
                    self.session.removeInput(input!)
                    if session.canAddInput(newInput!) {
                        session.addInput(newInput!)
                        self.input = newInput
                    } else {
                        session.addInput(input!)
                    }
                    
                    session.commitConfiguration()
                }
            } catch {
                print("摄像头初始化失败")
            }
            
            
        }
    }
    
    
}

extension YXCameraWrapper{
    
    func start() {
        if !session.isRunning {
            session.startRunning()
        }
    }
    
    func stop() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    private func camera(position: AVCaptureDevice.Position?) -> AVCaptureDevice?{
        let devices = AVCaptureDevice.devices(for: .video)
        for device in devices{
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    // MARK: - Action
    func torch(){
        do{
            try device?.lockForConfiguration()
            if isFlashOn {
//                if device?.isFlashModeSupported(.off) ?? false {
                    device?.torchMode = .off
                    isFlashOn = false
//                }
            } else{
//                if device?.isFlashModeSupported(.on) ?? false {
                    device?.torchMode = .on
                    isFlashOn = true
//                }
            }
            device?.unlockForConfiguration()
        }catch{
            print("摄像头打开失败")
        }
    }
    
    func shutterCamera(){
        let connection = self.imageOutPut.connection(with: .video)
        guard let videoConnection = connection  else {
            print("拍照获取图片失败")
            return
        }
        
        videoConnection.preferredVideoStabilizationMode = .standard
        imageOutPut.captureStillImageAsynchronously(from: videoConnection) { (buffer, error) in
            guard let imageDataSampleBuffer = buffer else {
                return
            }
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            self.image = UIImage(data: imageData!)
            self.session.stopRunning()
            
            self.captureImage()
        }
    }
    
    func restart(){
        session.startRunning()
    }
    
    func captureImage(){
        takeImageFinish?(self.image)
    }
    
    
    func removeAllSubviewsWith(superView: UIView?){
        while superView?.subviews.count ?? 0 > 0 {
            superView?.subviews.last?.removeFromSuperview()
        }
    }
}

extension UIImage{
    func imageScale(toSize: CGSize) -> UIImage?{
        //此处将画布放大三倍，这样在retina屏截取时不会影响像素
        UIGraphicsBeginImageContextWithOptions(toSize, false, 3.0)
        self.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    func imageInRect( rect: CGRect) -> UIImage?{
        let scale = self.scale
        let newRect = CGRect(x: rect.origin.x*scale, y: rect.origin.y*scale, width: rect.size.width*scale, height: rect.size.height*scale)
        let sourceImageRef = self.cgImage
        let newImageRef = sourceImageRef?.cropping(to: newRect)
        if let cgImage = newImageRef {
            let newImage = UIImage(cgImage: cgImage, scale: scale, orientation: self.imageOrientation)
            return newImage
        }
        return nil
    }
}
