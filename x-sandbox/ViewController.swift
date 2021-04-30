//
//  ViewController.swift
//  x-sandbox
//
//  Created by sasato on 2021/04/30.
//

import UIKit

class ViewController: UIViewController {
    
    private let safariIcon: UIImageView = {
        let view = UIImageView(image: Asset.Icon.safariOutline.image.withRenderingMode(.alwaysTemplate))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .systemGray
        return view
    }()
    
    private let xmarkIcon: UIImageView = {
        let view = UIImageView(image: Asset.Icon.xmarkCircle.image.withRenderingMode(.alwaysTemplate))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .systemPink
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(safariIcon)
        view.addSubview(xmarkIcon)
        NSLayoutConstraint.activate([
            safariIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            safariIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            xmarkIcon.topAnchor.constraint(equalTo: safariIcon.bottomAnchor, constant: 16.0),
            xmarkIcon.centerXAnchor.constraint(equalTo: safariIcon.centerXAnchor)
        ])
        
    }
}

