//
//  WebServiceManager.swift
//  TickledMediaTest
//
//  Created by Mohit Kapadia on 06/10/18.
//  Copyright © 2018 Mohit Kapadia. All rights reserved.
//

import Foundation

//MARK: - APIError Type
enum APIError {
    case noInternet
    case invalidData
    case unknown
    case other(Int?,String)
    
    func description()->(Int,String) {
        switch self {
        case .noInternet:
            return (code:0,message:"No Internet connection")
        case .invalidData:
            return (code:1,message:"Invalid response")
        case .unknown:
            return (code:2,message:"Something went wrong")
        case .other(let code, let message):
            return (code ?? -1,message)
        }
    }
}

//MARK: - HTTPMethodType
enum HTTPMethodType : String {
    case get
    case post
}

//MARK: - ServiceParamters
struct ServiceParamters {
    var method: HTTPMethodType = .get
    var body: JsonDictionary? = nil
    var serviceName: WebService.Name
    var url: URL {
        return serviceName.url!
    }
}

/*struct WebServiceResponse<Entity: Codable>: Codable {
    let status: Bool
    let message: String
    let response: Entity
}*/

//MARK: - ServiceResponseRepresentable
protocol ServiceResponseRepresentable {
    associatedtype T : Codable
    var status: Bool {get set}
    var message: String {get set}
    var response: T {get set}
}

//MARK: - ResponseType
enum ResponseType<EntityType:Codable> {
    case success(WebService.Name, EntityType)
    case failure(WebService.Name, APIError)
}

//MARK: - WebService Paths
struct WebService {
    static let baseURL = "https://api.myjson.com"
    
    enum Name:String {
        case dummyPath = "/bins/vt8zx"
        
        var url : URL? {
            return URL(string: (baseURL + self.rawValue))
        }
    }
}

//MARK: - ServiceManager

/// Handles Web service calls
class ServiceManager<T : Codable> {
    
    // can initialise
    init() {
    }
    
    
    /// Call web service to fetch the data from server
    ///
    /// - Parameters:
    ///   - parameters: ServiceParameters, to prepare http request
    ///   - requestOptions: [String:Any], pass additional for request
    ///   - callback: Callback of web service response
    /// - Returns: URLSessionDataTask, data task object to handle canceling
    func callWebService( parameters:ServiceParamters,
                         requestOptions: JsonDictionary? = nil,
                         callback:@escaping (ResponseType<T>)->Void) -> URLSessionDataTask? {
        
        var urlRequest = URLRequest(url: parameters.url)
        urlRequest.httpMethod = parameters.method.rawValue
        
        //perform execution on main thread
        let executeOnMain : (ResponseType<T>)->Void = { (resonseType) in
            DispatchQueue.main.async {
                callback(resonseType)
            }
        }
        
        //Check for network availablity
        guard appDelegate.reachability.isReachable else {
            executeOnMain(.failure(parameters.serviceName, APIError.noInternet))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                executeOnMain(.failure(parameters.serviceName, .other(nil, error!.localizedDescription)))
                return
            }
            
            guard let serviceData = data else {
                executeOnMain(.failure(parameters.serviceName, .unknown))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard 200...299 ~= response.statusCode else {
                    executeOnMain(.failure(parameters.serviceName, .other(response.statusCode, HTTPURLResponse.localizedString(forStatusCode: response.statusCode))))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let responeEntity = try decoder.decode(T.self, from: serviceData)
                    executeOnMain(.success(parameters.serviceName, responeEntity))
                    
                } catch let error {
                    #if DEBUG
                        print("Unable to parse json data Error--%@",error.localizedDescription)
                    #endif
                    executeOnMain(.failure(parameters.serviceName, .invalidData))
                }
            }
        }
        task.resume()
        return task
    }
    
    
}
