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

class HandleViewController: UIViewController {
    var leftView = ToolView(image: UIImage(named: "左移"))
    var rightView = ToolView(image: UIImage(named: "右移"))
    var doneView = ToolView(image: UIImage(named: "完成"))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        // Do any additional setup after loading the view.
    }
    
    private func configView() {
        self.view.addSubview(self.leftView)
        self.view.addSubview(self.rightView)
        self.view.addSubview(self.doneView)
        self.leftView.centerYAnchor == self.view.centerYAnchor
        self.leftView.leftAnchor == self.view.leftAnchor + 25
        self.rightView.centerYAnchor == self.view.centerYAnchor
        self.rightView.rightAnchor == self.view.rightAnchor - 25
        self.doneView.centerXAnchor == self.view.centerXAnchor
        self.doneView.bottomAnchor == self.view.bottomAnchor - 20
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
