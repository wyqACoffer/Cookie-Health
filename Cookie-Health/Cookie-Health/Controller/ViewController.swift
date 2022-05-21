//
//  ViewController.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/5.
//

import UIKit
import Anchorage

class ViewController: UIViewController {
    let addView = ToolView(image: UIImage(named: "添加"))
    let addViewFont = UIImageView(image: UIImage(named: "添加-F"))
    let checkView = ToolView(image: UIImage(named: "查看"))
//    let checkViewFont = UIImageView(image: UIImage(named: "-F"))
    
    var addViewCallback: Block?
    var checkViewCallback: Block?
    var styleViewController = StyleViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("用户uuid：\(self.get_uuid())")
        self.configView()
        self.configCallback()
    }

    private func configView() {
        self.view.backgroundColor = gColorForBackgroundView
        self.view.addSubview(self.addView)
        self.view.addSubview(self.checkView)
        
        self.addView.centerXAnchor == self.view.centerXAnchor - 38
        self.addView.centerYAnchor == self.view.centerYAnchor - 200
        
        self.checkView.centerXAnchor == self.view.centerXAnchor + 38
        self.checkView.centerYAnchor == self.view.centerYAnchor + 200
        
        self.addView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapAddView)))
        self.checkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapCheckView)))
    }
    
    private func get_uuid() -> String {
        let userID = UserDefaults.standard.string(forKey: "hello")
        if userID != nil {
            print("第N次运行")
            return userID!
        } else {
            let uuid_ref = CFUUIDCreate(nil)
            let uuid_string_ref = CFUUIDCreateString(nil, uuid_ref)
            let uuid = uuid_string_ref! as String
            UserDefaults.standard.set(uuid, forKey: "hello")
            print("第一次运行")
            let userDefault = UserDefaults.standard
            var itemImages = [UIImage]()
            var itemNames = [String]()
            var itemTimes = [String]()
            itemImages.append(UIImage(named: "位图")!)
            itemNames.append("测试图例")
            itemTimes.append("2020/05/20")
            userDefault.set(itemImages, forKey: gItemImages)
            userDefault.set(itemNames, forKey: gItemNames)
            userDefault.set(itemTimes, forKey: gItemTimes)
            return uuid
        }
    }
    
    private func configCallback() {
        self.addViewCallback = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.pushViewController(self.styleViewController, animated: true)
        }
        self.checkViewCallback = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.pushViewController(CollectionViewController(), animated: true)
        }
    }
    
    @objc private func didTapAddView() {
        self.addViewCallback?()
    }
    
    @objc private func didTapCheckView() {
        self.checkViewCallback?()
    }
}
