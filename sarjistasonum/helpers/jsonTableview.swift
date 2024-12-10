//
//  jsonTableview.swift
//  sarjistasonum
//
//  Created by Yusiff on 26.11.2024.
//

import UIKit


protocol jsonTableViewProtocol{
    func updates(items:[ChargingStation])
}

protocol jsonTableViewOutPut: AnyObject{
    func onSelected(item:ChargingStation)
}

final class jsonTableView:NSObject{
    
    private lazy var items : [ChargingStation] = []
    
    weak var delegate:jsonTableViewOutPut?

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! listCell
        cell.titleLabel.text = items[indexPath.row].title
        let a = items[indexPath.row]
        cell.plugLabel.text = String(a.plugs[indexPath.section].subType.rawValue)
       cell.priceLabel.text = "\(a.plugs[indexPath.section].price) TL"
        cell.operatorName.text = String(a.chargingStationOperator.brand)
        cell.powerText.text = "\(a.plugs[indexPath.section].power) Kw"
        cell.distanceLabel.text = "\(a.distance) Km"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onSelected(item: items[indexPath.row])
    }

}

extension jsonTableView:UITableViewDelegate,UITableViewDataSource{}
extension jsonTableView:jsonTableViewProtocol{
    func updates(items: [ChargingStation]) {
        self.items = items
    }
    
    
}


