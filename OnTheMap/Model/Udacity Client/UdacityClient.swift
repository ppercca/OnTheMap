//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Paul Cristian Percca Julca on 7/5/20.
//  Copyright © 2020 Innovatrix. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
        static var accountKey = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        case getStudentLocations
        case putStudentLocation(String)
        case postStudentLocation
        case signUp
        case getUserInfo(String)
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
            case .getStudentLocations:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .putStudentLocation(let objectId):
                return Endpoints.base + "/StudentLocation/\(objectId)"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            case .getUserInfo(let userId):
                return Endpoints.base + "/users/\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
// MARK: - User Session Methods
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: Udacity(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.session.url, clean: true, responseType: SessionResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountKey = response.account!.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        taskForDeleteTRequest(url: Endpoints.session.url, clean: true, responseType: SessionResponse.self) { (response, error) in
            if response != nil {
                Auth.sessionId = ""
                Auth.accountKey = ""
                Auth.firstName = ""
                Auth.lastName = ""
                Auth.objectId = ""
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getUserInfo(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserInfo(Auth.accountKey).url, clean: true, responseType: UserInfo.self) { (response, error) in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
// MARK: - Student Location Methods
    
    class func postStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        let body = StudentInformation(objectId: "", uniqueKey: Auth.accountKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, createdAt: "", updatedAt: "")
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, clean: false, responseType: StudentInformationResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func putStudentLocation(mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        let body = StudentInformation(objectId: "", uniqueKey: Auth.accountKey, firstName: Auth.firstName, lastName: Auth.lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, createdAt: "", updatedAt: "")
        taskForPUTRequest(url: Endpoints.putStudentLocation(Auth.objectId).url, clean: false, responseType: StudentInformationResponse.self, body: body) { (response, error) in
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }

    class func getStudentLocation(completion: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocations.url, clean: false, responseType: UdacityResponse.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
// MARK: - Http Methods
    
    class func cleanResponse(_ data: Data) -> Data {
        let range = (5..<data.count)
        return data.subdata(in: range)
    }
    
    @discardableResult class func taskForGETRequest<ResponseType: Decodable>(url: URL, clean: Bool, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType.self, from: clean ? cleanResponse(data): data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, clean: Bool, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: clean ? cleanResponse(data): data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                   let errorResponse = try decoder.decode(ErrorResponse.self, from: clean ? cleanResponse(data): data)
                   DispatchQueue.main.async {
                       completion(nil, errorResponse)
                   }
               } catch {
                   DispatchQueue.main.async {
                       completion(nil, error)
                   }
               }
            }
        }
        task.resume()
    }
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, clean: Bool, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: clean ? cleanResponse(data): data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                   let errorResponse = try decoder.decode(ErrorResponse.self, from: clean ? cleanResponse(data): data)
                   DispatchQueue.main.async {
                       completion(nil, errorResponse)
                   }
               } catch {
                   DispatchQueue.main.async {
                       completion(nil, error)
                   }
               }
            }
        }
        task.resume()
    }
    
    class func taskForDeleteTRequest<ResponseType: Decodable>(url: URL, clean: Bool, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: clean ? cleanResponse(data): data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                   let errorResponse = try decoder.decode(ErrorResponse.self, from: clean ? cleanResponse(data): data)
                   DispatchQueue.main.async {
                       completion(nil, errorResponse)
                   }
               } catch {
                   DispatchQueue.main.async {
                       completion(nil, error)
                   }
               }
            }
        }
        task.resume()
    }

}
