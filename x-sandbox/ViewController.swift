//
//  ViewController.swift
//  x-sandbox
//
//  Created by sasato on 2021/04/30.
//

import IQKeyboardManager
import UIKit

class ViewController: UIViewController {
    
    private let field: UITextField = {
        let field = UITextField(frame: .zero)
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "5"
        field.toolbarPlaceholder = "最大10名まで"
        return field
    }()
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "名"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(field)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            field.widthAnchor.constraint(equalToConstant: 32.0),
            field.heightAnchor.constraint(equalToConstant: 32.0),
            field.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            field.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: label.frame.width * -0.5),
            label.centerYAnchor.constraint(equalTo: field.centerYAnchor),
            label.leftAnchor.constraint(equalTo: field.rightAnchor, constant: 4.0)
        ])
    }
}

