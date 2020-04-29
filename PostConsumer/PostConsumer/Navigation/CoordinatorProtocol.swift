//
//  CoordinatorProtocol.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject
{
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func childDidFinish(_ child: Coordinator?)

    func start()
}

extension Coordinator
{
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
