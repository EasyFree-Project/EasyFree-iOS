//
//  CameraViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/22.
//
import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    let sessionQueue = DispatchQueue(label: "session queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureButton: UIButton!
    
    var productPosition: [ProductPosition] = [
        ProductPosition(x1Axis: 41, x2Axis: 103, y1Axis: 427, y2Axis: 489, categoryNumber: 6000095829),
        ProductPosition(x1Axis: 157, x2Axis: 209, y1Axis: 255, y2Axis: 317, categoryNumber: 6000096294),
        ProductPosition(x1Axis: 227, x2Axis: 289, y1Axis: 155, y2Axis: 217, categoryNumber: 6000096294),
        ProductPosition(x1Axis: 27, x2Axis: 89, y1Axis: 105, y2Axis: 167, categoryNumber: 6000096294),
        ProductPosition(x1Axis: 27, x2Axis: 89, y1Axis: 355, y2Axis: 417, categoryNumber: 6000096294)
    ]
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView.session = captureSession
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
    }
    
    @IBAction func capturePhoto(_ sender: UIButton) {
        let videoPreviewLayerOrientation = self.previewView.videoPreviewLayer.connection?.videoOrientation
        sessionQueue.async {
            let connection = self.photoOutput.connection(with: .video)
            connection?.videoOrientation = videoPreviewLayerOrientation!
            let setting = AVCapturePhotoSettings()
            self.photoOutput.capturePhoto(with: setting, delegate: self)
        }
    }
    
    @IBAction func recapturePhoto(_ sender: Any) {
        for view in self.previewView.subviews{
            view.removeFromSuperview()
        }
        startSession()
    }
    
    func sendPhoto(image: UIImage) {
        stopSession()
        showButtons()
    }
    
    func showButtons () {
        for i in  0..<productPosition.count {
            let productButton = UIButton(frame: CGRect(x: productPosition[i].x1Axis, y: productPosition[i].y1Axis, width: productPosition[i].x2Axis - productPosition[i].x1Axis, height: productPosition[i].y2Axis - productPosition[i].y1Axis))
            productButton.layer.borderColor = UIColor.black.cgColor
            productButton.layer.borderWidth = 3
            productButton.setTitle("button\(i)", for: .normal)
            productButton.setTitleColor(UIColor.clear, for: .normal)
            productButton.addTarget(self, action: #selector(productButtonClicked), for: .touchUpInside)
            
            self.previewView.addSubview(productButton)
        }
    }
    
    @objc func productButtonClicked(_ sender: UIButton) {
        print(sender.currentTitle!)
    }
}

extension CameraViewController {
    func setupSession() {
        
        captureSession.sessionPreset = .photo
        captureSession.beginConfiguration()
        
        do {
            var defaultVideoDevice: AVCaptureDevice?
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            guard let camera = defaultVideoDevice else {
                captureSession.commitConfiguration()
                return
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                captureSession.commitConfiguration()
                return
            }
        } catch {
            captureSession.commitConfiguration()
            return
        }
        
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.commitConfiguration()
    }
    
    func startSession() {
        if !captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard error == nil else { return }
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        self.sendPhoto(image: image)
    }
}

struct ProductPosition: Codable {
    let x1Axis: Int
    let x2Axis: Int
    let y1Axis: Int
    let y2Axis: Int
    let categoryNumber: Int
    
    init(x1Axis: Int, x2Axis: Int, y1Axis: Int, y2Axis: Int, categoryNumber: Int) {
        self.x1Axis = x1Axis
        self.x2Axis = x2Axis
        self.y1Axis = y1Axis
        self.y2Axis = y2Axis
        self.categoryNumber = categoryNumber
    }
}

