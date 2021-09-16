//
//  LEADMODEL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 19/12/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation

public class LEADMODEL{

    var uid: String!
    var firstname : String!
    var lastname : String!
    var  mobilephone : String!
    var telephone1 : String!
    var emailaddress1 : String!
    var companyname : String!
    var address1_line1 : String!
    var address1_city : String!
    var address1_stateorprovince : String!
    var  address1_postalcode : String!
    var revenue: Int!
    var numberofemployees: Int!
    var Jobtitle : String!
    var  ABN : String!
    var sourceinfo : String!
    var  contactmethod: String!
    var  topic : String!
        
    init (uid  : String ,firstname  : String ,lastname  : String , mobilephone  : String ,telephone1  : String ,emailaddress1  : String ,companyname  : String ,address1_line1  : String ,address1_city  : String ,address1_stateorprovince  : String , address1_postalcode  : String ,revenue : Int ,numberofemployees : Int ,Jobtitle  : String , ABN  : String ,sourceinfo  : String , contactmethod : String , topic: String){
        
        self.uid = uid
        self.firstname = firstname
        self.lastname = lastname
        self.mobilephone = mobilephone
        self.telephone1 = telephone1
        self.emailaddress1 = emailaddress1
        self.companyname = companyname
        self.address1_line1 = address1_line1
        self.address1_city = address1_city
        self.address1_stateorprovince = address1_stateorprovince
        self.address1_postalcode = address1_postalcode
        self.revenue = revenue
        self.numberofemployees = numberofemployees
        self.Jobtitle = Jobtitle
        self.ABN = ABN
        self.sourceinfo = sourceinfo
        self.contactmethod = contactmethod
        self.topic = topic
    }
    
}


public class NOTEMODEL {
    
    var leadid: String!
    var subject: String!
    var note: String!
    var fname: String!
    var lname: String!
    
    init(leadid: String,subject: String,note: String,fname: String,lname: String){
        self.leadid = leadid
        self.note = note
        self.subject = subject
        self.fname = fname
        self.lname = lname
    }
}
