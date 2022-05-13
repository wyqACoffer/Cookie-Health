//
//  ViewController.swift
//  Cookie-Health
//
//  Created by Acoffer on 2022/5/5.
//

import UIKit
import Anchorage

class ViewController: UIViewController {
    var gAddViewCallback: Block?
    var gCheckViewCallback: Block?
    var styleViewController = StyleViewController()
    
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
    

    
    private func configCallback() {
        self.gAddViewCallback = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.pushViewController(self.styleViewController, animated: true)
        }
        self.gCheckViewCallback = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.pushViewController(TableViewController(), animated: true)
        }
    }
    
    @objc private func didTapAddView() {
        self.gAddViewCallback?()
    }
    
    @objc private func didTapCheckView() {
        self.gCheckViewCallback?()
    }
}
