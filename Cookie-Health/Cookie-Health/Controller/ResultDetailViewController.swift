//
//  ResultDetailViewController.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/20.
//

import UIKit

import UIKit
import Anchorage
import Vision
import AVFoundation

class ResultDetailViewController: UIViewController, UINavigationControllerDelegate {
    var textView = UITextView()
    var transcript = ""
    var deleteView = ToolView(image: UIImage(named: "删除"))
    var speakerView = ToolView(image: UIImage(systemName: "speaker.wave.2.circle.fill"))
    var playState = false
    var ifPlayFinished = true
    var syntesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        // Do any additional setup after loading the view.
    }
    
    private func configView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.textView)
        self.view.addSubview(self.deleteView)
        self.view.addSubview(self.speakerView)
        self.textView.text = transcript
        self.textView.topAnchor == self.view.topAnchor + 86
        self.textView.bottomAnchor == self.view.bottomAnchor - 85
        self.textView.rightAnchor == self.view.rightAnchor - 20
        self.textView.leftAnchor == self.view.leftAnchor + 20
        self.textView.layoutManager.allowsNonContiguousLayout = false
        self.textView.font = .boldSystemFont(ofSize: 30)
        self.deleteView.centerXAnchor == self.view.centerXAnchor + 20
        self.deleteView.bottomAnchor == self.view.bottomAnchor - 20
        self.speakerView.leftAnchor == self.view.leftAnchor + 10
        self.speakerView.centerYAnchor == self.deleteView.centerYAnchor
        self.speakerView.widthAnchor == self.speakerView.frame.width * 2.5
        self.speakerView.heightAnchor == self.speakerView.frame.height * 2.5
        self.speakerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapSpeaker)))
        self.syntesizer.delegate = self
        self.utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        self.utterance.pitchMultiplier = 1
        self.utterance.postUtteranceDelay = 0.8
        self.utterance.preUtteranceDelay = 1
        self.utterance.rate = 0.4
        self.deleteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapdeleteView)))
    }
    
    private func currentTime() -> String {
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "YYYY/MM/dd"
        return dateForMatter.string(from: Date())
    }
    
    private func configItem() {
        let userDefaults = UserDefaults.standard
        var itemImages = (userDefaults.imageArray(forKey: gItemImages) ?? [UIImage]()) as [UIImage]
        var itemNames = (userDefaults.array(forKey: gItemNames) ?? [String]()) as! [String]
        var itemTimes = (userDefaults.array(forKey: gItemTimes) ?? [String]()) as! [String]
        itemImages.append(itemImage)
        itemNames.append(itemName)
        itemTimes.append(itemTime)
        userDefaults.set(itemImages, forKey: gItemImages)
        userDefaults.set(itemNames, forKey: gItemNames)
        userDefaults.set(itemTimes, forKey: gItemTimes)
    }
    
    @objc private func didTapSpeaker() {
        if self.playState == false && self.ifPlayFinished == true {
            self.speakerView.image = UIImage(systemName: "pause.circle.fill")
            self.syntesizer.speak(self.utterance)
            self.playState = true
            self.ifPlayFinished = false
        } else if self.playState == true && self.ifPlayFinished == false {
            self.speakerView.image = UIImage(systemName: "play.circle.fill")
            self.syntesizer.pauseSpeaking(at: .immediate)
            self.playState = false
        } else if self.playState == false && self.ifPlayFinished == false {
            self.speakerView.image = UIImage(systemName: "pause.circle.fill")
            self.syntesizer.continueSpeaking()
            self.playState = true
        }
    }
    
    @objc private func didTapdeleteView() {
        var inputText = UITextField()
        let alertController = UIAlertController(title: "提示", message: "请输入标题", preferredStyle: .alert)
        let fineAction = UIAlertAction(title: "确定", style: .default) { action in
            itemName = inputText.text!
            itemTime = self.currentTime()
            self.configItem()
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.pushViewController(CollectionViewController(), animated: true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { acction in
            // Do any thing after cancel
        }
        alertController.addAction(fineAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { textField in
            inputText = textField
            inputText.placeholder = "输入名称"
        }
        self.present(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.syntesizer.stopSpeaking(at: .immediate)
    }

}
// MARK: RecognizedTextDataSource
extension ResultDetailViewController: RecognizedTextDataSource {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation]) {
        let maximumCandidates = 1
        for observation in recognizedText {
            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
            print(candidate.string)
            self.transcript += candidate.string
            self.utterance = AVSpeechUtterance(string: self.transcript)
        }
        textView.text = self.transcript
    }
}

extension ResultDetailViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.speakerView.image = UIImage(systemName: "speaker.wave.2.circle.fill")
        self.ifPlayFinished = true
        self.playState = false
    }
}

extension ResultViewController {

}
