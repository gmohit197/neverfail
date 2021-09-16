//
//  SYNCHUPLOADVC.swift
//  Ripple CSR
//
//  Created by aayush shukla on 22/02/20.
//  Copyright © 2020 aayush shukla. All rights reserved.
//

import UIKit

class SYNCUPLOADVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataset.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! syncuploadcell
        cell.tablename.text=dataset[indexPath.row]
        if indexPath.row % 3 == 0{
            cell.statusimage.image=UIImage(named: "error")
        }
        else{
            cell.statusimage.image=UIImage(named: "syncupload")
        }
        
        return cell
    }
    
    var dataset=[String]()
    @IBOutlet var synctable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        synctable.dataSource=self
        synctable.delegate=self
        dataset=["Product Master","Item Master","User Master","Truck Master","Notes Master","Product Master","Item Master","User Master","Truck Master","Notes Master"]

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
