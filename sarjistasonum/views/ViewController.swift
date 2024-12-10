//
//  ViewController.swift
//  sarjistasonum
//
//  Created by Yusiff on 25.11.2024.
//

import UIKit
import MapKit
import PanModal
import GoogleMobileAds

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var banner: GADBannerView!
    @IBOutlet weak var mapView: MKMapView!
 
    
    private let manager = CLLocationManager()
    var latitude = Double()
    var longitude = Double()
   
    
    private let vCm = viewModel(services: services())
    var chargeResult = [ChargingStation]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        manager.startUpdatingLocation()
        vCm.delegate = self
        vCm.fetchData()
        latitude = getLocation.shared.latitude ?? 0.2
        longitude = getLocation.shared.longitude ?? 89.4
        mapDelegate()
        getsAd()
   
    }
    
    func getsAd(){

        banner.delegate = self
        banner.adUnitID = "..."
        banner.rootViewController = self
        banner.load(GADRequest())
    }
    
   private func mapDelegate(){
        let lcoation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: lcoation, span: span)
        mapView.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard control == view.rightCalloutAccessoryView,
        let customAnnotation = view.annotation as? CustomAnnotation else { return }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "toDetail") as! detailView
        vc.selectedStation = customAnnotation.locationData
        presentPanModal(vc)
    }

  
    
    @IBAction func listButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "toSecond") as! listView
        presentPanModal(vc)
    }
    private  func addAnnotations() {
            for location in chargeResult {
                let annotation = CustomAnnotation(location: location)
                annotation.title = location.title
                mapView.addAnnotation(annotation)
            }
        }
    

    @IBAction func listClicked(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "toFavori") as! favoriListView
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
        
        let identifier = "CustomAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "4")
            annotationView?.frame.size = CGSize(width: 55, height: 60)
            let detailButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailButton
       
      
          } else {
              annotationView?.annotation = customAnnotation
          }

        return annotationView
    }
    
    
    @IBAction func locationClicked(_ sender: Any) {
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
         
         latitude = location.coordinate.latitude
         longitude = location.coordinate.longitude
         mapDelegate()
         vCm.fetchData()
        manager.stopUpdatingLocation()
    }
    
}

extension ViewController:outPut{
    internal func outPut(_ endpoint: endPointOutPut) {
        DispatchQueue.main.async {
            switch endpoint{
            case .nearest(let results):
                self.chargeResult.removeAll()
                self.chargeResult.append(contentsOf: results)
                self.addAnnotations()

            }
        }
    
    }
    
    
}


