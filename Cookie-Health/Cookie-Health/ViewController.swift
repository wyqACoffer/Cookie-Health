//
//  ViewController.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/5.
//

import UIKit
import Anchorage
import VisionKit
import Vision

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    var gAddViewCallback: Block?
    var gCheckViewCallback: Block?
    var resultViewController: (UIViewController & RecognizedTextDataSource)?
    var textRecognitionRequest = VNRecognizeTextRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        self.configCallback()
    }

    private func configView() {
        self.view.backgroundColor = gColorForBackgroundView
        self.view.addSubview(gAddView)
        self.view.addSubview(gCheckView)
        
        gAddView.centerXAnchor == self.view.centerXAnchor - 38
        gAddView.centerYAnchor == self.view.centerYAnchor - 200
        
        gCheckView.centerXAnchor == self.view.centerXAnchor + 38
        gCheckView.centerYAnchor == self.view.centerYAnchor + 200
        
        gAddView.isUserInteractionEnabled = true
        gCheckView.isUserInteractionEnabled = true
        
        gAddView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapAddView)))
        gCheckView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapCheckView)))
    }
    
    private func configRequest() {
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler:  { (request, error) in
            guard let resultViewController = self.resultViewController else {
                print("resultViewController is not set")
                return
            }
            if let results = request.results, !results.isEmpty {
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
    
    private func configCallback() {
        self.gAddViewCallback = { [weak self] in
            guard let self = self else { return }
            let documentCameraViewController = VNDocumentCameraViewController()
            documentCameraViewController.delegate = self
            self.present(documentCameraViewController, animated: true)
            print("!")
        }
        self.gCheckViewCallback = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.pushViewController(TableViewController(), animated: true)
            print("!!")
        }
    }
    
    @objc private func didTapAddView() {
        self.gAddViewCallback?()
    }
    
    @objc private func didTapCheckView() {
        self.gCheckViewCallback?()
    }
}

protocol RecognizedTextDataSource: AnyObject {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation])
}
