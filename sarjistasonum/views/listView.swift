//
//  listView.swift
//  sarjistasonum
//
//  Created by Yusiff on 25.11.2024.
//

import UIKit
import PanModal
import GoogleMobileAds

class listView: UIViewController, GADBannerViewDelegate {
    

    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    private let secondTableView : jsonTableView = jsonTableView()
    private let vCm = viewModel(services: services())
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        vCm.delegate = self
        vCm.fetchData()
        initDelegate()
        getsAd()

    }

    private func initDelegate(){
        tableView.delegate = secondTableView
        tableView.dataSource = secondTableView
        secondTableView.delegate = self

}
  
    func getsAd(){
        banner.delegate = self
        banner.adUnitID = "..."
        banner.rootViewController = self
        banner.load(GADRequest())
    }
    
    
    
}

extension listView:jsonTableViewOutPut{
    func onSelected(item: ChargingStation) {

       let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "toDetail") as! detailView
        vc.selectedStation = item
        presentPanModal(vc)
        print(item.title)

    }
    
    
}

extension listView:outPut{
    func outPut(_ endpoint: endPointOutPut) {
        DispatchQueue.main.async {
            switch endpoint{
            case .nearest(let results):
                self.secondTableView.updates(items: results)
                self.tableView.reloadData()

            }
        }
    
    }
    
    
}



extension listView:PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }
    
    
    
    
    var shortFormHeight: PanModalHeight {
        
            return .contentHeight(700)
    
    }
}
