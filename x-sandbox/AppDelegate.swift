//
//  AppDelegate.swift
//  x-sandbox
//
//  Created by sasato on 2021/04/30.
//

import BackgroundTasks
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var title: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "xyz.anzfactory.x-sandbox.bgtask", using: nil) { task in
            let que = OperationQueue()
            que.maxConcurrentOperationCount = 1
            let operation = TestTaskOperation()
            operation.completionBlock = {
                task.setTaskCompleted(success: true)
            }
            que.addOperation(operation)
        }
        
        BGTaskScheduler.shared.getPendingTaskRequests { reqs in
            reqs.forEach { print($0.identifier) }
        }
        
        BGTaskScheduler.shared.cancelAllTaskRequests()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate {
    func sceduleBackgroundTask() {
        let taskRequest = BGAppRefreshTaskRequest(identifier: "xyz.anzfactory.x-sandbox.bgtask")
        taskRequest.earliestBeginDate = .init(timeIntervalSinceNow: 5 * 60) // 5分後以降
        do {
            try BGTaskScheduler.shared.submit(taskRequest)
        } catch {
            print(error)
        }
    }
}
