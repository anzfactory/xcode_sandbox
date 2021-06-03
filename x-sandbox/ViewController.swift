//
//  ViewController.swift
//  x-sandbox
//
//  Created by sasato on 2021/04/30.
//

import AppTrackingTransparency
import BackgroundTasks
import UIKit

class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Background Tasks"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        BGTaskScheduler.shared.getPendingTaskRequests { reqs in
            guard !reqs.isEmpty else {
                return
            }
            DispatchQueue.main.async {
                self.label.text = reqs.map { $0.identifier }.joined(separator: ",")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

final class TestTaskOperation: Operation {
    override func main() {
        print("start background task")
        ATTrackingManager.requestTrackingAuthorization { status in
            print(status)
            UserDefaults.standard.setValue("\(status.rawValue)", forKey: "title")
        }
    }
}
