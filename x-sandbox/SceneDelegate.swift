//
//  SceneDelegate.swift
//  x-sandbox
//
//  Created by sasato on 2021/04/30.
//

import LocalAuthentication
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = scene as? UIWindowScene {
            let window = ScreenLocker(currentScene: windowScene, currentKeyWindow: windowScene.windows.first!)
                self.window = window
            }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("scene did become")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    private var locker: ScreenLocker?
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("scene will enter foreground")
        if let windowScene = scene as? UIWindowScene, let lockWindow = ScreenLocker.setup(scene: windowScene) {
            window = lockWindow
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

final class ScreenLocker: UIWindow {
    static func setup(scene: UIWindowScene) -> ScreenLocker? {
        guard
            let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
            !(keyWindow is Self)
        else {
            return nil
        }
        
        let lockWindow = ScreenLocker(currentScene: scene, currentKeyWindow: keyWindow)
        lockWindow.makeKeyAndVisible()
        return lockWindow
    }
    
    private let prevKeyWindow: UIWindow
    init(currentScene: UIWindowScene, currentKeyWindow keyWindow: UIWindow) {
        prevKeyWindow = keyWindow
        super.init(windowScene: currentScene)
        windowLevel = .statusBar
        rootViewController = LockViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func unlock() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        (scene.delegate as? SceneDelegate)?.window = prevKeyWindow
        prevKeyWindow.makeKeyAndVisible()
    }
}

final class LockViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var context: LAContext = {
        LAContext()
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit vc")
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .systemPink
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addTarget(self, action: #selector(type(of: self).didTapButton(_:)), for: .touchUpInside)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func autholized() {
        guard
            let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
            let rockWindow = window as? ScreenLocker
        else {
            return
        }
        rockWindow.unlock()
    }
}

@objc private extension LockViewController {
    func didTapButton(_ sender: UIButton) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "ロック解除") { [weak self] isSuccess, error in
            guard isSuccess else {
                return
            }
            DispatchQueue.main.async {
                self?.autholized()
            }
        }
    }
}
