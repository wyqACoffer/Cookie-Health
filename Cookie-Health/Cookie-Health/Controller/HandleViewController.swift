//
//  HandleViewController.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/13.
//

import UIKit
import Anchorage
import Vision
import VisionKit

// TODO: wyq

class HandleViewController: UIViewController {
    var leftView = ToolView(image: UIImage(named: "左移"))
    var rightView = ToolView(image: UIImage(named: "右移"))
    var doneView = ToolView(image: UIImage(named: "完成"))
    var lineView = ToolView(image: UIImage(named: "虚线"))
    var imageView = UIImageView(image: UIImage(named: "位图"))
    var lineViewPoint = CGPoint(x: 207, y: 50)
    var textRecognitionRequest = VNRecognizeTextRequest()
    var resultViewController: (UIViewController & RecognizedTextDataSource)?
    var cgImage1: CGImage!
    var cgImage2: CGImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configRequest()
        // Do any additional setup after loading the view.
    }
    
    private func configView() {
        self.view.backgroundColor = gColorForBackgroundView
        self.view.addSubview(self.leftView)
        self.view.addSubview(self.rightView)
        self.view.addSubview(self.doneView)
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.lineView)
        self.leftView.centerYAnchor == self.view.centerYAnchor
        self.leftView.leftAnchor == self.view.leftAnchor + 15
        self.rightView.centerYAnchor == self.view.centerYAnchor
        self.rightView.rightAnchor == self.view.rightAnchor - 15
        self.doneView.centerXAnchor == self.view.centerXAnchor
        self.doneView.bottomAnchor == self.view.bottomAnchor - 20
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.leftAnchor == self.leftView.rightAnchor + 10
        self.imageView.rightAnchor == self.rightView.leftAnchor - 10
        self.imageView.centerYAnchor == self.view.centerYAnchor
        self.lineView.frame.origin = lineViewPoint
        self.leftView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapLeftView)))
        self.rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapRightView)))
        self.doneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapDoneView)))
    }
    
    private func configRequest() {
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
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
    
    private func calculatePoint(number: CGFloat, direction: Int) {
        /*
         direction: 0 -> left
                    1 -> right
         */
        let leftPointX = self.imageView.frame.origin.x
        let rightPointX = self.imageView.frame.origin.x + self.imageView.frame.width
        let linePointX = self.lineViewPoint.x
        switch direction {
        case 0:
            if (linePointX - leftPointX <= 5) { return }
        case 1:
            if (rightPointX - linePointX <= 5) { return }
        default:
            return
        }
        self.lineView.frame.origin = CGPoint(x: linePointX + number, y: 50)
        self.lineViewPoint = self.lineView.frame.origin
    }
    
    private func calculateRatio() -> CGFloat {
        return (self.lineView.frame.origin.x - self.imageView.frame.origin.x) / (self.imageView.frame.width)
    }
    
    @objc private func didTapLeftView() {
        self.calculatePoint(number: -5, direction: 0)
    }
    
    @objc private func didTapRightView() {
        self.calculatePoint(number: 5, direction: 1)
    }
    
    @objc private func didTapDoneView() {
        let width: CGFloat! = CGFloat((self.imageView.image?.cgImage?.width)!)
        let height: CGFloat! = CGFloat((self.imageView.image?.cgImage?.height)!)
        let ratio = self.calculateRatio()
        let cgImage1: CGImage! = self.imageView.image?.cgImage?.cropping(to: CGRect(x: 0, y: 0, width: width * ratio, height: height))
        let cgImage2: CGImage! = self.imageView.image?.cgImage?.cropping(to: CGRect(x: width * ratio, y: 0, width: width * (1 - ratio), height: height))
        self.cgImage1 = cgImage1
        self.cgImage2 = cgImage2
        self.configImage()
    }
    
    private func processImage(cgImage: CGImage) {
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
    }
    
    private func configImage() {
        self.resultViewController = ResultViewController()
        self.processImage(cgImage: self.cgImage1)
        self.processImage(cgImage: self.cgImage2)
        DispatchQueue.main.async {
            if let resultVC = self.resultViewController {
                self.navigationController?.pushViewController(resultVC, animated: true)
            }
        }
    }
    
    func setImage(image: UIImage) {
        self.imageView.image = image
        self.configView()
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
