//
//  PAYMENTVC.swift
//  Ripple CSR
//
//  Created by hannan parvez on 27/02/20.
//  Copyright © 2020 hannan parvez. All rights reserved.
//

import UIKit

class PAYMENTVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        return cell
     }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        paymenttypetable.dataSource=self
        paymenttypetable.delegate=self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var paymenttypetable: UITableView!
    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
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
