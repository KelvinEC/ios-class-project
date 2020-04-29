//
//  ConnectionTest.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation

enum ConnectionError: Error
{
    case noInternet
}

class ConnectionTest
{
    /// Tests the internet connection using Apple's captive portal.
    ///
    /// - Warning: This method should never be used to prevent network operations.
    /// - Parameter handler: Handler that receives the result of the connection test.
    static func checkInternetConnection(handler: @escaping (Result<Void, ConnectionError>) -> Void)
    {
        let url = URL(string: "http://captive.apple.com")

        let task = URLSession.shared.dataTask(with: url!) {(data, _, error) in
            guard error == nil && data != nil else {
                handler(.failure(.noInternet))
                return
            }

            if let contentResponse = String(data: data!, encoding: .utf8) {
                if contentResponse == "<HTML><HEAD><TITLE>Success</TITLE></HEAD><BODY>Success</BODY></HTML>" {
                    handler(.success(()))
                }
            }
            handler(.failure(.noInternet))
        }

        task.resume()
    }
}
