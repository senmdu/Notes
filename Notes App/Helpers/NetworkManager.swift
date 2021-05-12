//
//  NetworkManager.swift
//  Mvmm Test
//
//  Created by Senthil Kumar on 19/04/18.
//  Copyright © 2018 Senthil Kumar. All rights reserved.
//  Developer : Senthil Kumar (@senmdu96) - senmdu96@gmail.com


import UIKit
import SystemConfiguration

enum RequestType:String {
    case get  = "GET"
    case post = "POST"
}
struct NetworkManagerResult {
    fileprivate(set) var result : Data?
    fileprivate(set) var error : String?
}

enum NetworkManagerActions : String {
    case notes = "posts"
}


class NetworkManager {

    public var baseUrl = "https://raw.githubusercontent.com/RishabhRaghunath/JustATest/master/"
    public static let shared = NetworkManager()
    private lazy var session = URLSession(configuration: URLSessionConfiguration.default)
    private init() {}
    @objc private func statusManager(_ notification: Notification) {
        
    }
    
    
    public func get(_ action:NetworkManagerActions, params:[String:Any] = [:], completionHandler: @escaping (NetworkManagerResult) -> Void) {
        self.service(.get, url: baseUrl+action.rawValue, parameters: params, completionHandler: completionHandler)
    }
    public func post(_ action:NetworkManagerActions, params:[String:Any] = [:], completionHandler: @escaping (NetworkManagerResult) -> Void) {
        self.service(.post, url: baseUrl+action.rawValue, parameters: params, completionHandler: completionHandler)
    }
    public func get(_ url:String, params:[String:Any] = [:], completionHandler: @escaping (NetworkManagerResult) -> Void) {
        self.service(.get, url: url, parameters: params, completionHandler: completionHandler)
    }
    
    private func service(_ method:RequestType, url:String, parameters:[String:Any], completionHandler: @escaping (NetworkManagerResult) -> Void) {
        let request = self.getUrlRequest(url, parameters, method: method)
        
        let dataTask = session.dataTask(with: request as URLRequest) {data, response, error in
        
        DispatchQueue.main.async {
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(NetworkManagerResult(error: "Unable to get data from server"))
                return
            }
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                completionHandler(NetworkManagerResult(error: error!.localizedDescription))
                return
            }
            
            guard let res = response as? HTTPURLResponse,res.statusCode == 200 else {
                print("Error: did not receive data")
                completionHandler(NetworkManagerResult(error: "Something went wrong while getting data from server"))
                return
            }
           // print(String(data: responseData, encoding: String.Encoding.utf8) ?? "")
            let json = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String:Any]
            completionHandler(NetworkManagerResult(result: responseData))
            
         }
        }
        dataTask.resume()
        
    }
    var service : URLSessionDataTask!
    
    private func getUrlRequest(_ url:String, _ params: [String:Any], method:RequestType)-> NSMutableURLRequest {
        
        let request = NSMutableURLRequest()
        
        let urlComp = NSURLComponents(string: url)!
        
        var items = [URLQueryItem]()
        
        for (key,value) in params {
            items.append(URLQueryItem(name: key, value: "\(value)"))
        }
        
        items = items.filter{!$0.name.isEmpty}
        
        if method == .post {
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = params.percentEncoded()
        }else {
            if !items.isEmpty {
                urlComp.queryItems = items
            }
        }
        request.url = urlComp.url
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 100
        request.httpMethod = method.rawValue
        

        self.addHeaderValues(["Content-Type":"application/json",
                              "Accept":"application/json"], request: request)
        return request
    }
    
    private func addHeaderValues(_ headers: [String:String], request: NSMutableURLRequest) {
        
        headers.forEach { (key,value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
    }

}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
