//
//  TREEVIEW.swift
//  Neverfail
//
//  Created by Acxiom Consulting on 10/03/21.
//  Copyright © 2021 aayush shukla. All rights reserved.
//

import UIKit
import SQLite3
import LNZTreeView

class CustomUITableViewCell: UITableViewCell
{
    override func layoutSubviews() {
        super.layoutSubviews();
        
        guard var imageFrame = imageView?.frame else { return }
        
        let offset = CGFloat(indentationLevel) * indentationWidth
        imageFrame.origin.x += offset
        imageView?.frame = imageFrame
    }
}

class Node: NSObject, TreeNodeProtocol {
    var identifier: String
    var id: String
    var isExpandable: Bool {
        return children != nil
    }
    
    var children: [Node]?
    
    init(withIdentifier identifier: String, id : String, andChildren children: [Node]? = nil) {
        self.identifier = identifier
        self.children = children
        self.id = id
    }
}

class TREEVIEW: BASEACTIVITY, LNZTreeViewDelegate, LNZTreeViewDataSource {
    
    func numberOfSections(in treeView: LNZTreeView) -> Int {
        return 1
    }
    
    func treeView(_ treeView: LNZTreeView, heightForNodeAt indexPath: IndexPath, forParentNode parentNode: TreeNodeProtocol?) -> CGFloat {
        return 50
    }
    
    func treeView(_ treeView: LNZTreeView, numberOfRowsInSection section: Int, forParentNode parentNode: TreeNodeProtocol?) -> Int {
        guard let parent = parentNode as? Node else {
            return root.count
        }
        
        return parent.children?.count ?? 0
    }
    
    func treeView(_ treeView: LNZTreeView, didSelectNodeAt indexPath: IndexPath, forParentNode parentNode: TreeNodeProtocol?) {
        let node: Node
        if let parent = parentNode as? Node {
            node = parent.children![indexPath.row]
        } else {
            node = root[indexPath.row]
        }
        let id = node.id
        self.deletetable(tbl: "caseentry")
        insertcasetable(custid: CUSTORDERVC.custid!,userid : UserDefaults.standard.string(forKey: "userid")! ,caseid : self.uid, type : id,status : "0",date : self.getdate(format: "yyyy-MM-dd"),contid: CUSTORDERVC.contid!, state: "", post: "0")
            let nvc = self.storyboard?.instantiateViewController(withIdentifier: "CEVC") as! CASEENTRYVC
            nvc.uid = self.uid
            nvc.casetype = node.identifier
            self.navigationController?.pushViewController(nvc, animated: true)
//        self.showToast(message: "selected item - \(node.identifier)")
    }
    
    func treeView(_ treeView: LNZTreeView, nodeForRowAt indexPath: IndexPath, forParentNode parentNode: TreeNodeProtocol?) -> TreeNodeProtocol {
        guard let parent = parentNode as? Node else {
            return root[indexPath.row]
        }

        return parent.children![indexPath.row]
    }
    
    func treeView(_ treeView: LNZTreeView, cellForRowAt indexPath: IndexPath, forParentNode parentNode: TreeNodeProtocol?, isExpanded: Bool) -> UITableViewCell {
        
        let node: Node
        if let parent = parentNode as? Node {
            node = parent.children![indexPath.row]
        } else {
            node = root[indexPath.row]
        }
        let cell = treeView.dequeueReusableCell(withIdentifier: "cell")!
        
//        cell = treeView.dequeueReusableCell(withIdentifier: "cell", for: node, inSection: indexPath.section)

        if node.isExpandable {
            if isExpanded {
                cell.imageView?.image = #imageLiteral(resourceName: "collapse")
            } else {
                cell.imageView?.image = #imageLiteral(resourceName: "expand")
            }
        } else {
            cell.imageView?.image = nil
        }
        
        cell.textLabel?.text = node.identifier
        
        return cell
    }
    
    @IBOutlet var treeView: LNZTreeView!
    
    var root = [Node]()
    var uid: String!
    
    override func viewWillAppear(_ animated: Bool) {
        self.setnav(title: self.navigationItem.title!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        treeView.delegate = self
        treeView.dataSource = self
        self.uid = self.getdate(format: "dd-MMM-yy hh:mm:ss.SSS")
        treeView.register(CustomUITableViewCell.self, forCellReuseIdentifier: "cell")

        treeView.tableViewRowAnimation = .right
//        treeView.keyboardDismissMode = .none
//        generateRandomNodes()
        settree()
        treeView.resetTree()
    }
    
    func generateRandomNodes() {
        let depth = 3
        let rootSize = 2
        
        var root: [Node]!
        
        var lastLevelNodes: [Node]?
        for i in 0..<depth {
            guard let lastNodes = lastLevelNodes else {
                root = generateNodes(rootSize, depthLevel: i)
                lastLevelNodes = root
                continue
            }
            
            var thisDepthLevelNodes = [Node]()
            for node in lastNodes {
                guard arc4random()%2 == 1 else { continue }
                let childrenNumber = Int(arc4random()%20 + 1)
                let children = generateNodes(childrenNumber, depthLevel: i)
                node.children = children
                thisDepthLevelNodes += children
            }
            
            lastLevelNodes = thisDepthLevelNodes
        }
        
        self.root = root
    }
    
    func generateNodes(_ numberOfNodes: Int, depthLevel: Int) -> [Node] {
        let nodes = Array(0..<numberOfNodes).map { i -> Node in
            return Node(withIdentifier: "\(arc4random()%UInt32.max)", id: "")
        }
        
        return nodes
    }
    
    func gettypeidfromname(name : String) -> String{
        var id = ""
        
        let query = "select a.type as root , b.type as child,b.typeid,a.typeid as rootid from casetype a left outer join (select * from CaseType where parentid <> '') b on a.typeid = b.parentid where b.type <> '' and b.type = '\(name)'"
        
        var stmt1:OpaquePointer?

        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return ""
        }
        if(sqlite3_step(stmt1) == SQLITE_ROW){
            id = String(cString: sqlite3_column_text(stmt1, 2))
        }
        return id
    }
    
    func settree() {
        let depth = 10
        
        var root: [Node]!
        
        var lastLevelNodes: [Node]?
        for i in 0..<depth {
            guard let lastNodes = lastLevelNodes else {
                root = getnode(depthlevel: i)
                lastLevelNodes = root
                continue
            }
            
            var thisDepthLevelNodes = [Node]()
            for node in lastNodes {
                var childcount = 1;
                if (i > 0){
                    self.getdataarr(depth: i,str: node.id)
                    childcount = self.childarr.count
                }
                guard childcount > 0 else { continue }
                let children = getnode(depthlevel: i,str: node.id)
                node.children = children
                thisDepthLevelNodes += children
            }
            
            lastLevelNodes = thisDepthLevelNodes
        }
        
        self.root = root
    }
    
    func getnode(depthlevel: Int, str: String = "") -> [Node]{
        
        self.getdataarr(depth: depthlevel,str: str)
        var numberOfNodes = 0
        var arr = [String]()
        var idarr = [String]()
        arr.removeAll()
        idarr.removeAll()
        
        if (depthlevel > 0){
            numberOfNodes = self.childarr.count
            arr = self.childarr
            idarr = self.childidarr
        }else if (depthlevel == 0){
            numberOfNodes = self.rootarr.count
            arr = self.rootarr
            idarr = self.rootidarr
        }
        
        let nodes = Array(0..<numberOfNodes).map { i -> Node in
            return Node(withIdentifier: "\(arr[i])", id: "\(idarr[i])")
        }
        
        return nodes
    }
    var rootarr = [String]()
    var childarr = [String]()
    var rootidarr = [String]()
    var childidarr = [String]()
    
    func getdataarr(depth: Int, str: String = "") {
        var query = ""
        if (depth > 0){
            childarr.removeAll()
            childidarr.removeAll()
            query = "select b.type as child,b.typeid,a.type as root ,a.typeid as rootid from casetype a left outer join (select * from CaseType where parentid <> '') b on a.typeid = b.parentid where a.typeid = '\(str)' and b.type <> ''"
        }else if (depth == 0){
            rootarr.removeAll()
            rootidarr.removeAll()
            query = "select type,typeid from CaseType where parentid = ''"
        }
        
        var stmt1:OpaquePointer?
//         query = "select a.type as root , b.type as child,b.typeid,a.typeid as rootid from casetype a left outer join (select * from CaseType where parentid <> '') b on a.typeid = b.parentid where b.type <> ''"

        if  sqlite3_prepare_v2(Databaseconnection.dbs,query, -1, &stmt1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(Databaseconnection.dbs)!)
            print("error preparing get: \(errmsg)")
            return
        }
        while(sqlite3_step(stmt1) == SQLITE_ROW){
            let node = String(cString: sqlite3_column_text(stmt1, 0))
            let id = String(cString: sqlite3_column_text(stmt1, 1))
            if (depth > 0){
                childarr.append(node)
                childidarr.append(id)
            }else if (depth == 0){
                rootarr.append(node)
                rootidarr.append(id)
            }
        }
    }
    
    
    
    
    
}

