//
//  CONSTANT.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 18/07/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation

public class CONSTANT {
    
    //    MARK:- OLD URLS
//        public static var RESOURCE = "https://ccaauauesdevrsg002c64eeededf151cffdevaos.cloudax.dynamics.com"  // NF dev
//        public static var LOGIN_RESOURCE = "https://ccaauauesdevrsg002c64eeededf151cffdevaos.cloudax.dynamics.com"
//
//        public static var RESOURCE = "https://neverfail.sandbox.operations.dynamics.com"  // NF sandbox
//        public static var LOGIN_RESOURCE = "https://neverfail.sandbox.operations.dynamics.com"
    
    //    MARK:- NEW URLS
    
    public static var RESOURCE = "https://apimdev.ccamatil.com/p/neverfail"  // NF dev
    public static var RESOURCE_CRM = "https://neverfaildev.crm6.dynamics.com"  // NF dev1
    public static var LOGIN_RESOURCE = "https://ccaauauesdevrsg002c64eeededf151cffdevaos.cloudax.dynamics.com"
    public static var BASE_URL_FnO = "https://apimdev.ccamatil.com/p/neverfail/"    // DEV 1
    public static var BASE_URL_CRM = "https://apimdev.ccamatil.com/p/neverfailcrm/"      // DEV 1
    
//    public static var RESOURCE = "https://apimtst.ccamatil.com/p/neverfail"  // NF sandbox 1
//    public static var RESOURCE_CRM = "https://neverfailsandbox.crm6.dynamics.com"  // NF uat 1
//    public static var LOGIN_RESOURCE = "https://neverfail.sandbox.operations.dynamics.com"
//    public static var BASE_URL_FnO = "https://apimtst.ccamatil.com/p/neverfail/"     // UAT 1
//    public static var BASE_URL_CRM = "https://apimtst.ccamatil.com/p/neverfailcrm/"  // UAT 1
    
//    public static var RESOURCE = "https://apimtst.ccamatil.com/p/neverfail2"  // NF sandbox 2
//    public static var RESOURCE_CRM = "https://neverfailsandbox2.crm6.dynamics.com"  // NF uat2
//    public static var LOGIN_RESOURCE = "https://neverfail2.sandbox.operations.dynamics.com"
//    public static var BASE_URL_FnO = "https://apimtst.ccamatil.com/p/neverfail2/"     // UAT 2
//    public static var BASE_URL_CRM = "https://apimtst.ccamatil.com/p/neverfailcrm2/"       // UAT 2
    
//    MARK:- PROD URLS
//    public static var RESOURCE = "https://apim.ccamatil.com/p/neverfail"
//    public static var RESOURCE_CRM = "https://nvf.crm6.dynamics.com"
//    public static var LOGIN_RESOURCE = "https://nvf.operations.dynamics.com"
//    public static var BASE_URL_FnO = "https://apim.ccamatil.com/p/neverfail/"
//    public static var BASE_URL_CRM = "https://apim.ccamatil.com/p/neverfailcrm/"
    
    public static var IS_TOKEN_REQ : Bool! = true
    
    public static var BASE_URL_1 = CONSTANT.RESOURCE + "/api/services/"
    
    public static var BASE_URL = ""

    public static var TENANT = "31f6eb2e-90b9-4668-9645-fec7390e62c6"
    
    public static var CL_ID = "e75ddb21-e309-4e39-b974-fdb912de4643"
    
    public static var CL_SC = "a61K2ue~p.zTFaV4Y___h7FsDb1Gp84ob2"
    
    public static var URL = "https://login.microsoftonline.com/\(CONSTANT.TENANT)/oauth2/token"
    
    public static var notename: [String] = []
    public static var leadname: [String] = []
    public static var custname: [String] = []
    public static var mastername: [String] = []
    public static var msg = ""
    
    public static var failapi = 0
    public static var apicall = 4
    
    public static var IS_DEBUG = false
    
    public static func gettexttime(text: String)-> Double{
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let components = text.components(separatedBy: chararacterSet)
        let words = components.filter { !$0.isEmpty }
        var time = 1.5
        if words.count > 0 {
            time = Double(words.count) * 0.3   // 0.25 - supposing reading speed is 240 words/min
        }else{
            time = 1.5
        }
        if (time < 1.5){
            time  = 1.5
        }
        print("time to read \(words.count) words ===> \(time)")
        return time
    }
    
}
