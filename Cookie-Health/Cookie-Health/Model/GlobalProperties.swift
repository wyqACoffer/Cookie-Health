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

// MARK: 静态常量
let gItemImages = "itemImages"
let gItemNames = "itemsNames"
let gItemTimes = "itemsTimes"

// MARK: 枚举类型
enum Style: Int {
    case single
    case double
}

// MARK: 全局变量
var itemImage = UIImage()
var itemName = ""
var itemTime = ""

// MARK: 全局常量
let gColorForBackgroundView = UIColor.init(red: 95 / 255, green: 165 / 255, blue: 229 / 255, alpha: 1)

var  gStyle: Style = .single

// MARK: 协议
protocol RecognizedTextDataSource: AnyObject {
    func addRecognizedText(recognizedText: [VNRecognizedTextObservation])
}

extension UserDefaults {
    func imageArray(forKey key: String) -> [UIImage]? {
        guard let array = self.array(forKey: key) as? [Data] else {  return nil }
        return array.compactMap({
            UIImage(data: $0)
        })
    }
    
    func set(_ imageArray: [UIImage], forKey key: String) {
        self.set(imageArray.compactMap({
            $0.pngData()
        }), forKey: key)
    }
}
