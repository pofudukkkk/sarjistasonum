//
//  favoriDetail.swift
//  sarjistasonum
//
//  Created by Yusiff on 2.12.2024.
//

import UIKit
import CoreLocation
import MapKit
import PanModal
import GoogleMobileAds

class favoriDetail: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var favoriCollection: UICollectionView!
    
    @IBOutlet weak var plugCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
     var choose : ChargingStationsEntity?
    var plugsArray: [PlugsEntity] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        favoriCollection.delegate = self
        favoriCollection.dataSource = self
        if let choose = choose {
            nameLabel.text = choose.title
            plugCountLabel.text = "\(choose.plugsTotal) Şarj Ünitesi"
        }
        self.favoriCollection.reloadData()
        
        getsAd()

     }
    
    func getsAd(){
        banner.delegate = self
        banner.adUnitID = "..."
        banner.rootViewController = self
        banner.load(GADRequest())
    }

    
    @IBAction func goToNavigate(_ sender: Any) {
        
        let requestLocation = CLLocation(latitude: (choose?.latitude)!, longitude: (choose?.longitude)!)
        CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
            if let placemark = placemarks {
                if placemark.count > 0 {
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    item.name = self.choose?.title
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
    }
    

    

}

extension favoriDetail : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
        return plugsArray.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriCollection.dequeueReusableCell(withReuseIdentifier: "favoriCell", for: indexPath) as! favoriCell
      
            let plug = plugsArray[indexPath.row]
            
            cell.kwLabel.text = "\(plug.power) Kw"
            cell.plugLabel.text = plug.type
            cell.priceLabel.text = "\(plug.price) TL"
            cell.companyLabel.text = choose?.company
            
            cell.layer.cornerRadius = 10
            cell.vi.layer.cornerRadius = 14
            
        
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 200)
    }
    
}

extension favoriDetail:PanModalPresentable{
        var panScrollable: UIScrollView? {
            return nil
        }
        
        
        var shortFormHeight: PanModalHeight {
            
            return .contentHeight(337)
            
        }
    }
