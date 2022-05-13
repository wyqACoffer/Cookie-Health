//
//  ResultViewController.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/12.
//

import UIKit
import Anchorage
import Vision

class ResultViewController: UIViewController {
    var textView = UITextView()
    var transcript = ""
    var saveView = ToolView(image: UIImage(named: "保存"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        // Do any additional setup after loading the view.
    }
    
    private func configView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.textView)
        self.view.addSubview(self.saveView)
        self.textView.text = transcript
        self.textView.topAnchor == self.view.topAnchor + 86
        self.textView.bottomAnchor == self.view.bottomAnchor - 85
        self.textView.rightAnchor == self.view.rightAnchor - 20
        self.textView.leftAnchor == self.view.leftAnchor + 20
        self.textView.contentSize = self.textView.frame.size
        self.textView.font = .boldSystemFont(ofSize: 38)
        self.saveView.centerXAnchor == self.view.centerXAnchor
        self.saveView.bottomAnchor == self.view.bottomAnchor - 20
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
// MARK: RecognizedTextDataSource
extension ResultViewController: RecognizedTextDataSource {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            print(candidate.string)
            switch gStyle {
            case .single:
                transcript += candidate.string
//                transcript += "\n"
            case .double :
                transcript += candidate.string
//                transcript += "\n"
            }
            
        }
        textView.text = transcript
    }
}
