//
//  LoadView.swift
//  ChuckNorrisFacts
//
//  Created by Gabriel Borges on 27/04/20.
//  Copyright © 2020 Gabriel Borges. All rights reserved.
//

import UIKit

class LoadView: UIView {
    
    var containerView = UIView()
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupLoadingView()
    }
    
    private func setupLoadingView() {
        containerView.frame = self.frame
        containerView.center = self.center
        containerView.backgroundColor = UIColor(red: 192 / 255, green: 192 / 255, blue: 192 / 255, alpha: 0.5)

        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.center
        loadingView.backgroundColor = UIColor(red: 64 / 255, green: 64 / 255, blue: 64 / 255, alpha: 1)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        containerView.addSubview(loadingView)
        self.addSubview(containerView)
    }
    
    func showLoading(_ isShow: Bool, atView view: UIView?) {
        if isShow {
            activityIndicator.startAnimating()
            view?.addSubview(self)
            view?.pinnedSubView(self)
        } else {
            removeFromSuperview()
        }
    }
}
