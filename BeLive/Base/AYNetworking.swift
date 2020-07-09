//
//  AYNetworking.swift
//  YUXI
//
//  Created by YUXI on 2016/12/14.
//
//

import Foundation
import SwiftyJSON 
import AdSupport
import DeviceKit
import Reachability
//import CryptoSwift
//import AlicloudHttpDNS


//MARK: baseHost 和getBaseHostForHtml_S---------------
//let baseHostForHtml_S = ""

//G dev
#if DEBUG  //
//var baseHost = "http://192.168.2.162:7072"
var baseHost = "http://47.56.92.40:8080"//"http://47.52.246.222"
var apiHost = baseHost
var uHost = "\(apiHost)/api/u"
let sHost = "\(baseHost)/api/s"
var wHost = "\(baseHost)/api/w"
//let tHost = "\(apiHost)"
let aHost = "\(baseHost)/api/a"
//let cHost = "\(apiHost)"
//let iHost = "\(apiHost)"
//let gHost = "\(apiHost)"
//let ws = "ws://47.91.173.208:8326"
//let wsForChat = "ws://47.91.173.208:8327"
let webHost = "http://47.244.197.126:8080"//
let inviteHost = "http://47.56.97.57:8811"

#else
//G pro
let baseHost = "http://47.56.92.40:8080"
let apiHost = "\(baseHost)"
let uHost = apiHost
//let sHost = "\(apiHost)/v2/s"
let wHost = "\(baseHost)"
//let tHost = "\(apiHost)/v2/t"
//let aHost = "\(apiHost)/v2/a"
//let cHost = "\(apiHost)/v2/c"
//let iHost = "\(apiHost)/v2/i"
//let gHost = "\(apiHost)/v2/g"
//let ws = "wss://ws.mbaex.com"
//let wsForChat = "\(ws)/im"
//let webHost = "http://47.244.168.211:8401"
let inviteHost = "http://47.56.97.57:8811"

#endif


let kRequestPage            = "page"
let kRequestPerPage         = "per_page"
let kRequestLoad            = "load"
let kRequestSequence        = "sequence"

let kResponseData = "data"
let kResponseCode = "errcode"
let kResponseMessage = "errmsg"
let kResponseHasMorePages    = "has_more_pages"


//MARK: extension String 扩展方法：escape--------------------------------
extension String {
    func escape() -> String {
        //        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        //        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        //        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        allowedCharacterSet.remove(charactersIn: ":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`")
        
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        
        if #available(iOS 8.3, *) {
            escaped = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
        } else {
            let batchSize = 50
            var index = self.startIndex
            
            while index != self.endIndex {
                let startIndex = index
                let endIndex = self.index(index, offsetBy: batchSize, limitedBy: self.endIndex) ?? self.endIndex
                let range = startIndex..<endIndex
                
                let substring = self.substring(with: range)
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
                
                index = endIndex
            }
        }
        
        return escaped
    }
}


//MARK: AYNetworkingError类封装网络请求错误信息----------------------
struct AYNetworkingError {
    enum Code {
        case paramsError                    //网络请求时，传递的参数有问题，导致obj转化成data的时候出错
        case networkFailed                  //网络请求失败
        case dataFormatError                //返回数据格式错误(json解析失败)
        case bussinessResultFalse           //业务请求返回false
        case bussinessResultNull            //返回的数据为null
    }
    
    var descriptionString: String?          //bussinessErrorMessage不为nil的时候等于bussinessErrorMessage，默认nil，外部也可调用赋值修改
    
    var errorCode: Code?                    //网络请求失败的错误码（自定义）
    var bussinessErrorCodeString: String?   //后台返回的code码
    var bussinessErrorMessage: String? {    //后台返回的信息
        didSet {
            self.descriptionString = self.bussinessErrorMessage
        }
    }
    
    var requestContext = [String : Any]()
    
    init(errorCode: Code?, bussinessErrorCodeString: String? = nil, bussinessErrorMessage: String? = nil, descriptionString: String? = nil) {
        self.errorCode = errorCode
        self.bussinessErrorCodeString = bussinessErrorCodeString
        self.bussinessErrorMessage = bussinessErrorMessage
        
        if descriptionString != nil {
            self.descriptionString = descriptionString
        }else if bussinessErrorMessage != nil {
            self.descriptionString = bussinessErrorMessage
        }
    }
}


struct AYBoundaryHelper {
    static func randomBoundary() -> String {
        return String(format: "AYNetworking.boundary.YUXI.%08x%08x", arc4random(), arc4random())
    }
}

//MARK: AYNetworking类封装NSURLSession进行网络请求----------------------
typealias AYNetworkingSuccess = (_ result: JSON, _ requestContext: Dictionary<String, Any>?) -> ()
typealias AYNetworkingFailure = (_ error: AYNetworkingError, _ requestContext: Dictionary<String, Any>?) -> ()
typealias AYNetworkingFinally = (_ requestContext: Dictionary<String, Any>?) -> ()

let deviceInfo = { () -> [String : String] in
    //    let outerVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    //    let innerVersion = (Bundle.main.infoDictionary!["CFBundleVersion"] as! String).components(separatedBy: ".").first!
    //    let device = Device()
    //    let systemName = device.systemName;//操作系统 e.g. @"iOS"
    //    let systemVersion = device.systemVersion;//系统版本 e.g. @"4.0"
    //    let deviceVersion = device.description;
    //    let appkey = "iVCoin";
    //
    //    return ["appkey" : appkey,
    //            "device_os" : systemName,
    //            "sysver" : systemVersion,
    //            "ver" : outerVersion,
    //            "vercode" : innerVersion,
    //            "device" : deviceVersion,
    //            "uid" : BaseSingleton.uid()!]
    return [:]
}

extension Notification.Name {
    static let specialNetworkingStatusCode = NSNotification.Name(rawValue: "kSpecialStatusCodeNotification_Name")
    static let tokenWillExpire = NSNotification.Name(rawValue: "kTokenWillExpireNotification_Name")
}

class AYNetworking: NSObject {
    //单例
    static let share = AYNetworking()
    
    fileprivate var task: AYTask?
    fileprivate var request: URLRequest?
    
    func cancel() -> Void {
        if task != nil {
            AYNetworkingManager.manager.cancelTask(identifier: task!.identifier)
        }
    }
    
    
    //MARK: - 参数编码
    fileprivate func paramsEncodingWithDic(_ params: Dictionary<String, Any>) -> Dictionary<String, Any> {
        var newParams = Dictionary<String, Any>()
        for (key, value) in params {
            if let valueString = value as? String {
                ////编码后的字符串
                newParams[key] = valueString.escape()
            } else {
                newParams[key] = value
            }
        }
        return newParams
    }
    
    //MARK: - http头部信息
    fileprivate static func getHttpHeader(urlString: String) -> Dictionary<String, String> {
        var result = Dictionary<String, String>()
        
//        if (AYAuthor.shared.token?.count ?? 0) > 0, !urlString.contains("/login") {
//            result["Authorization"] = "\(AYAuthor.shared.token!)"
//        }
        result["lang"] = AYLocalizationManager.serverLang()
        result["x-did"] = Utility.deviceId()
        
        return result
    }
    
    // MARK:- 发起一个网络请求
    func startNetworking(path: String, parameters: Dictionary<String,Any>? = nil, urlStringNeedEncoding: Bool = true, httpHeader: Dictionary<String,String>? = nil, vcIdentifier: AYNetworkingVProtocol, httpMethod: String, requestContext: Dictionary<String, Any>? = nil, success: @escaping (AYNetworkingSuccess), failure: @escaping (AYNetworkingFailure), finally: @escaping(AYNetworkingFinally)) -> Void {
        
        //准备参数
        let allParams = NSMutableDictionary.init()
        if parameters != nil {
            allParams.addEntries(from: parameters!)
        }
        allParams.addEntries(from: deviceInfo())
        
        //创建URL,URLRequest
        var urlString = path
        if httpMethod.uppercased() == "GET" {
            if allParams.count > 0 {
                var pStr = ""
                for (key, value) in allParams {
                    pStr.append("\(key)=\(value)&")
                }
                pStr.removeLast()
                if urlString.contains("?") {
                    urlString.append("&")
                }else{
                    urlString.append("?")
                }
                urlString.append(pStr)
            }
        }
        if urlStringNeedEncoding {
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
        var url = URL(string: urlString)
        //        let ip = HttpDnsService.sharedInstance().getIpByHostAsync(inURLFormat: url!.host)
        //        if ip != nil {
        //            print("Get IP from HTTPDNS Successfully!")
        //            urlString = urlString.replacingOccurrences(of: url!.host!, with: ip!)
        //        }
        url = URL(string: urlString.replacingOccurrences(of: "+", with: "%2B"))
        print("--\(url!)请求开始--")
        var request = URLRequest.init(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = httpMethod // == httpMethod.uppercased()
        //        self.request = request
        if httpMethod.uppercased() != "GET" {
            //request.httpBody = aAYignature.paramsString.data(using: .utf8)
            //request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            if allParams.count > 0 {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                if let noKey = allParams["noKey"] {
                    let data = try? JSON.init(noKey).rawData()
                    request.httpBody = data
                } else {
                    let data = try? JSON.init(allParams).rawData()
                    request.httpBody = data
                }
            }
        }
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        //httHeader
        for (key, value) in AYNetworking.getHttpHeader(urlString: urlString) {
            request.addValue(value, forHTTPHeaderField: key)
        }
        for (key, value) in (httpHeader ?? [:]) {
            request.setValue(value, forHTTPHeaderField: key)
        }
        //        if ip != nil {
        //            request.addValue(url!.host!, forHTTPHeaderField: "host")
        //        }
        
        //创建URLSession,URLSessionTask,发起网络请求
        //        let session = URLSession.shared
        let session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let identifier = vcIdentifier.getSelfIdentifier()
        var newTask: AYTask?
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                if error!.localizedDescription.lowercased().contains("已取消") || error!.localizedDescription.lowercased().contains("cancel") {
                    return
                }
            }
            var aAYNetworkingError = AYNetworkingError.init(errorCode: nil)
            if let data = data {
                let aJSON = (try? JSON.init(data: data)) ?? JSON()
                if aJSON.object is NSNull {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {//json解析失败，视为请求失败
                        aAYNetworkingError.errorCode = AYNetworkingError.Code.dataFormatError
                        aAYNetworkingError.descriptionString = "服务器繁忙，请稍后再试！".localized()
                    }else{
                        aAYNetworkingError.errorCode = AYNetworkingError.Code.networkFailed
                        let reach = Reachability.init()
                        let isExistenceNetwork = (reach == nil) ? false : (reach!).connection != .none
                        if isExistenceNetwork {//有网络
                            aAYNetworkingError.descriptionString = "网络不给力，请稍后再试！".localized()
                        }else{//没有网络
                            aAYNetworkingError.descriptionString = "当前没有网络连接，请连接网络后重试！".localized()
                        }
                    }
                } else {//视为请求成功
                    //请求成功的情况下有1种请求也视为失败：1、业务请求返回false
                    var codeInt = aJSON[kResponseCode].int
                    if codeInt == nil {
                        codeInt = aJSON["status"].int ?? -19900802
                    }
                    let code = AYNetworkCode.init(rawValue: codeInt!)
                    if code.rawValue == AYNetworkCode.success {//成功code
                        print("\(url!) 请求成功")
                        success(aJSON[kResponseData], nil)
                        finally(nil)
                        return
                    } else {
                        //状态码不是AYNetworkCode.success的情况有很多种
                        aAYNetworkingError.errorCode = AYNetworkingError.Code.bussinessResultFalse
                        aAYNetworkingError.bussinessErrorCodeString = "\(code.rawValue)"
                        aAYNetworkingError.bussinessErrorMessage = aJSON[kResponseMessage].string ?? code.message()
                        if code.rawValue == AYNetworkCode.expiredToken || code.rawValue == AYNetworkCode.invalidToken {//登录token失效的code和
                            AYNetworking.specialOption(code: "\(code.rawValue)")
                        }
                    }
                }
            } else {//返回数据为空视为请求失败
                aAYNetworkingError.errorCode = AYNetworkingError.Code.bussinessResultNull
                aAYNetworkingError.descriptionString = "服务器繁忙，请稍后再试！".localized()
            }
            if AppDelegate.reachability.connection == .none {
//                DispatchQueue.main.async(execute: {
//                    let _ = AppDelegate.checkNetworAndShowAlert(AppDelegate.shared().window!.rootViewController!)
//                })
                aAYNetworkingError.errorCode = AYNetworkingError.Code.networkFailed
                aAYNetworkingError.descriptionString = "网络不可用,请确认网络连接".localized()
            }
            if aAYNetworkingError.errorCode != nil {
                print("\(url!) 请求失败")
                aAYNetworkingError.requestContext["path"]              = path
                aAYNetworkingError.requestContext["parameters"]        = parameters
                aAYNetworkingError.requestContext["httpMethod"]        = httpMethod
                aAYNetworkingError.requestContext["requestContext"]    = requestContext
                aAYNetworkingError.requestContext["success"]           = success
                aAYNetworkingError.requestContext["failure"]           = failure
                aAYNetworkingError.requestContext["finally"]           = finally
                aAYNetworkingError.requestContext["vcIdentifier"]      = identifier
                aAYNetworkingError.requestContext["urlStringNeedEncoding"]      = urlStringNeedEncoding
                failure(aAYNetworkingError, nil)
            }
            print("\(url!) 请求结束")
            finally(nil)
            AYNetworkingManager.manager.runningRequestCount_S -= 1
            if let index = AYNetworkingManager.manager.taskArray.firstIndex(where: { (aAYTask) -> Bool in
                return aAYTask === newTask
            }) {
                AYNetworkingManager.manager.taskArray.remove(at: index)
            }
        })
        newTask = AYTask.init(task: dataTask, identifier: identifier)
        AYNetworkingManager.manager.taskArray.append(newTask!)
        task = newTask
        
        dataTask.resume()
        AYNetworkingManager.manager.runningRequestCount_S += 1
        
        //        AYNetworking.updateAccessToken()
    }
    
    
    // MARK:- get请求
    func get(path: String, parameters: Dictionary<String, Any>? = nil, urlStringNeedEncoding: Bool = true, vcIdentifier: AYNetworkingVProtocol, requestContext: Dictionary<String, Any>? = nil, httpHeader: Dictionary<String,String>? = nil, success: @escaping (AYNetworkingSuccess),failure: @escaping (AYNetworkingFailure), finally: @escaping(AYNetworkingFinally)) -> Void {
        self.startNetworking(path: path, parameters: parameters, urlStringNeedEncoding: urlStringNeedEncoding, httpHeader: httpHeader, vcIdentifier: vcIdentifier, httpMethod: "GET", requestContext: requestContext, success: success, failure: failure, finally: finally)
    }
    
    // MARK:- POST表单请求
    func post(path: String, parameters: Dictionary<String,Any>? = nil, httpHeader: Dictionary<String,String>? = nil, vcIdentifier: AYNetworkingVProtocol, requestContext: Dictionary<String, Any>? = nil, success: @escaping (AYNetworkingSuccess), failure: @escaping (AYNetworkingFailure), finally: @escaping(AYNetworkingFinally)) {
        self.startNetworking(path: path, parameters: parameters, urlStringNeedEncoding: true, httpHeader: httpHeader, vcIdentifier: vcIdentifier, httpMethod: "POST", requestContext: requestContext, success: success, failure: failure, finally: finally)
    }
    
    // MARK:- PUT表单请求
    func put(path: String, parameters: Dictionary<String,Any>? = nil, vcIdentifier: AYNetworkingVProtocol, requestContext: Dictionary<String, Any>? = nil, success: @escaping (AYNetworkingSuccess), failure: @escaping (AYNetworkingFailure), finally: @escaping(AYNetworkingFinally)) {
        self.startNetworking(path: path, parameters: parameters, urlStringNeedEncoding: true, vcIdentifier: vcIdentifier, httpMethod: "PUT", requestContext: requestContext, success: success, failure: failure, finally: finally)
    }
    
    // MARK:- DELETE表单请求
    func delete(path: String, parameters: Dictionary<String,Any>? = nil, vcIdentifier: AYNetworkingVProtocol, requestContext: Dictionary<String, Any>? = nil, success: @escaping (AYNetworkingSuccess), failure: @escaping (AYNetworkingFailure), finally: @escaping(AYNetworkingFinally)) {
        self.startNetworking(path: path, parameters: parameters, urlStringNeedEncoding: true, vcIdentifier: vcIdentifier, httpMethod: "DELETE", requestContext: requestContext, success: success, failure: failure, finally: finally)
    }
    
//    func request(beUrl: BEURL, parameters: Dictionary<String,Any>? = nil, httpHeader: Dictionary<String,String>? = nil, vcIdentifier: AYNetworkingVProtocol, requestContext: Dictionary<String, Any>? = nil, success: @escaping (AYNetworkingSuccess), failure: @escaping (AYNetworkingFailure), finally: @escaping(AYNetworkingFinally)) {
//        self.startNetworking(path: beUrl.path, parameters: parameters, httpHeader: httpHeader, vcIdentifier: vcIdentifier, httpMethod: beUrl.method.rawValue, requestContext: requestContext, success: success, failure: failure, finally: finally)
//    }
    
    /// 上传文件（支持多文件）
    ///upload file (support mul file)
    ///
    /// - Parameters:
    ///   - url: URL
    ///   - datas: elem：（parameterName, fileName, mimeType, data）, fileName should contain extension name
    ///   - params: params. elem is string or number type
    ///   - originalSuccess: success callback（original data）
    ///   - originalFailure: failure callback（original data）
    ///   - success: success callback
    ///   - failure: failure callback
    static func uploadData(url: URL, datas: [(String, String, String, Data)], params: [String:Any]? = nil, httpHeader: [String:String]? = nil, success: AYNetworkingSuccess? = nil, failure: AYNetworkingFailure? = nil, finally: AYNetworkingFinally? = nil, originalSuccess: ((_ data: Data?) -> Void)? = nil, originalFailure: ((_ error: Error?) -> Void)? = nil) {
        var request = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = "POST"
        //httHeader
        for (key, value) in AYNetworking.getHttpHeader(urlString: url.absoluteString) {
            request.addValue(value, forHTTPHeaderField: key)
        }
        for (key, value) in (httpHeader ?? [:]) {
            request.setValue(value, forHTTPHeaderField: key)
        }
        let boundary = AYBoundaryHelper.randomBoundary()
        request.addValue("multipart/form-data; charset=utf-8; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var mData = Data.init()
        let boundaryStart = "--\(boundary)\r\n"
        let pas = params ?? [:]
        var str = ""
        pas.forEach { (key: String, value: Any) in
            str.append(boundaryStart)
            str.append("Content-Disposition: form-data; name=\"\(key)\"")
            str.append("\r\n\r\n")
            str.append("\(value)")
            str.append("\r\n")
        }
        mData.append(str.data(using: String.Encoding.utf8)!)
        
        datas.forEach { (parameterName, fileName, mimeType, data) in
            var tStr = "\r\n\r\n" + boundaryStart
            tStr.append("Content-Disposition: form-data; name=\"\(parameterName)\"; filename=\"\(fileName)\"")
            tStr.append("\r\n")
            tStr.append("Content-Type: \(mimeType)\r\n\r\n")
            mData.append(tStr.data(using: String.Encoding.utf8)!)
            mData.append(data)
        }
        
        mData.append("\r\n--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        let session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        let uploadTask = session.uploadTask(with: request, from: mData) {
            (data, response, error) -> Void in
            //上传完毕后
            /*不封装回调*/
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                originalSuccess?(data)
            }else{
                originalFailure?(error)
            }
            /*封装后回调*/
            if error != nil {
                if error!.localizedDescription.lowercased().contains("已取消") || error!.localizedDescription.lowercased().contains("cancel") {
                    return
                }
            }
            var aAYNetworkingError = AYNetworkingError.init(errorCode: nil)
            if let data = data {
                let aJSON = (try? JSON.init(data: data)) ?? JSON()
                if aJSON.object is NSNull {
                    if let httpRespond = response as? HTTPURLResponse, httpRespond.statusCode == 200 {//json解析失败，视为请求失败
                        aAYNetworkingError.errorCode = AYNetworkingError.Code.dataFormatError
                        aAYNetworkingError.descriptionString = "服务器繁忙，请稍后再试！".localized()
                    }else{
                        aAYNetworkingError.errorCode = AYNetworkingError.Code.networkFailed
                        let reach = Reachability.init()
                        let isExistenceNetwork = (reach == nil) ? false : (reach!).connection != .none
                        if isExistenceNetwork {//有网络
                            aAYNetworkingError.descriptionString = "网络不给力，请稍后再试！".localized()
                        }else{//没有网络
                            aAYNetworkingError.descriptionString = "当前没有网络连接，请连接网络后重试！".localized()
                        }
                    }
                }else{//视为请求成功
                    //请求成功的情况下有1种请求也视为失败：1、业务请求返回false
                    var codeInt = aJSON[kResponseCode].int
                    if codeInt == nil {
                        codeInt = aJSON["status"].int ?? -19900802
                    }
                    let code = AYNetworkCode.init(rawValue: codeInt!)
                    if code.rawValue == AYNetworkCode.success {//成功code
                        //                        if (aJSON[kResponseData].dictionary) != nil {//成功
                        print("\(url) 请求成功")
                        success?(aJSON[kResponseData], nil)
                        //                        }else{//返回后的body为空,视为失败
                        //                            aAYNetworkingError.errorCode = AYNetworkingError.Code.bussinessResultFalse
                        //                            aAYNetworkingError.descriptionString = "服务器繁忙，请稍后再试！"
                        //                        }
                        finally?(nil)
                        return
                    }else{
                        //状态码不是AYNetworkCode.success的情况有很多种
                        aAYNetworkingError.errorCode = AYNetworkingError.Code.bussinessResultFalse
                        aAYNetworkingError.bussinessErrorCodeString = "\(code.rawValue)"
                        aAYNetworkingError.bussinessErrorMessage = aJSON[kResponseMessage].string ?? code.message()
                        if code.rawValue == AYNetworkCode.expiredToken {//登录token失效的code
                            AYNetworking.specialOption(code: "\(code.rawValue)")
                        }
                    }
                }
            }else {//返回数据为空视为请求失败
                aAYNetworkingError.errorCode = AYNetworkingError.Code.bussinessResultNull
                aAYNetworkingError.descriptionString = "服务器繁忙，请稍后再试！".localized()
            }
            if AppDelegate.reachability.connection == .none {
//                DispatchQueue.main.async(execute: {
//                    let _ = AppDelegate.checkNetworAndShowAlert(AppDelegate.shared().window!.rootViewController!)
//                })
                aAYNetworkingError.errorCode = AYNetworkingError.Code.networkFailed
                aAYNetworkingError.descriptionString = "网络不可用,请确认网络连接".localized()
            }
            if aAYNetworkingError.errorCode != nil {
                print("\(url) 请求失败")
                aAYNetworkingError.requestContext["url"]               = url
                //aAYNetworkingError.requestContext["path"]              = path
                aAYNetworkingError.requestContext["parameters"]        = params
                aAYNetworkingError.requestContext["httpMethod"]        = "Post"
                //aAYNetworkingError.requestContext["requestContext"]    = requestContext
                aAYNetworkingError.requestContext["success"]           = success
                aAYNetworkingError.requestContext["failure"]           = failure
                aAYNetworkingError.requestContext["finally"]           = finally
                //aAYNetworkingError.requestContext["vcIdentifier"]      = identifier
                failure?(aAYNetworkingError, nil)
            }
            print("\(url) 请求结束")
            finally?(nil)
        }
        uploadTask.resume()
    }
    
    func reStartNetworking(error: AYNetworkingError) -> Void {
        print("reStartNetworking")
        let path            = error.requestContext["path"]              as! String
        let parameters      = error.requestContext["parameters"]        as? Dictionary<String,Any>
        let httpMethod      = error.requestContext["httpMethod"]        as! String
        let requestContext  = error.requestContext["requestContext"]    as? Dictionary<String, Any>
        let success         = error.requestContext["success"]           as! AYNetworkingSuccess
        let failure         = error.requestContext["failure"]           as! AYNetworkingFailure
        let finally         = error.requestContext["finally"]           as! AYNetworkingFinally
        let vcIdentifier    = error.requestContext["vcIdentifier"]      as! String
        let urlStringNeedEncoding   = error.requestContext["urlStringNeedEncoding"] as! Bool
        self.startNetworking(path: path, parameters: parameters, urlStringNeedEncoding: urlStringNeedEncoding, vcIdentifier: vcIdentifier, httpMethod: httpMethod, requestContext: requestContext, success: success, failure: failure, finally: finally)
    }
}

extension AYNetworking {
    static func updateAccessToken() {
//        if (AYAuthor.shared.isLogin ?? false) == true, AYAuthor.shared.token != nil {
//            var needUpdateToken: Bool
//            if AYAuthor.shared.lastLoginTime == nil {
//                needUpdateToken = true
//            }else{
//                let lastLoginTime = AYAuthor.shared.lastLoginTime!
//                let expire = AYAuthor.shared.expire ?? 0
//                let timeNow = Int64(Date.init().timeIntervalSince1970)
//                let t = lastLoginTime + expire
//
//                if timeNow > (t - 120), timeNow < t {
//                    needUpdateToken = true
//                }else{
//                    needUpdateToken = false
//                }
//            }
//            if needUpdateToken {
//                AYNetworking.tokenWillExpire()
//            }
//        }
    }
    fileprivate static func specialOption(code: String) -> Void {
        //特殊code处理(发送通知)
        let notification = Notification.init(name: Notification.Name.specialNetworkingStatusCode, object: nil, userInfo: ["statusCode": code])
        NotificationCenter.default.performSelector(onMainThread: #selector(NotificationCenter.post(_:)), with: notification, waitUntilDone: true)
    }
    
    fileprivate static func tokenWillExpire() {
        let notification = Notification.init(name: Notification.Name.tokenWillExpire, object: nil, userInfo: nil)
        NotificationCenter.default.performSelector(onMainThread: #selector(NotificationCenter.post(_:)), with: notification, waitUntilDone: true)
    }
}


//////////////////////
protocol AYNetworkingVProtocol {
    func getSelfIdentifier() -> String
}
extension String: AYNetworkingVProtocol {
    func getSelfIdentifier() -> String {
        return self
    }
}

class AYTask {
    let task: URLSessionTask
    let identifier:String
    
    init(task: URLSessionTask, identifier: String) {
        self.task = task
        self.identifier = identifier
    }
    
}
class AYNetworkingManager {
    //单例
    static let manager = AYNetworkingManager()
    
    var runningRequestCount_S = 0 /*{
     didSet{
     DispatchQueue.main.async(execute: {
     UIApplication.shared.isNetworkActivityIndicatorVisible = (self.runningRequestCount_S > 0)
     })
     }
     }*/
    
    var taskArray = [AYTask]()
    
    func cancelTask(identifier: String) -> Void {
        for task in taskArray {
            if task.identifier == identifier {
                task.task.cancel()
                if let index = taskArray.firstIndex(where: { (aAYTask) -> Bool in
                    return aAYTask === task
                }) {
                    taskArray.remove(at: index)
                }
                runningRequestCount_S -= 1
            }
        }
    }
}

//extension AYNetworking:URLSessionDelegate {
//
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        print("didReceive challenge")
//        if challenge.protectionSpace.authenticationMethod
//            == (NSURLAuthenticationMethodServerTrust) {
//            print("服务端证书认证！")
//
//            let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
//            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
//
//            let credential = URLCredential(trust: serverTrust)
//            challenge.sender!.continueWithoutCredential(for: challenge)
//            challenge.sender?.use(credential, for: challenge)
//            completionHandler(URLSession.AuthChallengeDisposition.useCredential,
//                              URLCredential(trust: challenge.protectionSpace.serverTrust!))
//
//        }
//
////        var disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
////        var credential: URLCredential?
////        /*
////         * 获取原始域名信息。
////         */
////
////        var host = self.request?.allHTTPHeaderFields?["host"]
////        if (host == nil) {
////            host = self.request?.url?.host
////        }
////        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
////            if challenge.protectionSpace.serverTrust != nil, self.evaluateServerTrust(serverTrust: challenge.protectionSpace.serverTrust!, forDomain: host) {
////                disposition = URLSession.AuthChallengeDisposition.useCredential
////                credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
////            } else {
////                disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
////            }
////        } else {
////            disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
////        }
////        // 对于其他的challenges直接使用默认的验证方案
////        completionHandler(disposition,credential)
//    }
//
//}

extension AYNetworking {
    func evaluateServerTrust(serverTrust: SecTrust, forDomain domain: String?) -> Bool {
        /*
         * 创建证书校验策略
         */
        var policies: [SecPolicy] = []
        if domain != nil {
            policies.append(SecPolicyCreateSSL(true, domain! as CFString))
        } else {
            policies.append(SecPolicyCreateBasicX509())
        }
        /*
         * 绑定校验策略到服务端的证书上
         */
        SecTrustSetPolicies(serverTrust, policies as CFTypeRef)
        /*
         * 评估当前serverTrust是否可信任，
         * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
         * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
         * 关于SecTrustResultType的详细信息请参考SecTrust.h
         */
        var result: SecTrustResultType = .invalid
        SecTrustEvaluate(serverTrust, &result)
        
        if (result == SecTrustResultType.recoverableTrustFailure) {
            let errDataRef = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, errDataRef)
            SecTrustEvaluate(serverTrust, &result)
        }
        return (result == SecTrustResultType.unspecified || result == SecTrustResultType.proceed)
    }
}
extension AYNetworking: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        var credential: URLCredential?
        /*
         * 获取原始域名信息。
         */
        
        var host = task.currentRequest?.allHTTPHeaderFields?["host"]
        if (host == nil) {
            host = task.currentRequest?.allHTTPHeaderFields?["Host"]
            if (host == nil) {
                host = task.currentRequest?.url?.host
            }
        }
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.protectionSpace.serverTrust != nil, self.evaluateServerTrust(serverTrust: challenge.protectionSpace.serverTrust!, forDomain: host) {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            } else {
                disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
            }
        } else {
            disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        }
        // 对于其他的challenges直接使用默认的验证方案
        completionHandler(disposition,credential)
    }
}


