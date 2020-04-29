//
//  Networking.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation
import UIKit.UIImage

enum ServerURL: String
{
    case debug = "https://jsonplaceholder.typicode.com/"
}

enum HTTPRequestTypes: String
{
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case post = "POST"
}

enum NetworkErrors: Error
{
    case serverError
    case serverUnavailable
    case connectionError
    case noInternetConnection
    case decodingError
}

class Networking
{
    public static let shared: Networking = Networking()

    private var _currentEndpoint: ServerURL

    private let _urlSession: URLSession

    private var _authorization: String?

    init()
    {
        _currentEndpoint = .debug
        _urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }

    func execute<T:Decodable>(request: URLRequest, handler: @escaping (Result<T, NetworkErrors>) -> Void)
    {
        let task = _urlSession.dataTask(with: request) { data, response, error in

            let parsedResponse: Result<T, NetworkErrors> = self.parseURLRequestResponse(data: data,
                                                                                        urlResponse: response,
                                                                                        error: error)

            switch parsedResponse {
            case .failure(let error):
                switch error {
                case .connectionError:
                    ConnectionTest.checkInternetConnection { response in
                        switch response {
                        case .success:
                            handler(.failure(.serverUnavailable))
                        case .failure:
                            handler(.failure(.noInternetConnection))
                        }
                    }
                default:
                    handler(.failure(error))
                }
            case .success(let response):
                handler(.success(response))
            }
        }

        task.resume()
    }

    public func set(authorization: String?)
    {
        _authorization = authorization
    }

    func createRequest(operation: String,
                       type: HTTPRequestTypes,
                       parameters: [String: Any]?) -> URLRequest?
    {
        var components = URLComponents(string: _currentEndpoint.rawValue + operation)
        var bodyData: Data?
        var queryParameters: String?
        var headerParams: [String: String] = [:]

        if let params = parameters {
            switch type {
            case .put:
                bodyData = urlizeParameters(parameters: params).data(using: .ascii)
            case .delete:
                queryParameters = urlizeParameters(parameters: params)
            case .get:
                queryParameters = urlizeParameters(parameters: params)
            case .post, .patch:
                if let params = parameters {
                    if params.values.contains(where: {$0 is UIImage || $0 is [UIImage]}) {
                        let boundary = UUID().uuidString
                        headerParams["Content-Type"] = "multipart/form-data; charset=utf8; boundary=\(boundary)"
                        bodyData = createUploadBody(with: params, boundary: boundary)
                    } else {
                        bodyData = urlizeParameters(parameters: params).data(using: .ascii)
                    }
                }
            }

            components?.percentEncodedQuery = queryParameters
        }

        guard let url = components?.url  else {
            return nil
        }

        var urlRequest: URLRequest = URLRequest(url: url,
                                                cachePolicy: .reloadIgnoringLocalCacheData,
                                                timeoutInterval: 60.0)

        urlRequest.httpMethod = type.rawValue.capitalized
        urlRequest.httpBody = bodyData

        for param in headerParams {
            urlRequest.setValue(param.value, forHTTPHeaderField: param.key)
        }

        urlRequest.setValue(_authorization, forHTTPHeaderField: "Authorization")

        return urlRequest
    }

    func createUploadBody(with parameters: [String: Any], boundary: String) -> Data
    {
        var body = Data()

        for (key, value) in parameters {

            if(value is String || value is NSString) {
                body.append("--\(boundary)\r\n".data(using: .utf8, allowLossyConversion: false)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8, allowLossyConversion: false)!)
                body.append("\(value)\r\n".data(using: .utf8, allowLossyConversion: false)!)
            } else if value is Int {
                body.append("--\(boundary)\r\n".data(using: .utf8, allowLossyConversion: false)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8, allowLossyConversion: false)!)
                body.append("\(value)\r\n".data(using: .utf8, allowLossyConversion: false)!)
            } else if let image = value as? UIImage {
                let r = arc4random()
                let filename = "image\(r).jpg"
                let data = image.jpegData(compressionQuality: 1);
                let mimetype = "image/jpg"

                body.append("--\(boundary)\r\n".data(using: .utf8, allowLossyConversion: false)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: .utf8, allowLossyConversion: false)!)
                body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8, allowLossyConversion: false)!)
                body.append(data!)
                body.append("\r\n".data(using: .utf8, allowLossyConversion: false)!)
            } else if let images = value as? [UIImage] {
                for (index, image) in images.enumerated() {
                    let r = arc4random()
                    let filename = "image\(r).jpg"
                    let data = image.jpegData(compressionQuality: 0.8);
                    let mimetype = "image/jpg"

                    body.append("--\(boundary)\r\n".data(using: .utf8, allowLossyConversion: false)!)
                    body.append("Content-Disposition: form-data; name=\"\(key)\(index)\"; filename=\"\(filename)\"\r\n".data(using: .utf8, allowLossyConversion: false)!)
                    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8, allowLossyConversion: false)!)
                    body.append(data!)
                    body.append("\r\n".data(using: .utf8, allowLossyConversion: false)!)
                }
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8, allowLossyConversion: false)!)

        return body
    }

    private func urlizeParameters(parameters: [String: Any]) -> String
    {
        let allowedCharacterSet = CharacterSet(charactersIn: "/+=\n").inverted

        let query: [String] = parameters.map { key, value in
            let key = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            var val: String = ""

            if let v = value as? String {
                if let r = v.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)?
                    .addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
                    val = r
                }
            } else if let v = value as? Data {
                if let r = v.base64EncodedString().addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
                    val = r
                }
            } else if let v = value as? Int {
                if let r = v.description.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)?
                    .addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
                    val = r
                }
            } else if let v = value as? UInt32 {
                if let r = v.description.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)?
                    .addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
                    val = r
                }
            } else if let v = value as? [String], v.count > 0 {
                if let r = v.reduce(v[0], { $0 + "," + $1 })
                    .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)?
                    .addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
                    val = r
                }
            }

            return "\(key)=\(val)"
        }

        return query.joined(separator: "&")
    }

    private func parseURLRequestResponse<T:Decodable>(data: Data?,
                                            urlResponse: URLResponse?,
                                            error: Error?) -> Result<T, NetworkErrors>
    {
        guard error == nil, let httpUrlResponse = urlResponse as? HTTPURLResponse, let responseData = data else {
            return .failure(.connectionError)
        }

        guard httpUrlResponse.statusCode <= 299 else {
            return .failure(.connectionError)
        }

        if let result: T = _decode(data: responseData) {
            return .success(result)
        } else {
            return .failure(.decodingError)
        }
    }


    private func _decode<T:Decodable>(data: Data) -> T?
    {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let e {
            print(e)
            return nil
        }
    }
}
