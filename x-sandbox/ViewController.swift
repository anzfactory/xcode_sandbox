//
//  ViewController.swift
//  x-sandbox
//
//  Created by sasato on 2021/04/30.
//

import UIKit

class ViewController: UIViewController {
    
    private let targetView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: 150, height: 200))
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(targetView)
        NSLayoutConstraint.activate([
            targetView.widthAnchor.constraint(equalToConstant: targetView.frame.width),
            targetView.heightAnchor.constraint(equalToConstant: targetView.frame.height),
            targetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            targetView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        animateTypeA()
//        animateTypeB()
        animateTypeC()
    }
}

// 複数のアニメーションを "同時" に行う場合は CAAnimationGroup でまとめる
// let animationGroup = CAAnimationGroup()
// animationGroup.animations = [step1, step2, step3]
// AnimationGroup でまとめた場合の beginTime は 0 ベースで考える。
// もし AnimationGroup と他 Animation を数珠繋ぎでやる場合は、
// AnimationGroup の beginTime で同じように convertTiem で変換してセットする
//
// 数珠繋ぎで連続して行いたい場合は、下記のようにそれぞれをaddしていく
// layer.add(step1, forKey: "name1")
// layer.add(step2, forKey: "name2")
// layer.add(step3, forKey: "name3")
// そして、それぞれの Animation の beginTime と duration をうまくずらすことで連続して発生するように調整する
//
// begintTime で 0 ベースで考えるのか、Layer ベースで考えるのかは、
// その調整したい Animation の親が Layer なのか、そうではない（AnimationGroup）なのかで分ける
//
// layer.convertTime() を使わずに CACurrentMediaTime を直接使ってもいいけれど、
// 前者のほうがより正確な扱いになるので、基本的に前者でやっておけば問題なさそう

private extension ViewController {
    func animateTypeA() {
        let step1 = CABasicAnimation(keyPath: "transform.rotation.z")
        step1.duration = 0.5
        step1.beginTime = targetView.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.5
        step1.byValue = CGFloat(Double.pi / 180) * -15
        step1.fillMode = .forwards
        step1.isRemovedOnCompletion = false
        step1.timingFunction = .init(name: .easeOut)
        
        let step2 = CABasicAnimation(keyPath: "transform.rotation.z")
        step2.duration = 1.0
        step2.beginTime = targetView.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.0
        step2.byValue = CGFloat(Double.pi / 180) * 30
        step2.fillMode = .forwards
        step2.isRemovedOnCompletion = false
        step2.timingFunction = .init(name: .easeInEaseOut)
        
        let step3 = CABasicAnimation(keyPath: "transform.rotation.z")
        step3.duration = 0.5
        step3.beginTime = targetView.layer.convertTime(CACurrentMediaTime(), from: nil) + 2.0
        step3.byValue = CGFloat(Double.pi / 180) * -15
        step3.fillMode = .forwards
        step3.isRemovedOnCompletion = false
        step3.timingFunction = .init(name: .easeIn)
        
        let originalFrame = targetView.frame
        targetView.layer.anchorPoint = .init(x: 0.5, y: 1.2)
        targetView.frame = originalFrame // anchorPoint をずらすと位置座標までずれるのでそれを戻している
        targetView.layer.add(step1, forKey: "animationStep_1")
        targetView.layer.add(step2, forKey: "animationStep_2")
        targetView.layer.add(step3, forKey: "animationStep_3")
    }
    
    func animateTypeB() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.duration = 2.0
        rotation.byValue = CGFloat(Double.pi / 180) * 360
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.duration = 2.0
        scale.toValue = 2.0
        let animation = CAAnimationGroup()
        animation.animations = [ rotation, scale ]
        animation.duration = 2.0
        animation.beginTime = targetView.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.5
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = .init(name: .linear)
        targetView.layer.add(animation, forKey: "animation")
    }
    
    func animateTypeC() {
        // 始まる時間は少しずれるけど、アニメーション自体がかぶる場合
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.duration = 2.0
        rotation.byValue = CGFloat(Double.pi / 180) * 360
        // scale は少し遅れて（1秒後）発生させる
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.duration = 1.0
        scale.beginTime = 1.0   // この場合はGroupでまとめるので0ベースで考える
        scale.toValue = 2.0
        let animation = CAAnimationGroup()
        animation.animations = [ rotation, scale ]
        animation.duration = 2.0
        animation.beginTime = targetView.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.5
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = .init(name: .linear)
        targetView.layer.add(animation, forKey: "animation")
    }
}
