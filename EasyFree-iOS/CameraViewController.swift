//
//  CameraViewController.swift
//  EasyFree-iOS
//
//  Created by 노규명 on 2020/10/22.
//
import UIKit
import AVFoundation
import Photos
import Alamofire

class CameraViewController: UIViewController {
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    let sessionQueue = DispatchQueue(label: "session queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var captureButton: UIButton!
    
    var productPosition: [ProductPosition] = [
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
        self.productPosition.removeAll()
        
        for view in self.previewView.subviews{
            view.removeFromSuperview()
        }
        startSession()
    }
    
    func sendPhoto(image: UIImage) {
        stopSession()
        
        let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
        
        let request = AF.upload(multipartFormData: { MultipartFormData in
            MultipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "productImg", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, to: "http://220.87.55.135:3003/model", method: .post, headers: headers)
        
        request.responseJSON { (response: DataResponse) in
            switch(response.result)
            {
            case .success(let value):
                guard let json = value as? [String: Any],
                let data = json["data"] as? [String: Any],
                let result = data["result"] as? [String]
                else {
                    print("검출된 물품이 없습니다")
                    return
                }
                
                print(result)
                
                for i in 0..<result.count {
                    let info: [String] = result[i].split(separator: " ").map(String.init)

                    let pos: ProductPosition = ProductPosition(x1Axis: Double(info[0])!, x2Axis: Double(info[1])!, y1Axis: Double(info[2])!, y2Axis: Double(info[3])!, categoryNumber: Int(info[4])!)

                    self.productPosition.append(pos)
                }
                self.showButtons()
                
            case .failure(let error):
                print(error)
                return
            }
        }
        
        showButtons()
    }
    
    func showButtons () {
        for i in 0..<self.productPosition.count {
            
            let x1pos = Double(previewView.bounds.width) * self.productPosition[i].x1Axis / 512
            let x2pos = Double(previewView.bounds.width) * self.productPosition[i].x2Axis / 512
            let y1pos = Double(previewView.bounds.height) * self.productPosition[i].y1Axis / 512
            let y2pos = Double(previewView.bounds.height) * self.productPosition[i].y2Axis / 512
            let width = x2pos - x1pos
            let height = y2pos - y1pos
            let category = self.productPosition[i].categoryNumber
            
            let productButton = UIButton(frame: CGRect(x: x1pos, y: y1pos, width: width, height: height))
            
            productButton.layer.borderColor = UIColor.black.cgColor
            productButton.layer.borderWidth = 3
            productButton.setTitle("\(category)", for: .normal)
            productButton.setTitleColor(UIColor.clear, for: .normal)
            productButton.addTarget(self, action: #selector(productButtonClicked), for: .touchUpInside)
            
            self.previewView.addSubview(productButton)
        }
    }
    
    @objc func productButtonClicked(_ sender: UIButton) {
        UserDefaults.standard.set(sender.currentTitle!, forKey: "categotyNumber")
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

struct ProductPosition {
    let x1Axis: Double
    let x2Axis: Double
    let y1Axis: Double
    let y2Axis: Double
    let categoryNumber: Int

    init(x1Axis: Double, x2Axis: Double, y1Axis: Double, y2Axis: Double, categoryNumber: Int) {
        self.x1Axis = x1Axis
        self.x2Axis = x2Axis
        self.y1Axis = y1Axis
        self.y2Axis = y2Axis
        self.categoryNumber = categoryNumber
    }
}
