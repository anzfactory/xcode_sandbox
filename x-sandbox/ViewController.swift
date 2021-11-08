//
//  ViewController.swift
//  x-sandbox
//
//  Created by sasato on 2021/04/30.
//

import UIKit

class ViewController: UIViewController {
    
    private let circle: CircleView = {
        let view = CircleView(frame: .init(x: 0, y: 0, width: 160, height: 160))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(circle)
        NSLayoutConstraint.activate([
            circle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circle.widthAnchor.constraint(equalToConstant: circle.frame.width),
            circle.heightAnchor.constraint(equalToConstant: circle.frame.height)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.circle.animate()
        }
    }
}

final class CircleView: UIView {
    
    override public class var layerClass: Swift.AnyClass {
        return CAShapeLayer.self
    }
    
    private let strokeWidth: CGFloat = 4.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        setupCircle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 3.0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        layer.add(animation, forKey: nil)
    }
    
    private func setupCircle() {
        
        guard let shape = layer as? CAShapeLayer else {
            return
        }
        
        let path = UIBezierPath.init(arcCenter: center, radius: (frame.width - strokeWidth) * 0.5, startAngle: -90 * .pi / 180, endAngle: 270 * .pi / 180, clockwise: true)
        shape.strokeEnd = 0
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = backgroundColor?.cgColor
        shape.lineWidth = strokeWidth
    }
}
