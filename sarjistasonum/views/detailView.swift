//
//  detailView.swift
//  sarjistasonum
//
//  Created by Yusiff on 26.11.2024.
//

import UIKit
import PanModal
import CoreLocation
import MapKit
import CoreData
import GoogleMobileAds


class detailView: UIViewController, GADBannerViewDelegate{
    
    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var detailCollection: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var plugCountLabel: UILabel!
    
     var selectedStation : ChargingStation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailCollection.delegate = self
        detailCollection.dataSource = self
 
   
            if let selectedStation = selectedStation{
                nameLabel.text = selectedStation.title
                distanceLabel.text = "\(selectedStation.distance) Km "
                plugCountLabel.text = "\(selectedStation.plugsTotal) Şarj Ünitesi"
            }
        getsAd()
    }
    
    func getsAd(){
        banner.delegate = self
        banner.adUnitID = "..."
        banner.rootViewController = self
        banner.load(GADRequest())
    }
    
    @IBAction func goNavigationClicked(_ sender: Any) {
        
        let requestLocation = CLLocation(latitude: (selectedStation?.geoLocation.lat)!, longitude: (selectedStation?.geoLocation.lon)!)
        CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
            if let placemark = placemarks {
                if placemark.count > 0 {
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    item.name = self.selectedStation?.title
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
    }
    
    @IBAction func addFavoriClicked(_ sender: Any) {
        saveStation(station: selectedStation!)
        }
        
    func alert(){
        let alert = UIAlertController(title: "Kayıt Başarılı", message: "İstasyon Favori Listenize Eklendi.", preferredStyle: .actionSheet)
        let okButton = UIAlertAction(title: "Tamam", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func isStationAlreadyFavorited(stationTitle: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChargingStationsEntity")
        fetchRequest.predicate = NSPredicate(format: "title == %@", stationTitle)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.count > 0
        } catch {
            print("Hata \(error)")
            return false
        }
    }

    
   
    func saveStation(station: ChargingStation) {
        // Favorilere zaten eklenmiş mi kontrol et
        if isStationAlreadyFavorited(stationTitle: station.title) {
    
                let alert = UIAlertController(title: "Uyarı", message: "Bu istasyon zaten favorilerinizde.", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            
            return
        } else {
            alert()
        }
        
        // Core Data'da favorilere ekle
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let stationEntity = NSEntityDescription.entity(forEntityName: "ChargingStationsEntity", in: context)!
        let newStation = NSManagedObject(entity: stationEntity, insertInto: context)
        
        newStation.setValue(station.title, forKey: "title")
        newStation.setValue(station.chargingStationOperator.brand, forKey: "company")
        newStation.setValue(station.distance, forKey: "distance")
        newStation.setValue(station.geoLocation.lat, forKey: "latitude")
        newStation.setValue(station.geoLocation.lon, forKey: "longitude")
        newStation.setValue(station.plugsTotal, forKey: "plugsTotal")
        
        for plug in station.plugs {
            let plugsEntity = NSEntityDescription.entity(forEntityName: "PlugsEntity", in: context)!
            let newPlug = NSManagedObject(entity: plugsEntity, insertInto: context)
            
            newPlug.setValue(plug.power, forKey: "power")
            newPlug.setValue(plug.price, forKey: "price")
            newPlug.setValue(plug.subType.rawValue, forKey: "type")
            
            // İlişkiyi bağla
            newPlug.setValue(newStation, forKey: "chargingStation")
        }
        
        do {
            try context.save()
            print("Kayıt Başarılı")

            
        } catch {

            print("Hata, istasyon Zaten Kayıtlı...")
        }
    }

}


extension detailView:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return (selectedStation?.plugs.count)!
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailCollection.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! detailCollectionView
    
            let a = selectedStation?.plugs[indexPath.row]
            if let selectedStation = selectedStation{
                cell.companyLabel.text = selectedStation.chargingStationOperator.brand
            }
            
            cell.plugLabel.text = a?.subType.rawValue
            cell.kwLabel.text = "\(a!.power) Kw"
            cell.priceLabel.text = "\(a!.price) TL"
            cell.layer.cornerRadius = 10
            cell.vie.layer.cornerRadius = 14
   
        return cell

        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 200)
    }
    
}
    
extension detailView:PanModalPresentable{
        var panScrollable: UIScrollView? {
            return nil
        }
        
        
        var shortFormHeight: PanModalHeight {
            
            return .contentHeight(337)
            
        }
    }
