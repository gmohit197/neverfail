//
//  NEWCUSTMODEL.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 18/12/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import Foundation

public class NEWCUSTMODEL {
    
    var salutation: String!
    var custtype: Int!
    var fname : String!
    var lname : String!
    var deladdr : String!
    var delsuburb : String!
    var  delstate : String!
    var delpostcode : String!
    var mailaddr : String!
    var mailsuburb : String!
    var  mailstate : String!
    var mailpostcode : Int!
    var abn : String!
    var segment : String!
    var confname : String!
    var conlname : String!
    var conphone : String!
    var conemail : String!
    var acfname : String!
    var aclname : String!
    var acemail : String!
    var acphone: String!
    var tname: String!
    var temail: String!
    var sign : String!
    var uid: String!
    
    var country: String!
    var lati: Double!
    var longi: Double!
    var mailcountry: String!
    var maillati: Double!
    var maillongi: Double!

    var subsegment: String!
    var lob: String!
    var notes: String!
    
    init (salutation : String, custtype : Int, fname : String, lname : String, deladdr : String, delsuburb : String,  delstate : String, delpostcode : String, mailaddr : String, mailsuburb : String,  mailstate : String, mailpostcode : Int, abn : String, segment : String, confname : String, conlname : String, conphone : String, conemail : String, acfname : String, aclname : String, acemail : String, acphone: String, tname: String, temail: String, sign : String,uid: String, country: String, lati: Double, longi: Double, mailcountry: String, maillati: Double, maillongi: Double, subsegment: String, lob: String, notes: String){
        
        self.abn = abn
        self.acemail = acemail
        self.acfname = acfname
        self.aclname = aclname
        self.acphone = acphone
        self.conemail = conemail
        self.confname = confname
        self.conlname = conlname
        self.conphone = conphone
        self.custtype = custtype
        self.deladdr = deladdr
        self.delpostcode = delpostcode
        self.delstate = delstate
        self.delsuburb = delsuburb
        self.fname = fname
        self.lname = lname
        self.mailaddr = mailaddr
        self.mailpostcode = mailpostcode
        self.mailstate = mailstate
        self.mailsuburb = mailsuburb
        self.salutation = salutation
        self.segment = segment
        self.sign = sign
        self.temail = temail
        self.tname = tname
        self.uid = uid
        self.country = country
        self.lati = lati
        self.longi = longi
        self.maillongi = maillongi
        self.mailcountry = mailcountry
        self.maillati = maillati
        self.subsegment = subsegment
        self.lob = lob
        self.notes = notes
    }
    
}

