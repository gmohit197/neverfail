//
//  Databaseconnection.swift
//  Ripple CSR
//
//  Created by Acxiom Consulting on 08/06/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3

public class Databaseconnection: UIViewController {
    public static var dbs: OpaquePointer?
    
    public static func createdatabase (){
        
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("NeverFailDB.sqlite")
        
        if sqlite3_open(fileUrl.path, &Databaseconnection.dbs) != SQLITE_OK{
            print("Error in opening Database")
            return
        }
        print("database created")
        print("path======> (\(fileUrl))")
        
        
        let CREATE_TABLE_Prestartchecklist = "CREATE TABLE IF NOT EXISTS PreStartChecklist(uid text,userid text, description text, information text, toogle text, remarks text, date text,odometer text, post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_Prestartchecklist, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Compliance")
            return
        }
        
        let CREATE_TABLE_Compliance = "CREATE TABLE IF NOT EXISTS Compliance(uid text,userid text, description text, information text, toogle text, starttime text,remarks text, date text, post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_Compliance, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Compliance")
            return
        }
        
        let CREATE_TABLE_custorderheader = "CREATE TABLE IF NOT EXISTS CustorderHeader(s_id INTEGER PRIMARY KEY AUTOINCREMENT,custid text,userid text, custname text, custcity text, custstreet text, custstate text, custemail text, custphone text, lati text,longi text,delnote text,ordernote text,custtaxgrp text,custchgrp text,custmod text,custmodgrp text, custpricegrp text, custdisgrp text, custordernum text,custordrchcode text,custorderchval text, custorderchtax text,date text,nextdeldate text , deltype text ,status text,lastactivityid text,pono text,shipdate text,acceptedby text, pomandate text,post text, callday3 text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_custorderheader, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - CustorderHeader")
            return
        }
        let CREATE_TABLE_custorderline = "CREATE TABLE IF NOT EXISTS CustorderLine(lotid text,custordernum text,itemnum text, itemname text,qty text,price text, priceunit text,itemdisper text, itemdisamt text, itemdis text, itemtaxgrp text, itembatch text, totval text,cathitem text,revsch text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_custorderline, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - CustorderLine")
            return
        }
        
        let CREATE_TABLE_custitemtax = "CREATE TABLE IF NOT EXISTS CustItemTax(lotid text,itemtaxgrp text,percent text, taxamt text, taxcode text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_custitemtax, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - CustItemTax")
            return
        }
        let CREATE_TABLE_custitemcharge = "CREATE TABLE IF NOT EXISTS CustItemCharge(lotid text,chamt text,chcode text, chtype text, chval text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_custitemcharge, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - CustItemTax")
            return
        }
        
        let CREATE_TABLE_stockTr = "CREATE TABLE IF NOT EXISTS StockTransfer(trkid text, itemid text, qty text, date text, uid text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_stockTr, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - StockTransfer")
            return
        }
        
        let CREATE_TABLE_caseentry = "CREATE TABLE IF NOT EXISTS CaseEntry(custid text,userid text, caseid text, type text, title text, descp text, status text, date text,contid text,state text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_caseentry, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - CaseEntry")
            return
        }
        
        let CREATE_TABLE_casetype = "CREATE TABLE IF NOT EXISTS CaseType(typeid text, type text, parentid text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_casetype, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - CaseType")
            return
        }
        
        let CREATE_TABLE_itemmaster = "CREATE TABLE IF NOT EXISTS Itemmaster(Itemcode text,Itemname text, itemgstgrp text,linedisgrp text ,itemchgrp text ,articletyp text, isbatch text, isserial text,itemimage text,itemtype text,weight text,isservice text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_itemmaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Itemmaster")
            return
        }
        
        let CREATE_TABLE_checkinitems = "CREATE TABLE IF NOT EXISTS Checkinitems(itemid text, itemname text, qty text,datetime text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_checkinitems, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Checkinitems")
            return
        }
        
        let CREATE_TABLE_invoice = "CREATE TABLE IF NOT EXISTS Invoice(custid text,date text,invoiceid text, amount text,status text,isselected text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_invoice, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Invoice")
            return
        }
        let CREATE_TABLE_break = "CREATE TABLE IF NOT EXISTS Break(drid text,date text,brid text, starttime text,endtime text,state text,breaktime text,duration text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_break, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Break")
            return
        }
        let CREATE_TABLE_lead = "CREATE TABLE IF NOT EXISTS Lead(topic text,leadid text,subject text,firstname text,lastname text, mobilephone text,telephone1 text,emailaddress1 text,companyname text,address1_line1 text,address1_city text,address1_stateorprovince text, address1_postalcode text,revenue text,numberofemployees text,Jobtitle text, ABN text,sourceinfo text, note text,contactmethod text,post text,uid text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_lead, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Lead")
            return
        }
        let CREATE_TABLE_newcust = "CREATE TABLE IF NOT EXISTS NewCust(uid text, salutation text,custtype text,fname text,lname text,deladdr text,delsuburb text, delstate text,delpostcode text,del_country text, del_lat text, del_long text,mailaddr text,mailsuburb text, mailstate text,mailpostcode text,mail_country text, mail_lat text, mail_long text, abn text,segment text,confname text,conlname text,conphone text,conemail text,acfname text,aclname text,acemail text,acphone text,tname text,temail text,sign blob,subsegment text,lob text,notes text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_newcust, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - New Cust")
            return
        }
        let CREATE_TABLE_getbreaks = "CREATE TABLE IF NOT EXISTS GetBreak(uid text, period text,maxtime text,restreq text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_getbreaks, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Get Break")
            return
        }
        let CREATE_TABLE_customers = "CREATE TABLE IF NOT EXISTS customers(custid text, name text,status text, seq text,street text,city text,state text,email text,phone text,lat text,long text,mobile text,delnote text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_customers, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - customers")
            return
        }
        
        let CREATE_TABLE_custsrch = "CREATE TABLE IF NOT EXISTS custsrch(id text,custid text, name text,city text,state text,street text, email text,phone text, lati text, longi text, delnote text, pono text, custtaxgrp text, custchgrp text, modeofdel text, custpricegrp text, custdisgrp text,custmodgrp text,pomandate text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_custsrch, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - custsrch")
            return
        }
        
        let CREATE_TABLE_loading = "CREATE TABLE IF NOT EXISTS Loading(id text,itemname text, itemid text,qty text,batch text,serial text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_loading, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Loading")
            return
        }
        
        let CREATE_TABLE_unloading = "CREATE TABLE IF NOT EXISTS Unloading(id  INTEGER PRIMARY KEY AUTOINCREMENT, itemid text,qty text,batch text,serial text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_unloading, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Unloading")
            return
        }
        
        let CREATE_TABLE_taxmaster = "CREATE TABLE IF NOT EXISTS TaxMaster(id text,gstval text, gstcode text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_taxmaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - TaxMaster")
            return
        }
        let CREATE_TABLE_taxgroup = "CREATE TABLE IF NOT EXISTS TaxGroup(id text,salestaxgrp text, gstcode text,itemsalestaxgrp text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_taxgroup, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - TaxGroup")
            return
        }
        let CREATE_TABLE_autocharge = "CREATE TABLE IF NOT EXISTS AutoCharge(id text,accode text, custrelation text,itemcode text,itemrelation text,modc text,modr text,cat text, chcode text, chval text,saletaxgrp text,chvaltyp text, itemtaxgrp text, levelline text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_autocharge, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - AutoCharge")
            return
        }
        
        let CREATE_TABLE_serialmaster = "CREATE TABLE IF NOT EXISTS SerialMaster(id text,invtserial text, itemid text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_serialmaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - SerialMaster")
            return
        }
        let CREATE_TABLE_batchmaster = "CREATE TABLE IF NOT EXISTS BatchMaster(id text,invtbatch text, itemid text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_batchmaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - BatchMaster")
            return
        }
        
        let CREATE_TABLE_pricemaster = "CREATE TABLE IF NOT EXISTS PriceMaster(id text,accode text, acrelation text,itemrelation text,fromdate text,todate text, amt text,priceunit text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_pricemaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - PriceMaster")
            return
        }
        let CREATE_TABLE_discountmaster = "CREATE TABLE IF NOT EXISTS DiscountMaster(id text,accode text, acrelation text, itemcode text,itemrelation text,fromdate text,todate text, fromqty text, toqty text, discount text, disper text, fixamt text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_discountmaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - DiscountMaster")
            return
        }
        
        let CREATE_TABLE_batch = "CREATE TABLE IF NOT EXISTS BatchSerial(lotid text,batch text, qty text,serial text,type text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_batch, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - BatchSerial")
            return
        }
        let CREATE_TABLE_dimdetails = "CREATE TABLE IF NOT EXISTS DimDetails(ordernum text,itemid text,batch text, qty text,serial text,lotid text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_dimdetails, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - BatchSerial")
            return
        }
        
        // RevenueSchedule
        let CREATE_TABLE_revenueschedule = "CREATE TABLE IF NOT EXISTS RevenueSchedule(id text,code text, description text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_revenueschedule, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - RevenueSchedule")
            return
        }
        
        // ReasonMaster
        let CREATE_TABLE_reasonmaster = "CREATE TABLE IF NOT EXISTS ReasonMaster(id text,type text ,skipcode text, description text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_reasonmaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - ReasonMaster")
            return
        }
        
        let CREATE_TABLE_reschedulereason = "CREATE TABLE IF NOT EXISTS RescheduleReason(id text,reasoncode text, description text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_reschedulereason, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - RescheduleReason")
            return
        }
        
        let CREATE_TABLE_nodelreason = "CREATE TABLE IF NOT EXISTS NoDelReason(s_id INTEGER PRIMARY KEY AUTOINCREMENT, ordernum text,reasoncode text, description text, note text, date text, type text, skipcancelname text, state text, post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_nodelreason, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - NoDelReason")
            return
        }
        
        let CREATE_TABLE_images = "CREATE TABLE IF NOT EXISTS Images(ordernum text, image text, type text,date text, activity text,post text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_images, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - Images")
            return
        }
        let CREATE_TABLE_TruckTransferStatus = "CREATE TABLE IF NOT EXISTS TruckTransferStatus(id text, trucktransferid text, status text)"
        if sqlite3_exec(dbs, CREATE_TABLE_TruckTransferStatus, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - TruckTransferStatus")
            return
        }
        
        let CREATE_TABLE_TruckMaster = "CREATE TABLE IF NOT EXISTS TruckMaster(id text, code text, description text, driverid text)"
        if sqlite3_exec(dbs, CREATE_TABLE_TruckMaster, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - TruckMaster")
            return
        }
        
        let CREATE_TABLE_TransferDetails = "CREATE TABLE IF NOT EXISTS TransferDetails(id text, trucktransferid text, fromtruck text, totruck text,status text)"
        if sqlite3_exec(dbs, CREATE_TABLE_TransferDetails, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - TransferDetails")
            return
        }
        
        let CREATE_TABLE_TransferDetails_SkuDetails = "CREATE TABLE IF NOT EXISTS TransferDetailsSku(skuid text, itemid text, inventbatchid text, inventserialid text , itemname text , qty text)"
        if sqlite3_exec(dbs, CREATE_TABLE_TransferDetails_SkuDetails, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - TransferDetailsSku")
            return
        }

        let CREATE_TABLE_Truckstock = "CREATE TABLE IF NOT EXISTS TruckStock(itemid text, isservice text, batch text, serial text , loadqty text , deliveredqty text, returnedqty text, trucktransferreceipt text, trucktransfership text, trucktransferopen text, unload text, netqty text)"
        if sqlite3_exec(dbs, CREATE_TABLE_Truckstock, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - TruckStock")
            return
        }
        
        let CREATE_TABLE_subsegment = "CREATE TABLE IF NOT EXISTS SubSegment(segmentid text, subsegmentid text, descp text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_subsegment, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - SubSegment")
            return
        }
        
        let CREATE_TABLE_LOB = "CREATE TABLE IF NOT EXISTS LineOfBussiness(lobid text, descp text)"
        
        if sqlite3_exec(dbs, CREATE_TABLE_LOB, nil, nil, nil) != SQLITE_OK{
            print("Error creating Table - LOB")
            return
        }
        
    }
    //MARK:- DELETE TABLE
    public func deletetable(tbl: String){
        let query = "delete from \(tbl)"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting \(tbl) Table data")
            return
        }
    }
    public func deleteposttable(tbl: String){
        let query = "delete from \(tbl) where post = '2'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting \(tbl) Table data")
            return
        }
    }
    public func removeorderheader(orderid: String){
        let query = "delete from CustorderHeader where custordernum = '\(orderid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting CustorderHeader Table data")
            return
        }
    }
    public func removeorderline(orderid: String){
        let query = "delete from CustorderLine where custordernum = '\(orderid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting CustorderLine Table data")
            return
        }
    }
    //MARK:- PRECHECK
    public func insertprechecktable(uid: String,userid : String, description : String, information : String, toogle : String){
        
        let query = "Insert into PreStartChecklist (uid ,userid, description, information, toogle, remarks, date, post,odometer) VALUES ('\(uid)','\(userid)','\(description)','\(information)','\(toogle)','','','0','')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in PreStartChecklist Table")
            return
        }
    }
    public func saveodometer(odometer: String){
        let base = BASEACTIVITY()
        let query = "update PreStartChecklist set odometer = '\(odometer)' , date = '\(base.getdate(format: "yyyy-MM-dd hh:mm:ss a"))'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error update PreStartChecklist - odometer value")
            return
        }
    }
    
    public func updatedel(note: String,id: String){
        let query = "update CustorderHeader set delnote = '\(note.replacingOccurrences(of: "'", with: "''"))' where custordernum = '\(id)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in customers Table")
            return
        }
    }
    //    MARK:- NEW CUSTOMER
    public func insertnewcust(uid : String, salutation : String,custtype : String,fname : String,lname : String,deladdr : String,delsuburb : String, delstate : String,delpostcode : String,del_country : String, del_lat : String, del_long : String, mail_country : String, mail_lat : String, mail_long : String,mailaddr : String,mailsuburb : String, mailstate : String,mailpostcode : String,abn : String,segment : String,subsegment: String, lob: String, notes: String){
        
        //    NewCust(uid text, salutation text,custtype text,fname text,lname text,deladdr text,delsuburb text, delstate text,delpostcode text,del_country text, del_lat text, del_long text,mailaddr text,mailsuburb text, mailstate text,mailpostcode text,mail_country text, mail_lat text, mail_long text, abn text,segment text,confname text,conlname text,conphone text,conemail text,acfname text,aclname text,acemail text,acphone text,tname text,temail text,sign blob,subsegment text,lob text,notes text,post text)
        
        var stmt1:OpaquePointer?
        
        var query = "select * from NewCust where uid = '\(uid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            query = "update NewCust set salutation = '\(salutation)' ,custtype = '\(custtype)' ,fname = '\(fname.replacingOccurrences(of: "'", with: "''"))' ,lname = '\(lname.replacingOccurrences(of: "'", with: "''"))' ,deladdr = '\(deladdr.replacingOccurrences(of: "'", with: "''"))' ,delsuburb = '\(delsuburb.replacingOccurrences(of: "'", with: "''"))' , delstate = '\(delstate.replacingOccurrences(of: "'", with: "''"))' ,delpostcode = '\(delpostcode)' , del_country = '\(del_country.replacingOccurrences(of: "'", with: "''"))' , del_lat = '\(del_lat)', del_long = '\(del_long)' ,mailaddr = '\(mailaddr.replacingOccurrences(of: "'", with: "''"))' ,mailsuburb = '\(mailsuburb.replacingOccurrences(of: "'", with: "''"))' , mailstate = '\(mailstate.replacingOccurrences(of: "'", with: "''"))' ,mailpostcode = '\(mailpostcode)', mail_country ='\(mail_country.replacingOccurrences(of: "'", with: "''"))', mail_lat = '\(mail_lat)' , mail_long = '\(mail_long)' ,abn = '\(abn)' ,segment = '\(segment)' ,subsegment = '\(subsegment)' ,lob = '\(lob)' ,notes = '\(notes.replacingOccurrences(of: "'", with: "''"))' where uid = '\(uid)'"
            print("\nquery -> \(query)")
        }else{
        query = "Insert into NewCust (uid , salutation ,custtype ,fname ,lname ,deladdr ,delsuburb , delstate ,delpostcode,del_country, del_lat, del_long ,mailaddr ,mailsuburb , mailstate ,mailpostcode,mail_country, mail_lat , mail_long ,abn ,segment ,subsegment ,lob ,notes ,confname ,conlname ,conphone ,conemail ,acfname ,aclname ,acemail ,acphone,tname ,temail ,sign ,post ) VALUES ('\(uid)','\(salutation)','\(custtype)','\(fname.replacingOccurrences(of: "'", with: "''"))','\(lname.replacingOccurrences(of: "'", with: "''"))','\(deladdr.replacingOccurrences(of: "'", with: "''"))','\(delsuburb.replacingOccurrences(of: "'", with: "''"))','\(delstate.replacingOccurrences(of: "'", with: "''"))','\(delpostcode)','\(del_country.replacingOccurrences(of: "'", with: "''"))','\(del_lat)','\(del_long)','\(mailaddr.replacingOccurrences(of: "'", with: "''"))','\(mailsuburb.replacingOccurrences(of: "'", with: "''"))','\(mailstate.replacingOccurrences(of: "'", with: "''"))','\(mailpostcode)','\(mail_country.replacingOccurrences(of: "'", with: "''"))','\(mail_lat)','\(mail_long)','\(abn)','\(segment)','\(subsegment)','\(lob)','\(notes.replacingOccurrences(of: "'", with: "''"))','','','','','','','','','','','','0')"
        print("\nquery -> \(query)")
        }
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting/updating in newcust Table")
            return
        }
    }
    
    public func updatenewcustdetail(uid : String,confname : String,conlname : String,conphone : String,conemail : String,acfname : String,aclname : String,acemail : String,acphone : String){
        let query = "Update NewCust set confname = '\(confname.replacingOccurrences(of: "'", with: "''"))',conlname = '\(conlname.replacingOccurrences(of: "'", with: "''"))',conphone = '\(conphone)' ,conemail = '\(conemail)',acfname = '\(acfname.replacingOccurrences(of: "'", with: "''"))' ,aclname = '\(aclname.replacingOccurrences(of: "'", with: "''"))' ,acemail = '\(acemail)' ,acphone = '\(acphone)' where uid = '\(uid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error update in newcust Table")
            return
        }
    }
    public func updatecustterms(uid : String,tname : String,temail : String){
        let query = "Update NewCust set tname = '\(tname.replacingOccurrences(of: "'", with: "''"))',temail = '\(temail)' where uid = '\(uid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error terms update in newcust Table")
            return
        }
    }
    public func updatenewcustsign(uid : String,sign: String){
        let query = "Update NewCust set sign = '\(sign)' where uid = '\(uid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error update sign in newcust Table")
            return
        }
    }
    public func updatenewcustpost(uid : String){
        let query = "Update NewCust set post = '2' where uid = '\(uid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error update sign in newcust Table")
            return
        }
    }
    
    //    MARK:- LEAD ENTRY
    public func insertlead(topic: String,leadid : String, subject : String, firstname : String, lastname : String,  mobilephone : String, telephone1 : String, emailaddress1 : String, companyname : String, address1_line1 : String, address1_city : String, address1_stateorprovince : String,  address1_postalcode : String, revenue : String, numberofemployees : String, Jobtitle : String,  ABN : String, sourceinfo : String,  contactmethod : String,note: String){
        //        Lead(leadid text,subject text,firstname text,lastname text, mobilephone text,telephone1 text,emailaddress1 text,companyname text,address1_line1 text,address1_city text,address1_stateorprovince text, address1_postalcode text,revenue text,numberofemployees text,Jobtitle text, ABN text,sourceinfo text, contactmethod text,post text)
        
        let query = "Insert into Lead(topic,uid ,subject ,firstname ,lastname , mobilephone ,telephone1 ,emailaddress1 ,companyname ,address1_line1 ,address1_city ,address1_stateorprovince , address1_postalcode ,revenue ,numberofemployees ,Jobtitle , ABN ,sourceinfo , note,contactmethod ,post,leadid ) VALUES ('\(topic)','\(leadid)','\(subject.replacingOccurrences(of: "'", with: "''"))','\(firstname.replacingOccurrences(of: "'", with: "''"))','\(lastname.replacingOccurrences(of: "'", with: "''"))','\(mobilephone)','\(telephone1)','\(emailaddress1)' ,'\(companyname.replacingOccurrences(of: "'", with: "''"))' ,'\(address1_line1.replacingOccurrences(of: "'", with: "''"))' ,'\(address1_city.replacingOccurrences(of: "'", with: "''"))' ,'\(address1_stateorprovince.replacingOccurrences(of: "'", with: "''"))' , '\(address1_postalcode)' ,'\(revenue)' ,'\(numberofemployees)' ,'\(Jobtitle.replacingOccurrences(of: "'", with: "''"))' , '\(ABN)' ,'\(sourceinfo.replacingOccurrences(of: "'", with: "''"))' , '\(note.replacingOccurrences(of: "'", with: "''"))','\(contactmethod)' ,'0','')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Lead Table")
            return
        }
    }
    
    public func updatelead(oldid: String,newid: String){
        let query = "update lead set leadid = '\(newid)',post = '1' where uid = '\(oldid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in Lead Table")
            return
        }
    }
    public func updateleadnote(id: String){
        let query = "update lead set post = '2' where leadid = '\(id)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in Lead Table")
            return
        }
    }
    //MARK:- CASE ENTRY
    //       CaseEntry(custid text,userid text, caseid text, type text, title text, descp text, status text, date text,post text)
    public func insertcasetable(custid: String,userid : String,caseid : String, type : String,status :String,date : String,contid: String,state: String,post: String){
        
        let query2 = "Insert into CaseEntry (custid ,userid, caseid, type, title, descp, status, date,contid,state,post) VALUES ('\(custid)','\(userid)','\(caseid)','\(type)','','','\(status)','\(date)','\(contid)','\(state)','\(post)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query2, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in CaseEntry Table")
            return
        }
    }
    
    public func updatecasetable(caseid : String, title : String, descp : String){
        let query2 = "update CaseEntry set title = '\(title.replacingOccurrences(of: "'", with: "''"))' ,descp = '\(descp.replacingOccurrences(of: "'", with: "''"))' where caseid = '\(caseid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query2, nil, nil, nil) != SQLITE_OK{
            print("Error updating in CaseEntry Table")
            return
        }
    }
    public func clearcase(status: String){
        let q = "delete from CaseEntry where status = '\(status)'"
        
        if sqlite3_exec(Databaseconnection.dbs, q, nil, nil, nil) != SQLITE_OK{
            print("Error clearing caseentry for status = \(status)")
            return
        }
    }
    
    public func insertcasetype(title: String, id: String,parentid : String){
        //        CaseType(typeid text, type text, parentid text)
        let query2 = "Insert into CaseType (typeid,type,parentid) values ('\(id)','\(title)','\(parentid)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query2, nil, nil, nil) != SQLITE_OK{
            print("Error insertion in CaseType Table")
            return
        }
    }
    
    public func updatecases(today : String){
        
        let date = Date.yesterday.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dates = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let ndate = dateFormatter.string(from: dates!)
        
        let qstr = "update CaseEntry set status = '1' where date <= '\(ndate)'"
        
        if sqlite3_exec(Databaseconnection.dbs, qstr, nil, nil, nil) != SQLITE_OK{
            print("Error Updation in Case Table")
            return
        }
        
        let query = "delete from CaseEntry where title == '' and descp  == ''"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deletion in Case Table")
            return
        }
    }
    
    //MARK:- INVOICE TABLE
    public func insertinvoice(date: String,invoiceid : String, amount : String, status : String){
        //        Invoice(date text,invoiceid text, amount text,status text)
        let query = "Insert into Invoice (custid,date,invoiceid, amount, status, isselected) VALUES ('1','\(date)','\(invoiceid)','\(amount)','\(status)','false')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Invoice Table")
            return
        }
    }
    //MARK:- SUB SEGMENT
    public func insertsubsegment(segmentid : String, subsegmentid : String, descp : String){
        //    SubSegment(segmentid text, subsegmentid text, descp text)
        let query = "Insert into SubSegment (segmentid , subsegmentid , descp ) VALUES ('\(segmentid)','\(subsegmentid)','\(descp)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in SubSegment Table")
            return
        }
    }
    //  MARK:- ORDER-ITEM TAX
    public func insertorderitemtax(lotid: String,itemtaxgrp : String,percent : String, taxamt : String, taxcode : String,post : String){
        //        CustItemTax(itemtaxgrp text,percent text, taxamt text, taxcode text)"
        
        let query = "insert into CustItemTax(lotid,itemtaxgrp ,percent , taxamt , taxcode ,post ) values ('\(lotid)','\(itemtaxgrp)' ,'\(percent)' , '\(taxamt)' , '\(taxcode)','\(post)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in CustItemTax Table")
            return
        }
    }
    //  MARK:- ORDER-ITEM CHARGE
    public func insertorderitemch(lotid: String,chamt : String,chcode : String, chtype : String, chval : String, post: String){
        //            CustItemCharge(chamt text,chcode text, chtype text, chval text)
        
        let query = "insert into CustItemCharge(lotid,chamt ,chcode , chtype , chval , post) values ('\(lotid)','\(chamt)' ,'\(chcode)' , '\(chtype)' , '\(chval)','\(post)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in CustItemCharge Table")
            return
        }
    }
    
    //MARK:- CUSTORDER
    public func insertorderheader(custid : String,userid : String, custname : String, custcity : String, custstreet : String, custstate : String, custemail : String, custphone : String, lati : String,longi : String,delnote : String,ordernote : String,custtaxgrp : String,custchgrp : String,custmod : String,custmodgrp: String, custpricegrp : String, custdisgrp : String, custordernum : String,custordrchcode : String,custorderchval : String, custorderchtax : String,date : String, nextdeldate: String,status : String, lastactivityid : String , pono: String, shipdate: String, pomandate: String, post : String, callday3: String = "-1"){
        //        CustorderHeader(s_id INTEGER PRIMARY KEY AUTOINCREMENT,custid text,userid text, custname text, custcity text, custstreet text, custstate text, custemail text, custphone text, lati text,longi text,delnote text,ordernote text,custtaxgrp text,custchgrp text,custmod text,custmodgrp text, custpricegrp text, custdisgrp text, custordernum text,custordrchcode text,custorderchval text, custorderchtax text,date text,nextdeldate text , deltype text ,status text,lastactivityid text,pono text,shipdate text, pomandate text,post text, callday3 text)
        
        var call = ""
        
        if (callday3 == "-1"){
            call = self.getmaxcall()
        }else{
            call = callday3
        }
        
        let query = "insert into CustorderHeader(custid ,userid , custname , custcity , custstreet , custstate , custemail , custphone , lati ,longi ,delnote ,ordernote ,custtaxgrp ,custchgrp ,custmod ,custmodgrp, custpricegrp , custdisgrp , custordernum ,custordrchcode ,custorderchval , custorderchtax,date ,nextdeldate , deltype ,status , lastactivityid, pono, shipdate, acceptedby, pomandate, post, callday3) values ('\(custid)' ,'\(userid)' , '\(custname.replacingOccurrences(of: "'", with: "''"))' , '\(custcity.replacingOccurrences(of: "'", with: "''"))' , '\(custstreet.replacingOccurrences(of: "'", with: "''"))' , '\(custstate.replacingOccurrences(of: "'", with: "''"))' , '\(custemail)' , '\(custphone)' , '\(lati)' ,'\(longi)' ,'\(delnote.replacingOccurrences(of: "'", with: "''"))' ,'\(ordernote.replacingOccurrences(of: "'", with: "''"))' ,'\(custtaxgrp)' ,'\(custchgrp)' ,'\(custmod)' , '\(custmodgrp)', '\(custpricegrp)' , '\(custdisgrp)' , '\(custordernum)'  ,'\(custordrchcode)' ,'\(custorderchval)' , '\(custorderchtax)' ,'\(date)', '\(nextdeldate)', '','\(status)' , '\(lastactivityid)' , '\(pono)','\(shipdate)', '', '\(pomandate)', '\(post)','\(call)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Custorderheader Table")
            return
        }
    }
    
    func getmaxcall()-> String{
        var stmt1:OpaquePointer?
        var id = "-1"
        
        let query = "select ifnull(max(cast(callday3 as int)),0)+1 from CustorderHeader"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return id
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return id
    }
    
    public func updatelastactivity(activityid : String, ordernum: String){
        let query = "update Custorderheader set lastactivityid = '\(activityid)' where custordernum = '\(ordernum)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating lastactivityid in Custorderheader Table")
            return
        }
    }
    
    public func getlastactivityid(orderid: String)-> String{
        var stmt1:OpaquePointer?
        var id = ""
        
        let query = "select lastactivityid from CustorderHeader where custordernum = '\(orderid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return id
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return id
    }
    
    public func insertorderline(lotid : String,custordernum : String,itemnum : String, itemname: String,qty : String,price : String, priceunit : String,itemdisper : String, itemdisamt: String,itemdis : String, itemtaxgrp : String, itembatch : String, totval : String,cathitem : String,revsch : String,post : String){
        //        CustorderLine(lotid text,custordernum text,itemnum text, qty text,price text, priceunit text,itemdisper text, itemdisamt text, itemdis text, itemtaxgrp text, itembatch text, totval text,cathitem text, revsch text,post text)
        let query = "insert into CustorderLine(lotid ,custordernum ,itemnum ,itemname , qty ,price , priceunit ,itemdisper , itemdisamt , itemdis , itemtaxgrp , itembatch , totval,cathitem,revsch ,post ) values ('\(lotid)','\(custordernum)','\(itemnum)' , '\(itemname)','\(qty)' ,'\(price)','\(priceunit)' ,'\(itemdisper)','\(itemdisamt)' , '\(itemdis)' , '\(itemtaxgrp)' , '\(itembatch)' ,'\(totval)','\(cathitem)','\(revsch)' ,'\(post)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Custorderline Table")
            return
        }
    }
    
    public func updaterevsch(lotid: String, revsch: String, catitem: String){
        let query = "update CustorderLine set revsch = '\(revsch)' , cathitem = '\(catitem)' where lotid = '\(lotid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating revenue schedule in Custorderline Table")
            return
        }
    }
    
    
    public func updateorderqty(lotid: String,qty: String){
        
        let quantity = Double(qty)
        print("quantity ---> \(quantity)")
        let query = "update Custorderline set qty = '\(quantity!)' where lotid = '\(lotid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Custorderline Table")
            return
        }
    }
    
    public func insertcustorder(custid: String, userid: String,itemid: String,qty: String,date: String,price: String,status: String){
        //Custorder(custid text,userid text, itemid text, qty text, date text, price text, totvalue text, status text,post text)
        
        var stmt1:OpaquePointer?
        
        let query = "select * from Custorder where itemid = '\(itemid)' and custid = '\(custid)' and date = '\(date)' and status = '0' and post = '0'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            
            let totvalue : Double = (Double("\(price)")!) * Double((Int64("\(qty)")!))
            var qstr = ""
            print("totvalue =====> \(totvalue)")
            if (qty == "0"){
                qstr = "delete from Custorder where itemid = '\(itemid)' and custid = '\(custid)' and date = '\(date)' and status = '0' and post = '0'"
                print("qty =====> \(qty) item deleted")
                
            }else{
                qstr = "update Custorder set qty = '\(qty)' , totvalue = '\(totvalue)' where itemid = '\(itemid)' and custid = '\(custid)' and date = '\(date)'"
                print("qty =====> \(qty) item updated")
            }
            
            if sqlite3_exec(Databaseconnection.dbs, qstr, nil, nil, nil) != SQLITE_OK{
                print("Error Updation in Custorder Table")
                return
            }
            
        }else{
            let totvalue : Double = (Double("\(price)")!) * Double((Int64("\(qty)")!))
            
            print("totvalue =====> \(totvalue)")
            
            let querystr = "Insert into Custorder(custid, userid, itemid, qty, date, price, totvalue, status, post)  VALUES ('\(custid)','\(userid)','\(itemid)','\(qty)','\(date)','\(price)','\(totvalue)','\(status)','0')"
            
            if sqlite3_exec(Databaseconnection.dbs, querystr, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in Custorder Table")
                return
            }
        }
    }
    
    //MARK:- Stock Transfer
    public func insertstocktransfer(trkid : String, itemid : String, qty : String, date : String, uid : String,post : String){
        //StockTransfer(trkid text, itemid text, qty text, date text, uid text,post text)
        let querystr = "Insert into StockTransfer(trkid , itemid , qty , date , uid ,post )  VALUES ('\(trkid)','\(itemid)','\(qty)','\(date)','\(uid)','0')"
        
        if sqlite3_exec(Databaseconnection.dbs, querystr, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in StockTransfer Table")
            return
        }
    }
    
    public func updatestockqty(qty: String, uid: String,itemid: String){
        let querystr = "update StockTransfer set qty  = '\(qty)' where uid = '\(uid)' and itemid = '\(itemid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, querystr, nil, nil, nil) != SQLITE_OK{
            print("Error updating qty in StockTransfer Table for \(itemid)")
            return
        }
    }
    
    public func updatetrid(uid: String,trkid: String){
        let querystr = "update StockTransfer set trkid  = '\(trkid)' where uid = '\(uid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, querystr, nil, nil, nil) != SQLITE_OK{
            print("Error updating trkid in StockTransfer Table for \(trkid)")
            return
        }
    }
    
    public func updateconditiontable(type: String){
        var querystr = ""
        if (type == "1"){
            querystr = "update PreStartChecklist set post  = '2'"
        }else if (type == "2"){
            querystr = "update Compliance set post  = '2'"
        }           
        
        if sqlite3_exec(Databaseconnection.dbs, querystr, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in condition - \(type) Table")
            return
        }
    }
    
    //MARK:- CHECKIN TABLE
    public func insertcheckintable(itemid : String, itemname : String, qty : String,datetime : String){
        var stmt1:OpaquePointer?
//        ,batch text, serial text
        let querystr = "select * from Checkinitems where datetime = '\(datetime)' and itemid = '\(itemid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,querystr, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var query: String?
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            query = "update Checkinitems set qty = '\(qty)' where itemid = '\(itemid)' and datetime = '\(datetime)'"
        }else{
            query = "Insert into Checkinitems (itemid , itemname, qty,datetime) VALUES ('\(itemid)','\(itemname)','\(qty)','\(datetime)')"
        }
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Checkinitems Table")
            return
        }
    }
    
    //MARK:- ITEM MASTER
    public func insertitemmaster(itemid : String,Itemname : String, itemgstgrp : String,articletyp: String,linedisgrp : String, itemchgrp : String,isbatch : String, isserial : String, imgurl: String,itemtype : String,weight : String,isservice: Bool){
        //        Itemmaster(Itemcode text,Itemname text, itemgstgrp text,linedisgrp text ,itemchgrp text ,articletyp text, isbatch text, isserial text,itemimage text,itemtype text,weight text)
        
        let query = "Insert into Itemmaster (Itemcode ,Itemname , itemgstgrp ,linedisgrp  ,itemchgrp  ,articletyp , isbatch , isserial ,itemimage,itemtype, weight, isservice) VALUES ('\(itemid)','\(Itemname)','\(itemgstgrp)','\(linedisgrp)','\(itemchgrp)','\(articletyp)','\(isbatch)','\(isserial)','\(imgurl)','\(itemtype)','\(weight)','\(isservice)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Itemmaster Table")
            return
        }
    }
    //MARK:- COMPLIANCE
    public func insertcompliancetable(uid: String,userid : String, description : String, information : String, toogle : String){
        
        let query = "Insert into Compliance (uid ,userid, description, information, toogle, remarks, date, post,starttime) VALUES ('\(uid)','\(userid)','\(description)','\(information)','\(toogle)','','','0','')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Compliance Table")
            return
        }
        
    }
    public func savestarttime(starttime: String){
        let base = BASEACTIVITY()
        let query = "update Compliance set starttime = '\(starttime)' , date = '\(base.getdate(format: "yyyy-MM-dd hh:mm:ss a"))'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error update Compliance - starttime value")
            return
        }
    }
    //    MARK:- Get Break
    public func getbreak(uid : String, period : String,maxtime : String,restreq : String){
        //        GetBreak(uid text, period text,maxtime text,restreq text)
        let query = "Insert into GetBreak(uid, period,maxtime,restreq) VALUES ('\(uid)','\(period)','\(maxtime)','\(restreq)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in getBreak Table")
            return
        }
    }
    //    MARK:- Break table
    public func insertbreak(drid : String,date : String,brid : String, starttime : String,endtime : String,breaktime : String){
        //        Break(drid text,date text,brid text, starttime text,endtime text,state text,brearktime text)"
        let query = "Insert into Break(drid ,date ,brid , starttime ,endtime ,state ,breaktime,post) VALUES ('\(drid)','\(date)','\(brid)','\(starttime)','\(endtime)','0','\(breaktime)','0')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Break Table")
            return
        }
    }
    public func insertinbreak(drid : String,date : String,brid : String, starttime : String,endtime : String,breaktime : String,state: String, Duration: String,Post: String){
        //        Break(drid text,date text,brid text, starttime text,endtime text,state text,brearktime text)"
        
        var stmt1:OpaquePointer?
        
        let q = "select * from Break where starttime = '\(starttime)' and endtime = '\(endtime)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,q, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            // got record
        }else{
            let query = "Insert into Break(drid ,date ,brid , starttime ,endtime ,state ,breaktime, duration, post) VALUES ('\(drid)','\(date)','\(brid)','\(starttime)','\(endtime)','\(state)','\(breaktime)','\(Duration)','\(Post)')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in Break Table")
                return
            }
        }
    }
    public func updatebreak(date: String,endtime: String,breaktime: String,duration: String){
        let q = "update Break set endtime = '\(endtime)',breaktime = '\(breaktime)',state = '1',duration = '\(duration)' where date = '\(date)' and endtime = ''"
        
        if sqlite3_exec(Databaseconnection.dbs, q, nil, nil, nil) != SQLITE_OK{
            print("Error update in End Break Table")
            return
        }
    }
    public func updatestartbreak(){
        let q = "update Break set post = '1' where post = '0'"
        
        if sqlite3_exec(Databaseconnection.dbs, q, nil, nil, nil) != SQLITE_OK{
            print("Error update in start Break post")
            return
        }
    }
    public func updateendbreak(){
        let q = "update Break set post = '2' where state = '1' and post = '1'"
        
        if sqlite3_exec(Databaseconnection.dbs, q, nil, nil, nil) != SQLITE_OK{
            print("Error update in end Break post")
            return
        }
    }
    public func clearbrhhistory(){
        let q = "delete from Break where post <> '0'"
        
        if sqlite3_exec(Databaseconnection.dbs, q, nil, nil, nil) != SQLITE_OK{
            print("Error update in end Break post")
            return
        }
    }
    public func getpstart()-> Bool {
        var query = "select drid,starttime,date,brid from Break where post = '0'"
        var stmt1:OpaquePointer?
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return true
        }else{
            return false
        }
    }
    
    public func getpend()-> Bool {
        var query = "select drid,endtime,date,brid,duration from Break where state = '1' and post = '1'"
        var stmt1:OpaquePointer?
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return false
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            return true
        }else{
            return false
        }
    }
    public func droptable(tbl: String){
        let q = "drop table \(tbl)"
        
        if sqlite3_exec(Databaseconnection.dbs, q, nil, nil, nil) != SQLITE_OK{
            print("Error dropping \(tbl)")
            return
        }
    }
    //    MARK:- CUSTOMER SEARCH
    public func insertcustsrch(id: String,custid : String, name : String,city : String,state : String,street : String, email : String,phone : String, lati : String, longi : String, delnote : String, pono : String, custtaxgrp : String, custchgrp : String, modeofdel : String, custpricegrp : String, custdisgrp : String,custmodgrp: String,pomandate: String){
        //        custsrch(id text,custid text, name text,city text,state text,street text, email text,phone text, lati text, longi text, delnote text, pono text, custtaxgrp text, custchgrp text, modeofdel text, custpricegrp text, custdisgrp text)
        let query = "Insert into custsrch(id,custid , name ,city ,state ,street , email ,phone , lati , longi , delnote , pono , custtaxgrp , custchgrp , modeofdel , custpricegrp , custdisgrp ,custmodgrp , pomandate) VALUES ('\(id)','\(custid)','\(name.replacingOccurrences(of: "'", with: "''"))','\(city.replacingOccurrences(of: "'", with: "''"))','\(state.replacingOccurrences(of: "'", with: "''"))','\(street.replacingOccurrences(of: "'", with: "''"))','\(email)','\(phone)','\(lati)','\(longi)','\(delnote.replacingOccurrences(of: "'", with: "''"))','\(pono)','\(custtaxgrp)','\(custchgrp)','\(modeofdel)','\(custpricegrp)','\(custdisgrp)','\(custmodgrp)','\(pomandate)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in custsrch")
            return
        }
    }
    //    MARK:- UNLOADING TABLE
    public func insertunload(itemid : String,qty : String,batch : String,serial : String){
        //        Unloading(id text,itemname text, itemid text,qty text,batch text,serial text)
        let query = "Insert into Unloading(itemid ,qty ,batch ,serial ) VALUES ('\(itemid)','\(qty)','\(batch)','\(serial)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in unloading")
            return
        }
    }
    //    MARK:- LOADING TABLE
    public func insertload(id : String,itemname : String, itemid : String,qty : String,batch : String,serial : String){
        //        Loading(id text,itemname text, itemid text,qty text,batch text,serial text)
        let query = "Insert into Loading(id ,itemname , itemid ,qty ,batch ,serial ) VALUES ('\(id)','\(itemname)','\(itemid)','\(qty)','\(batch)','\(serial)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in loading")
            return
        }
    }
    
    public func updateloadqty(qty: String,itemid: String){
        let query = "update loading set qty = '\(qty)' where itemid = '\(itemid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in loading Table")
            return
        }
    }
    //    MARK:- TAX GROUP
    public func inserttaxgroup(id : String,taxgrpcode : String, gstcode : String,taxtype : String){
        //        TaxGroup(id text,taxgrpcode text, gstcode text,taxtype text)"
        let query = "Insert into TaxGroup(id ,salestaxgrp , gstcode ,itemsalestaxgrp ) VALUES ('\(id)','\(taxgrpcode)','\(gstcode)','\(taxtype)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in TaxGroup Table")
            return
        }
    }
    //    MARK:- TAX MASTER
    public func inserttaxmaster(id : String,gstval : String, gstcode : String){
        //        TaxMaster(id text,gstval text, gstcode text)"
        let query = "Insert into TaxMaster(id ,gstval , gstcode) VALUES ('\(id)','\(gstval)','\(gstcode)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in TaxMaster Table")
            return
        }
    }
    //    MARK:- AUTO CHARGE
    public func insertautocharge(id : String,accode : String, custrelation : String,itemcode : String,itemrelation : String,modc : String,modr : String,cat : String, chcode : String, chval : String,saletaxgrp : String,itemtaxgrp : String, levelline : String){
        //        AutoCharge(id text,accode text, custrelation text,itemcode text,itemrelation text,modc text,modr text,cat text, chcode text, chval text,saletaxgrp text,chvaltyp text, itemtaxgrp text, levelline text)
        
        let query = "Insert into AutoCharge(id ,accode , custrelation ,itemcode ,itemrelation ,modc ,modr ,cat , chcode , chval ,saletaxgrp,itemtaxgrp , levelline) VALUES ('\(id)','\(accode)','\(custrelation)','\(itemcode)','\(itemrelation)','\(modc)','\(modr)','\(cat)','\(chcode)','\(chval)','\(saletaxgrp)','\(itemtaxgrp)','\(levelline)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in AutoCharge Table")
            return
        }
    }
    //   MARK:- SERIAL MASTER
    public func insertserialmaster(id : String,invtserial : String, itemid : String){
        //        SerialMaster(id text,invtserial text, itemid text)
        let query = "Insert into SerialMaster(id ,invtserial , itemid ) VALUES ('\(id)','\(invtserial)','\(itemid)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in SerialMaster Table")
            return
        }
    }
    //   MARK:- BATCH MASTER
    public func insertbatchmaster(id : String,invtbatch : String, itemid : String){
        //    BatchMaster(id text,invtbatch text, itemid text)
        let query = "Insert into BatchMaster(id ,invtbatch , itemid ) VALUES ('\(id)','\(invtbatch)','\(itemid)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in BatchMaster Table")
            return
        }
    }
    //    MARK:- PRICE MASTER
    
    public func insertpricemaster(id : String,accode : String, acrelation : String,itemrelation : String,fromdate : String,todate : String, amt : String,priceunit : String){
        //    PriceMaster(id text,accode text, acrelation text,itemrelation text,fromdate text,todate text, amt text,priceunit text)
        let query = "Insert into PriceMaster(id ,accode , acrelation ,itemrelation ,fromdate ,todate , amt ,priceunit ) VALUES ('\(id)','\(accode)','\(acrelation)','\(itemrelation)','\(fromdate)','\(todate)','\(amt)','\(priceunit)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in PriceMaster Table")
            return
        }
    }
    //    MARK:- DISCOUNT MASTER
    public func insertdiscountmaster(id : String,accode : String, acrelation : String, itemcode : String,itemrelation : String,fromdate : String,todate : String, fromqty : String, toqty : String, discount : String, disper : String, fixamt : String){
        //        DiscountMaster(id text,accode text, acrelation text, itemcode text,itemrelation text,fromdate text,todate text, fromqty text, toqty text, discount text, disper text, fixamt text)
        let query = "Insert into DiscountMaster(id ,accode , acrelation , itemcode ,itemrelation ,fromdate ,todate , fromqty , toqty , discount , disper , fixamt) VALUES ('\(id)','\(accode)','\(acrelation)','\(itemcode)','\(itemrelation)','\(fromdate)','\(todate)','\(fromqty)','\(toqty)','\(discount)','\(disper)','\(fixamt)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in DiscountMaster Table")
            return
        }
    }
    //    MARK:- UPDATE CHARGE HEADER
    public func updatechargesheader(custid: String, custchgrp: String, custmod: String,custmodgrp : String,orderid : String){
        //        select saletaxgrp,chcode,chval from autocharge where levelline = 'Header' and case when accode = '0' then custrelation = '101000001'  when accode = '1' then custrelation = 'NSW' when accode = '2' then custrelation = '' end and itemcode = '2' and chcode = 'Delivery' and saletaxgrp <> ''
        var stmt1 : OpaquePointer?
        
        let query = "select saletaxgrp,chcode,chval,itemtaxgrp from autocharge where levelline = 'Header' and case when accode = '0' then custrelation = '\(custid)'  when accode = '1' then custrelation = '\(custchgrp)' when accode = '2' then custrelation = '' end and itemcode = '2' and case when modc = '1' then modr = '\(custmodgrp)'  when modc = '2' then modr = '\(custmod)'  end"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let saletaxgrp = String(cString: sqlite3_column_text(stmt1, 0))
            let chcode = String(cString: sqlite3_column_text(stmt1, 1))
            let chval = String(cString: sqlite3_column_text(stmt1, 2))
            let itemtax = String(cString: sqlite3_column_text(stmt1, 3))
            
            self.dochupdate(saletaxgrp: saletaxgrp, chcode: chcode, chval: chval, orderid: orderid, itemtax: itemtax)
        }
    }
    
    func dochupdate(saletaxgrp: String, chcode: String, chval: String, orderid: String, itemtax: String){
        var stmt1 : OpaquePointer?
        
        let query1 = "select ifnull((\(chval) * (select gstval from TaxMaster where gstcode = (select gstcode from taxgroup where salestaxgrp = '\(saletaxgrp)' and itemsalestaxgrp = '\(itemtax)')) / 100),'0') as taxamt"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var custordertax = "0.0"
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            custordertax  = String(cString: sqlite3_column_text(stmt1, 0))
        }
        
        let query = "update custorderheader set custtaxgrp = '\(saletaxgrp)' , custorderchval = '\(chval)', custordrchcode = '\(chcode)', custorderchtax = '\(custordertax)' where custordernum = '\(orderid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating charges header in custorderheader Table")
            return
        }
    }
   
    //    MARK:- UPDATE PRICE
    public func updateprice(itemid: String, orderdate: String,custid: String, pricegroup: String,orderid: String){
        
        var stmt1 : OpaquePointer?
        
        let query1 = "Select amt,priceunit from pricemaster where itemrelation = '\(itemid)' and fromdate <= '\(orderdate)' and (todate >= '\(orderdate)' or todate = '1900-01-01 12:00:00' ) and case when accode = '0' then acrelation = '\(custid)' when accode = '1' then acrelation = '\(pricegroup)' when accode = '2' then acrelation = '' end"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let amt = String(cString: sqlite3_column_text(stmt1, 0))
            let priceunit = String(cString: sqlite3_column_text(stmt1, 1))
            
            let query = "update custorderline set priceunit = '\(priceunit)' , price = '\(amt)' where custordernum = '\(orderid)' and itemnum = '\(itemid)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error updating price in custorderline Table")
                return
            }
        }
    }
    //    MARK:- UPDATE DISCOUNT
    public func updatediscount(itemid: String,custid: String, discountgrp: String,orderid: String){
        
        var stmt1 : OpaquePointer?
        
        let query1 = "Select discount,disper from DiscountMaster where case when accode = '0' then acrelation = '\(custid)' when accode = '1' then acrelation = '\(discountgrp)' end and case when itemcode = '0' then itemrelation = '\(itemid)' when itemcode = '1' then itemrelation = (select linedisgrp from Itemmaster where itemcode = '\(itemid)') when itemcode = '2' then itemrelation = '' end ORDER by accode,itemcode"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let dis = String(cString: sqlite3_column_text(stmt1, 0))
            let disper = String(cString: sqlite3_column_text(stmt1, 1))
            
            var query = ""
            if (dis != "0.0"){
                query = "update custorderline set itemdis = '\(dis)' where custordernum = '\(orderid)' and itemnum = '\(itemid)'"
            }else if (disper != "0.0"){
                query = "update custorderline set itemdisper = '\(disper)' where custordernum = '\(orderid)' and itemnum = '\(itemid)'"
            }
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error updating discount in custorderline Table")
                return
            }
        }
    }
    //   MARK:- LINE AMOUNT UPDATE
    public func updatelineamt(orderid : String, itemid: String){
        var stmt1 : OpaquePointer?
        let query1 = "select qty,price,priceunit,itemdis,itemdisper from CustorderLine where lotid = '\(orderid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let qty = sqlite3_column_double(stmt1, 0)
            let price = sqlite3_column_double(stmt1, 1)
            let priceunit = sqlite3_column_double(stmt1, 2)
            let itemdis = sqlite3_column_double(stmt1, 3)
            let itemdisper = sqlite3_column_double(stmt1, 4)
            
            //    line amount  = (qty * sale price /price unit)  -  (qty * discount ) - ( qty * sale price  /price unit )  * discount percent / 100
            var lineamt: Double!
            let param1 = (qty * (price/priceunit))
            let disamt = (qty * itemdis) + (param1 * (itemdisper/100))
            lineamt = param1 - disamt
            
            let query = "update custorderline set totval = '\(lineamt!)', itemdisamt = '\(disamt)' where lotid = '\(orderid)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error updating lineamt in custorderline Table")
                return
            }
        }
    }
    //    MARK:- TAX LINE UPDATE
    public func updatetaxline(itemid: String, orderid: String,lotid: String){
        var stmt1 : OpaquePointer?
        let query1 = "select gstval,gstcode,((select totval from Custorderline where lotid = '\(lotid)') * (cast(gstval as real)/100) ) as lineamount,(select itemtaxgrp from Custorderline where lotid = '\(lotid)') as itemtaxgrp from TaxMaster where gstcode = (select b.gstcode from Custorderheader a inner join TaxGroup b on a.custtaxgrp = b.salestaxgrp inner join CustorderLine c on c.itemtaxgrp = b.itemsalestaxgrp where c.lotid = '\(lotid)')"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "delete from CustItemTax where lotid = '\(lotid)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error delete in CustItemTax Table")
                return
            }
        }
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let gstvl = String(cString: sqlite3_column_text(stmt1, 0))
            let gstcode = String(cString: sqlite3_column_text(stmt1, 1))
            let amt = String(cString: sqlite3_column_text(stmt1, 2))
            let itemtaxgrp = String(cString: sqlite3_column_text(stmt1, 3))
            
            self.insertorderitemtax(lotid: lotid, itemtaxgrp: itemtaxgrp, percent: gstvl, taxamt: amt, taxcode: gstcode, post: "0")
        }
    }
    //    MARK:- CHARGE LINE UPDATE
    public func updatechargeline (itemid: String, orderid: String,lotid: String,custid: String, custchgrp: String, itemchgrp: String){
        var stmt1 : OpaquePointer?
        let query1 = "select saletaxgrp,itemtaxgrp,chcode,chval,cat from autocharge where levelline = 'Line' and  case when itemcode = '0' then itemrelation = '\(itemid)' when itemcode = '1' then itemrelation = '\(itemchgrp)' when itemcode = '2' then itemrelation = '' end and case when accode = '0' then custrelation = '\(custid)'  when accode = '1' then custrelation = '\(custchgrp)' when accode = '2' then custrelation = '' end"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let query = "delete from CustItemCharge where lotid = '\(lotid)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error delete in CustItemCharge Table")
                return
            }
        }
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let saletxgrp = String(cString: sqlite3_column_text(stmt1, 0))
            let itemtxgrp = String(cString: sqlite3_column_text(stmt1, 1))
            let chcode = String(cString: sqlite3_column_text(stmt1, 2))
            let chval = String(cString: sqlite3_column_text(stmt1, 3))
            let cat = String(cString: sqlite3_column_text(stmt1, 4))
            
            self.doupdateordrch(lotid: lotid, chval: chval, chcode: chcode, cat: cat,orderid: orderid, itemid: itemid)
            self.dolinetaxinsert(lotid: lotid, salestaxgroup: saletxgrp, itemtaxgrp: itemtxgrp,percent: chval, taxcode: chcode)
        }
    }
    //    MARK:- CHARGE LINE TAX
    func dolinetaxinsert(lotid: String,salestaxgroup: String, itemtaxgrp: String,percent: String, taxcode: String){
        var stmt1: OpaquePointer?
        
        let query = "select ifnull(((select  chamt from CustItemCharge where lotid = '\(lotid)') * (select gstval from TaxMaster where gstcode = (select gstcode from taxgroup where salestaxgrp = '\(salestaxgroup)' and itemsalestaxgrp = '\(itemtaxgrp)')) / 100), '0') as taxamt"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let amt = String(cString: sqlite3_column_text(stmt1, 0))
            
            self.insertorderitemtax(lotid: lotid, itemtaxgrp: itemtaxgrp, percent: percent, taxamt: amt, taxcode: taxcode, post: "0")
        }
    }
    
    func doupdateordrch(lotid: String,chval: String,chcode: String, cat: String,orderid: String, itemid: String){
        var chamt: Double!
        
        var stmt1 : OpaquePointer?
        let query1 = "select qty,totval from CustorderLine where lotid = '\(lotid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            let qty = sqlite3_column_double(stmt1, 0)
            let lineamt = sqlite3_column_double(stmt1, 1)
            
            //            if cat = 0 then chamt = chval  -- 0 for fix
            //               cat  = 1 then chamt = orderline qty * chval   -- 1 for peices
            //               cat = 2 then chamt = lineamt * chval/100   -- 2 for percent
            let chvalue = Double(chval)!
            if (cat == "0"){
                chamt = chvalue
            }else if (cat == "1"){
                chamt = qty * chvalue
            }else if (cat == "2"){
                chamt = lineamt * (chvalue/100)
            }
            self.insertorderitemch(lotid: lotid, chamt: "\(chamt!)", chcode: chcode, chtype: cat, chval: "\(chvalue)", post: "0")
        }
    }
    //    MARK:- GET LOTID
    public func getlotid(orderid: String, itemid: String)-> String{
        var stmt1 : OpaquePointer?
        var lotid = ""
        let query1 = "select lotid from CustorderLine where custordernum = '\(orderid)' and itemnum = '\(itemid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return lotid
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            lotid = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return lotid
    }
    //    MARK:- GET ITEM CHARGE
    public func getitemchgrp(orderid: String, itemid: String)-> String{
        var stmt1 : OpaquePointer?
        var itemchgrp = ""
        let query1 = "select itemchgrp from Itemmaster where itemcode = '\(itemid)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return itemchgrp
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            itemchgrp = String(cString: sqlite3_column_text(stmt1, 0))
        }
        return itemchgrp
    }
    //    MARK:- BATCH-SERIAL
    //    BatchSerial(lotid text,batch text, qty text,serial text,type text,post text)
    public func insertbatchserial(lotid: String, batch: String, serial: String,qty: String,type: String,post: String){
        var stmt1 : OpaquePointer?
        let query1 = "select * from batchserial where lotid = '\(lotid)' and batch = '\(batch)' and serial = '\(serial)' and type = '\(type)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var query = ""
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            query = "update batchserial set qty = '\(qty)' where lotid = '\(lotid)' and batch = '\(batch)' and serial = '\(serial)' and type = '\(type)'"
        }else{
            query = "insert into batchserial (lotid ,batch , qty ,serial ,type ,post ) values ('\(lotid)','\(batch)','\(qty)','\(serial)','\(type)','\(post)')"
        }
        
        if (type == "dimdetails"){
            query = "insert into batchserial (lotid ,batch , qty ,serial ,type ,post ) values ('\(lotid)','\(batch)','\(qty)','\(serial)','\(type)','\(post)')"
        }
        print("\n batch serial query -> \(query)")
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error execution in batchserial Table")
            return
        }
    }

    public func deleteerialbatch(lotid: String, batch: String, serial : String,type: String){
        let query = "delete from batchserial where lotid = '\(lotid)' and batch = '\(batch)' and serial = '\(serial)' and type = '\(type)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting serialbatch for \(lotid)")
            return
        }
    }
    public func deletesbatchtbl(type : String,post : String = "2"){
        let query = "delete from batchserial where type = '\(type)' and post = '\(post)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting serialbatch for \(type)")
            return
        }
    }
    public func deletebatchitems(lotid: String,type : String){
        let query = "delete from batchserial where lotid = '\(lotid)' and type = '\(type)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting serialbatch for \(lotid) -> \(type)")
            return
        }
    }
    //MARK:- REVENUE SCHEDULE
    public func insertrevenueschedule(id : String,code : String, description : String){
        let query = "Insert into RevenueSchedule(id ,code , description ) VALUES ('\(id)','\(code)','\(description)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in RevenueSchedule Table")
            return
        }
    }
    //MARK:- REASON MASTER
    
    public func insertreasonmaster(id : String,type : Int,skipcode : String, description : String){
        let query = "Insert into ReasonMaster(id ,type ,skipcode , description ) VALUES ('\(id)','\(type)','\(skipcode)','\(description)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in ReasonMaster Table")
            return
        }
    }
    //MARK:- RESCHEDULE REASON
    
    public func insertreschedulereason(id : String,reasoncode : String, description : String){
        let query = "Insert into RescheduleReason(id ,reasoncode , description ) VALUES ('\(id)','\(reasoncode)','\(description)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in RescheduleReason Table")
            return
        }
    }
    //   MARK:- NO DEL REASON
    public func insertnodelreason(ordernum : String,reasoncode : String, description : String, note : String, date : String,skipcancelname : String, type : String){
        
        if (type == "\(NoDelReason.cancelOrder.rawValue)"){
            var stmt1: OpaquePointer?
                    
            let query1 = "select * from NoDelReason where ordernum = '\(ordernum)' and type = '\(NoDelReason.cancelOrder.rawValue)'"
            
            if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                let query = "update nodelreason set reasoncode = '\(reasoncode)' , skipcancelname = '\(skipcancelname)' , date = '\(date)' , post = '0' where ordernum = '\(ordernum)' and type = '\(NoDelReason.cancelOrder.rawValue)'"
                
                if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                    print("Error inserting in NoDelReason Table")
                    return
                }
            }else
            {
                let query = "Insert into NoDelReason(ordernum ,reasoncode , description , note , date , skipcancelname, type, state,post ) VALUES ('\(ordernum)','\(reasoncode)','\(description)','\(note)','\(date)','\(skipcancelname)','\(type)','1','0')"
                
                if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                    print("Error inserting in NoDelReason Table")
                    return
                }
            }
        }else{
            let query = "Insert into NoDelReason(ordernum ,reasoncode , description , note , date , skipcancelname, type, state,post ) VALUES ('\(ordernum)','\(reasoncode)','\(description)','\(note)','\(date)','\(skipcancelname)','\(type)','0','0')"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error inserting in NoDelReason Table")
                return
            }
        }
    }
    
    public func deleteunsaveentry(orderid: String){
        let query = "delete from NoDelReason where ordernum = '\(orderid)' and state = '0'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error deleting in NoDelReason Table")
            return
        }else{
            if (isskip(orderid: orderid)){
                self.updatelastactivity(activityid: NoDelReason.skip.rawValue, ordernum: orderid)
            }else{
                self.updatelastactivity(activityid: NoDelReason.open.rawValue, ordernum: orderid)
            }
        }
    }
    public func isskip(orderid: String)-> Bool{
        var flag = false
        var stmt1: OpaquePointer?
                
        let query = "select * from NoDelReason where ordernum = '\(orderid)' and state = '1' and type = '\(NoDelReason.skip.rawValue)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return flag
        }
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            flag = true
        }
        return flag
    }
    
    public func updatenodelreasonstate(orderid: String){
        let query = "update NoDelReason set state = '1' where ordernum = '\(orderid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in NoDelReason Table")
            return
        }
    }
    
    public func updatehistory(ids: [String]){
        var query = "update NoDelReason set post = '2' where post = '0'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating in NoDelReason Table")
            return
        }
        for id in ids {
            query = "update CustorderHeader set post = '2' where custordernum = '\(id)'"
            
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error updating in custorderheader Table - orderid : \(id)")
                return
            }
        }
    }
    //    MARK: -  IMAGE
    public func insertimage(ordernum : String, image : String, type : String,date : String,activity : String,post : String){
        //        Images(ordernum text, image text, type text,date text, activity text,post text)"
        var stmt1:OpaquePointer?
        var query = ""
        let querystr = "select * from images where ordernum = '\(ordernum)' and type = '\(type)' and date = '\(date)' and activity = '\(activity)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,querystr, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            query = "update Images set image = '\(image)' where ordernum = '\(ordernum)' and type = '\(type)' and date = '\(date)' and activity = '\(activity)'"
        }else{
            query = "Insert into Images(ordernum , image , type ,date ,activity ,post ) VALUES ('\(ordernum)','\(image)','\(type)','\(date)','\(activity)','\(post)')"
        }
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in Images Table")
            return
        }
    }
    //MARK:- Truck Transfer Status
    
    public func insertTruckTransferStatus(id : String,trucktransferid : String, status : Int){
        let query = "Insert into TruckTransferStatus(id ,trucktransferid , status ) VALUES ('\(id)','\(trucktransferid)','\(status)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in TruckTransferStatus Table")
            return
        }
    }
    //MARK:- TRUCK MASTER
    public func insertTruckMaster(id : String,code : String, description : String,driverid : String){
        let query = "Insert into TruckMaster(id ,code , description, driverid ) VALUES ('\(id)','\(code)','\(description)','\(driverid)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in TruckMaster Table")
            return
        }
    }
    
    //MARK:- TRANSFER DETAILS
    public func insertTransferDetails(id : String,trucktransferid : String, fromtruck : String,ToTruck: String, status: Int){
        let query = "Insert into TransferDetails(id ,trucktransferid , fromtruck, totruck, status) VALUES ('\(id)','\(trucktransferid)','\(fromtruck)','\(ToTruck)', '\(status)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in TransferDetails Table")
            return
        }
    }
    public func updatestatus(transferid: String,status: Int){
        let query = "update TransferDetails set status = '\(status)' where trucktransferid = '\(transferid)'"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating status in TransferDetails Table")
            return
        }
    }
    //MARK:- TRANSFER DETAILS SKU
    public func insertTransferDetailsSku(skuid : String,itemid : String, inventbatchid : String, inventserialid : String , itemname : String , qty : Double){
        let query = "Insert into TransferDetailsSku(skuid , itemid , inventbatchid ,inventserialid,itemname,qty) VALUES ('\(skuid)','\(itemid)','\(inventbatchid)','\(inventserialid)','\(itemname)','\(qty)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in TransferDetailsSku Table")
            return
        }
    }
    //MARK:- LINE OF BUSSINESS
    public func insertlineofbussiness(lobid : String, descp : String){
        let query = "Insert into LineOfBussiness(lobid , descp ) VALUES ('\(lobid)','\(descp)')"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error inserting in LineOfBussiness Table")
            return
        }
    }
//    LineOfBussiness(lobid text, descp text)"
//    MARK:- TRUCK STOCK
    public func insertts_fromSO(orderid: String){
        
        var stmt1:OpaquePointer?
        let query = "select c.itemnum,case when b.isbatch = '0'  and b.isserial = '0' then c.qty else cast(sum(a.qty) as int) end as qty , case when b.isbatch = '0' then '' else a.batch end as batch,b.isservice, case when b.isserial = '0' then '' else a.serial end as serial,c.lotid from CustorderLine c left outer join  batchserial a on a.lotid = c.lotid inner join itemmaster b on c.itemnum = b.itemcode where c.custordernum = '\(orderid)'  group by c.itemnum, a.batch, a.serial"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            let batch = String(cString: sqlite3_column_text(stmt1, 2))
            let isservice = String(cString: sqlite3_column_text(stmt1, 3))
            let serial = String(cString: sqlite3_column_text(stmt1, 4))
            let lotid = String(cString: sqlite3_column_text(stmt1, 5))
            
            self.insertdimdetails(orderid: orderid, itemid: itemid, batch: batch, serial: serial, qty: qty, post: "0", lotid: lotid)
        }
        self.insertts_fromdim(sign: "+")
        self.insertts_fromdim(sign: "-")
        
        self.insertts_fromSOline(orderid: orderid)
    }
    
    public func insertts_fromSOline(orderid: String){
        
        var stmt1:OpaquePointer?
        let query = "select a.itemnum,a.qty,a.lotid from CustorderLine a inner join Itemmaster b on a.itemnum=b.itemcode where a.custordernum = '\(orderid)' and b.isserial = '0' and b.isbatch = '0'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            let lotid = String(cString: sqlite3_column_text(stmt1, 2))
            
            self.insertdimdetails(orderid: orderid, itemid: itemid, batch: "", serial: "", qty: qty, post: "0", lotid: lotid)
        }
        self.insertts_fromdim(sign: "+")
        self.insertts_fromdim(sign: "-")
    }
    
    public func insertts_fromload(){
        var stmt1:OpaquePointer?
        
        let query = "select a.itemid,cast(sum(a.qty) as int),a.batch,b.isserial,a.serial from Loading a inner join itemmaster b on  a.itemid = b.itemcode group by a.itemid, a.batch, a.serial"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            let batch = String(cString: sqlite3_column_text(stmt1, 2))
            let isservice = String(cString: sqlite3_column_text(stmt1, 3))
            let serial = String(cString: sqlite3_column_text(stmt1, 4))
            
            self.inserttruckstock(itemid: itemid, isservice: isservice, batch: batch, serial: serial, loadqty: qty)
        }
        self.insertts_fromunload()
    }
    
    func insertts_fromunload(){
        var stmt1:OpaquePointer?
        
        let query = "select a.itemid,cast(sum(a.qty) as int),a.batch,b.isserial,a.serial from unloading a inner join itemmaster b on  a.itemid = b.itemcode group by a.itemid, a.batch, a.serial"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            let batch = String(cString: sqlite3_column_text(stmt1, 2))
            let isservice = String(cString: sqlite3_column_text(stmt1, 3))
            let serial = String(cString: sqlite3_column_text(stmt1, 4))
            
            self.updatets_unloadqty(itemid: itemid, isservice: isservice, batch: batch, serial: serial, unloadqty: qty)
        }
        self.insertts_fromdim(sign: "+")
        self.insertts_fromdim(sign: "-")
        self.insertts_fromtransferdetails(fromto: "totruck", status: "1")
        self.insertts_fromtransferdetails(fromto: "fromtruck", status: "1")
        self.insertts_fromtransferdetails(fromto: "fromtruck", status: "0")
        self.updatets()
    }
    
    func insertts_fromdim(sign: String){
        var stmt1:OpaquePointer?
        var query = ""
        if (sign == "+"){
            query = "select a.itemid,cast(sum(a.qty) as int),a.batch,b.isserial,a.serial from dimdetails a inner join itemmaster b on  a.itemid = b.itemcode where cast(a.qty as int) > 0 group by a.itemid, a.batch, a.serial "
        }else if (sign == "-"){
            query = "select a.itemid,cast(sum(a.qty) as int),a.batch,b.isserial,a.serial from dimdetails a inner join itemmaster b on  a.itemid = b.itemcode where cast(a.qty as int) < 0 group by a.itemid, a.batch, a.serial "
        }
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            let batch = String(cString: sqlite3_column_text(stmt1, 2))
            let isservice = String(cString: sqlite3_column_text(stmt1, 3))
            let serial = String(cString: sqlite3_column_text(stmt1, 4))
            
            self.updatets_dimqty(itemid: itemid, isservice: isservice, batch: batch, serial: serial, dimqty: qty)
        }
        
    }
    func insertts_fromtransferdetails(fromto: String, status: String){
        var stmt1:OpaquePointer?
        
        let query = "select a.itemid,cast(sum(a.qty) as int),a.inventbatchid,b.isservice,a.inventserialid from TransferDetailsSku a inner join Itemmaster b on a.itemid = b.itemcode where a.skuid in (select trucktransferid from transferdetails where \(fromto) = (select code from truckmaster where driverid = '\(UserDefaults.standard.string(forKey: "did")!)') and status = '\(status)') group by a.itemid,a.inventbatchid,a.inventserialid"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        print("query ---> \(query)")
        
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let itemid = String(cString: sqlite3_column_text(stmt1, 0))
            let qty = String(cString: sqlite3_column_text(stmt1, 1))
            let batch = String(cString: sqlite3_column_text(stmt1, 2))
            let isservice = String(cString: sqlite3_column_text(stmt1, 3))
            let serial = String(cString: sqlite3_column_text(stmt1, 4))
            
            self.updatetdqty(itemid: itemid, isservice: isservice, batch: batch, serial: serial, qty: qty, fromto: fromto, status: status)
        }
    }
    
    func updatetdqty(itemid : String, isservice : String, batch : String, serial : String , qty : String,fromto: String,status: String){
        var stmt1:OpaquePointer?
        
        let query = "select * from TruckStock where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var query1 = ""
        
        print("qty --> \(qty) fromto --> \(fromto)")
        
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            if (fromto == "totruck" && status == "1"){
                query1 = "update TruckStock set trucktransferreceipt = '\(qty)' where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
            }else if (fromto == "fromtruck" && status == "1"){
                query1 = "update TruckStock set trucktransfership = '\(qty)' where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
            }else{
                query1 = "update TruckStock set trucktransferopen = '\(qty)' where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
            }
        }else{
            if (fromto == "totruck" && status == "1"){
                
                query1 = "Insert into TruckStock(itemid , isservice , batch , serial  , loadqty  , deliveredqty , returnedqty , trucktransferreceipt , trucktransfership , trucktransferopen , unload , netqty ) VALUES ('\(itemid)','\(isservice)','\(batch)','\(serial)','0','0','0','\(qty)','0','0','0','0')"
                
            }else if (fromto == "fromtruck" && status == "1"){
                
                query1 = "Insert into TruckStock(itemid , isservice , batch , serial  , loadqty  , deliveredqty , returnedqty , trucktransferreceipt , trucktransfership , trucktransferopen , unload , netqty ) VALUES ('\(itemid)','\(isservice)','\(batch)','\(serial)','0','0','0','0','\(qty)','0','0','0')"
                
            }else{
                
                query1 = "Insert into TruckStock(itemid , isservice , batch , serial  , loadqty  , deliveredqty , returnedqty , trucktransferreceipt , trucktransfership , trucktransferopen , unload , netqty ) VALUES ('\(itemid)','\(isservice)','\(batch)','\(serial)','0','0','0','0','0','\(qty)','0','0')"
            }
        }
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error inserting transferdetials in TruckStock Table")
            return
        }
    }
    
    public func inserttruckstock(itemid : String, isservice : String, batch : String, serial : String , loadqty : String){
//        TruckStock(itemid text, isservice text, batch text, serial text , loadqty text , deliveredqty text, returnedqty text, trucktransferreceipt text, trucktransfership text, trucktransferopen text, unload text, netqty text)
        var stmt1:OpaquePointer?
        
        let query = "select * from TruckStock where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var query1 = ""
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            query1 = "update TruckStock set loadqty = '\(loadqty)' where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
        }else{
            query1 = "Insert into TruckStock(itemid , isservice , batch , serial  , loadqty  , deliveredqty , returnedqty , trucktransferreceipt , trucktransfership , trucktransferopen , unload , netqty ) VALUES ('\(itemid)','\(isservice)','\(batch)','\(serial)','\(loadqty)','0','0','0','0','0','0','0')"
        }
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error inserting load in TruckStock Table")
            return
        }
    }
    
    func updatets(){
        let query = "update TruckStock set netqty = cast(loadqty as INT) - cast(deliveredqty as INT) + cast(trucktransferreceipt as INT) - cast(trucktransfership as INT) - cast(trucktransferopen as INT) - cast(unload as INT)"
        
        if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
            print("Error updating netqty in TruckStock Table")
            return
        }
    }
    
    func updatets_unloadqty(itemid : String, isservice : String, batch : String, serial : String , unloadqty : String){
        var stmt1:OpaquePointer?
        
        let query = "select * from TruckStock where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var query1 = ""
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            query1 = "update TruckStock set unload = '\(unloadqty)' where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
        }else{
            query1 = "Insert into TruckStock(itemid , isservice , batch , serial  , loadqty  , deliveredqty , returnedqty , trucktransferreceipt , trucktransfership , trucktransferopen , unload , netqty ) VALUES ('\(itemid)','\(isservice)','\(batch)','\(serial)','0','0','0','0','0','0','\(unloadqty)','0')"
        }
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error inserting unload in TruckStock Table")
            return
        }
    }
    func updatets_dimqty(itemid : String, isservice : String, batch : String, serial : String , dimqty : String){
        var stmt1:OpaquePointer?
        
        let query = "select * from TruckStock where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var query1 = ""
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            if (dimqty.contains("-")){
                query1 = "update TruckStock set returnedqty = '\(dimqty)' where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
            }else{
                query1 = "update TruckStock set deliveredqty = '\(dimqty)' where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
            }
            
        }else{
            if (dimqty.contains("-")){
                query1 = "Insert into TruckStock(itemid , isservice , batch , serial  , loadqty  , deliveredqty , returnedqty , trucktransferreceipt , trucktransfership , trucktransferopen , unload , netqty ) VALUES ('\(itemid)','\(isservice)','\(batch)','\(serial)','0','0','\(dimqty)','0','0','0','0','0')"
            }else{
                query1 = "Insert into TruckStock(itemid , isservice , batch , serial  , loadqty  , deliveredqty , returnedqty , trucktransferreceipt , trucktransfership , trucktransferopen , unload , netqty ) VALUES ('\(itemid)','\(isservice)','\(batch)','\(serial)','0','\(dimqty)','0','0','0','0','0','0')"
            }
            
        }
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error inserting dim in TruckStock Table")
            return
        }
    }
    func updatets_tdqty(itemid : String, isservice : String, batch : String, serial : String , dimqty : String){
        var stmt1:OpaquePointer?
        
        let query = "select * from TruckStock where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
        
        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        var query1 = ""
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            if (dimqty.contains("-")){
                query1 = "update TruckStock set returnedqty = '\(dimqty)' where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
            }else{
                query1 = "update TruckStock set deliveredqty = '\(dimqty)' where itemid = '\(itemid)' and serial = '\(serial)' and batch = '\(batch)'"
            }
            
        }else{
            if (dimqty.contains("-")){
                query1 = "Insert into TruckStock(itemid , isservice , batch , serial  , loadqty  , deliveredqty , returnedqty , trucktransferreceipt , trucktransfership , trucktransferopen , unload , netqty ) VALUES ('\(itemid)','\(isservice)','\(batch)','\(serial)','0','0','\(dimqty)','0','0','0','0','0')"
            }else{
                query1 = "Insert into TruckStock(itemid , isservice , batch , serial  , loadqty  , deliveredqty , returnedqty , trucktransferreceipt , trucktransfership , trucktransferopen , unload , netqty ) VALUES ('\(itemid)','\(isservice)','\(batch)','\(serial)','0','\(dimqty)','0','0','0','0','0','0')"
            }
            
        }
        if sqlite3_exec(Databaseconnection.dbs, query1, nil, nil, nil) != SQLITE_OK{
            print("Error inserting dim in TruckStock Table")
            return
        }
    }
    //    DimDetails(ordernum text,itemid text,batch text, qty text,serial text,post text)"
    public func insertdimdetails(orderid: String,itemid: String, batch: String, serial: String,qty: String,post: String, lotid: String){
            var stmt1 : OpaquePointer?
            let query1 = "select * from dimdetails where ordernum = '\(orderid)' and itemid = '\(itemid)' and batch = '\(batch)' and serial = '\(serial)' and lotid = '\(lotid)'"
            
            if  sqlite3_prepare_v2(Databaseconnection.dbs,query1, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
                print("error preparing get: \(errmsg)")
                return
            }
            var query = ""
            if(sqlite3_step(stmt1) == SQLITE_ROW){
                query = "update dimdetails set qty = '\(qty)' , post = '2' where ordernum = '\(orderid)' and itemid = '\(itemid)' and batch = '\(batch)' and serial = '\(serial)' and lotid = '\(lotid)'"
            }else{
                query = "insert into DimDetails(ordernum ,itemid ,batch , qty ,serial ,post, lotid ) values ('\(orderid)','\(itemid)','\(batch)','\(qty)','\(serial)','\(post)','\(lotid)')"
            }
            print("\n dim details query --> \(query)")
            if sqlite3_exec(Databaseconnection.dbs, query, nil, nil, nil) != SQLITE_OK{
                print("Error execution in dimdetails Table")
                return
            }
        }
    
    
    
}
