//
//  favoriListView.swift
//  sarjistasonum
//
//  Created by Yusiff on 1.12.2024.
//

import UIKit
import CoreData
import PanModal
import GoogleMobileAds
class favoriListView: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {
    
    var fetchStation : [ChargingStationsEntity] = []
    var savedStation : ChargingStationsEntity?
    
    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        getsAd()
    }
    
    func getsAd(){
        banner.delegate = self
        banner.adUnitID = "ca-app-pub-3007934319345015/7068639139"
        banner.rootViewController = self
        banner.load(GADRequest())
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchStation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = fetchStation[indexPath.row].title
        content.textProperties.font = UIFont(name: "DIN Condensed Bold", size: 22) ?? UIFont()
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        savedStation = fetchStation[indexPath.row]
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "toFavoriDetail") as! favoriDetail
        
        if let plugsSet = savedStation!.plugs as? Set<PlugsEntity> {
            vc.plugsArray = Array(plugsSet) 
            
            vc.choose = savedStation
            presentPanModal(vc)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        if editingStyle == .delete{
            let stationDelete = fetchStation[indexPath.row]
            context.delete(stationDelete)
            fetchStation.remove(at: indexPath.row)
            do {
               try context.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                         print("Silme sırasında hata: \(error)")
                     }
                 }
        }
    
   private func fetchData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ChargingStationsEntity> = ChargingStationsEntity.fetchRequest()
        fetchRequest.relationshipKeyPathsForPrefetching = ["plugs"] // İlişkili plugs verilerini de getir
        
        do {
            fetchStation = try context.fetch(fetchRequest)
            print("Fetched \(fetchStation.count) stations.")
            for station in fetchStation {
                print("Station Title: \(station.title )")
                if let plugsSet = station.plugs as? Set<PlugsEntity> {
                    plugsSet.forEach { plug in

                    }
                } else {
                    print("pluglar gelmedi"  )
                }
            }
        } catch {
            print("Failed to fetch stations: \(error)")
        }

        }
  
    }



        
extension favoriListView:PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }
    

    var shortFormHeight: PanModalHeight {
            return .contentHeight(700)
    }
}

            
            
        

        
    


