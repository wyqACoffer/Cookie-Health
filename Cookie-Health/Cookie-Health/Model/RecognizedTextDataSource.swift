//
//  RecognizedTextDataSource.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/12.
//

import UIKit
import Vision

protocol RecognizedTextDataSoure: AnyObject {
    func addRecognizedText(recogniedText: [VNRecognizedTextObservation])
}
