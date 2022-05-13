//
//  GlobalProperties.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/8.
//

import UIKit
import Vision
import VisionKit

// MARK: 类型别名
typealias Block = () -> ()

// MARK: 枚举类型
enum Style: Int {
    case single
    case double
}

// MARK: 全局常量
let gColorForBackgroundView = UIColor.init(red: 95 / 255, green: 165 / 255, blue: 229 / 255, alpha: 1)
let gAddView = ToolView(image: UIImage(named: "添加"))
let gCheckView = ToolView(image: UIImage(named: "查看"))

var  gStyle: Style = .single

// MARK: 协议
protocol RecognizedTextDataSource: AnyObject {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation])
}
