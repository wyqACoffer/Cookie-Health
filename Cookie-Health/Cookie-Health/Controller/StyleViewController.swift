//
//  StyleViewController.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/13.
//

import UIKit
import Anchorage
import Vision
import VisionKit

class StyleViewController: UIViewController {
    var singleStyleView = ToolView(image: UIImage(named: "单排样式"))
    var doubleStyleView = ToolView(image: UIImage(named: "双排样式"))
    
    var singleStyleViewCallback: Block?
    var doubleStyleViewCallback: Block?
    
    var resultViewController: (UIViewController & RecognizedTextDataSource)?
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    var style: Style = .single
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configViews()
        self.configCallback()
        self.configRequest()
        // Do any additional setup after loading the view.
    }
    
    private func configViews() {
        self.view.backgroundColor = gColorForBackgroundView
        self.view.addSubview(self.singleStyleView)
        self.view.addSubview(self.doubleStyleView)
        self.singleStyleView.centerXAnchor == self.view.centerXAnchor
        self.singleStyleView.centerYAnchor == self.view.centerYAnchor - 180
        self.doubleStyleView.centerXAnchor == self.view.centerXAnchor
        self.doubleStyleView.centerYAnchor == self.view.centerYAnchor + 180
        self.singleStyleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapSingleStyle)))
        self.doubleStyleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapDoubleStyle)))
    }
    
    private func configCallback() {
        self.singleStyleViewCallback = { [weak self] in
            guard let self = self else { return }
            gStyle = .single
            self.callCamera()
        }
        self.doubleStyleViewCallback = { [weak self] in
            guard let self = self else { return }
            gStyle = .double
            self.callCamera()
        }
    }
    
    private func callCamera() {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        self.present(documentCameraViewController, animated: true)
    }
    
    private func configRequest() {
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            guard let resultViewController = self.resultViewController else {
                print("resultViewController is not set")
                return
            }
            if let results = request.results, !results.isEmpty {
                print(results)
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    DispatchQueue.main.async {
                        resultViewController.addRecognizedText(recognizedText: requestResults)
                    }
                }
            }
        })
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.recognitionLanguages = ["zh-Hans"]
    }
    
    private func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("Failed to get cgimage from input image")
            return
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
    
    
    @objc private func didTapSingleStyle() {
        self.singleStyleViewCallback?()
    }
    
    @objc private func didTapDoubleStyle() {
        self.doubleStyleViewCallback?()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


extension StyleViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        self.resultViewController = ResultViewController()
        controller.dismiss(animated: true) {
            DispatchQueue.global(qos: .userInitiated).async {
                for pageNumber in 0 ..< scan.pageCount {
                    let image = scan.imageOfPage(at: pageNumber)
                    self.processImage(image: image)
                }
                DispatchQueue.main.async {
                    if let resultVC = self.resultViewController {
                        self.navigationController?.pushViewController(resultVC, animated: true)
                    }
                }
            }
        }
    }
}
