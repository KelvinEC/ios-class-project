//
//  ViewControllerProtocol.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation
import UIKit.UIAlertController

protocol ViewControllerProtocol: AnyObject
{
    func showNetworkError()

    func showNoInternetConnection()

    func showUnknownError()

    func showError(title: String, message: String)
}

extension ViewControllerProtocol where Self: UIViewController
{
    func showError(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: nil)

        alert.addAction(okAction)

        self.present(alert, animated: true)
    }

    func showNetworkError()
    {
        showError(title: NSLocalizedString("Error", comment: ""),
                  message: "A Network error occurred, please try again")
    }

    func showNoInternetConnection()
    {
        showError(title: NSLocalizedString("Error", comment: ""),
        message: "Your internet connection appears to be offline.")
    }

    func showUnknownError()
    {
        showError(title: NSLocalizedString("Error", comment: ""),
        message: "An strange error occurred, please try again.")
    }
}
