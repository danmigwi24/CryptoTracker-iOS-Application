//
//  AppConfig.swift
//  iOSTemplateApp
//
//  Created by Daniel Kimani on 26/04/2025.
//  Copyright © 2020 dnd Int. All rights reserved.
//

import Foundation

//
public class AppConfig:NSObject{
    
    public static let PINMaskingKey = "*"
    public static let TOUCH_ID_MASK = "----"
    
    fileprivate static var _config: ConfigInfo?
    
    
    public static var Current:ConfigInfo?{
        get {
            if _config == nil {
                //Init...
                let _ = AppConfig()
            }
            
            return _config
        }
        set{
            //
            if let g = newValue {
                //Only Crypto Config can be changed
                _config = g
            }
        }
    }
    
    override init(){
        super.init()
        //
        do {
            //
            if let url = Bundle.main.url(forResource: "configInfo", withExtension: "plist") {
                //
                let data = try Data(contentsOf: url)
                //
                var config = try PropertyListDecoder().decode(ConfigInfo.self, from: data)
                
                //
                if let IsDevt =  config.Environment?.IsDevt {
                    //
                    config.enableLogs = true
                    print("Environment :: \(IsDevt ? "DEV" : "UAT")")
                }
                AppConfig._config = config
                
                
                AppConfig._config = config
            }
        }catch{
            AppConfig._config = nil
            print(error)
            print("Load Config Error :: \(error)")
        }
        //
    }
}

//
public struct ConfigInfo : Decodable {
    private var listofEnvironments : [AppEnvironment]
    public var enableLogs:Bool
    // MARK: Computed field
    public var Environment:AppEnvironment?{
        get{
            //Get the environment marked as active
            return listofEnvironments.first(where: { (e) -> Bool in
                if e.active {
                    //print("\n\n********************** \(e.type) API \(e.baseApiUrl)********************** \n\n")
                }
                //
                return e.active
            })
        }
    }
    
    enum CodingKeys : String, CodingKey {
        case listofEnvironments = "environments"
        case enableLogs = "enableLogs"
    }
}


public struct AppEnvironment:Decodable {
    public var type:String
    public var name:String
    public var active:Bool
    public var baseApiUrl:String
    public var apiKey:String
    public var earlyRelease:Bool
    
    // Mark: Computed value
    public var IsDevt :Bool {
        get{
            return type.lowercased() == "DEV".lowercased()
        }
    }
    
    public var IsUat :Bool {
        get{
            return type.lowercased() == "UAT".lowercased()
        }
    }
    
    public var IsProd :Bool {
        get{
            return type.lowercased() == "PROD".lowercased()
        }
    }
    // Mark: Computed value
    public var IsEarlyTest:Bool{
        get{
            //print("\n******************************************* earlyRelease \(earlyRelease) ******************************************* \n")
            //return !IsDevt && earlyRelease
            return earlyRelease
        }
    }
    
    enum CodingKeys:String,CodingKey{
        case type
        case name
        case apiKey = "apiKey"
        case active
        case earlyRelease = "early-build"
        case baseApiUrl = "base-path"
    }
}





public func prettyPrintedJSONString(from jsonString: String) -> String {
       // Convert the JSON string into a Data object
       guard let data = jsonString.data(using: .utf8) else {
           return jsonString
       }

       // Convert the Data object into a JSON object
       guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
             let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
           return jsonString
       }

       // Convert the pretty-printed Data object back into a String
    return String(data: prettyPrintedData, encoding: .utf8) ?? jsonString
   }

