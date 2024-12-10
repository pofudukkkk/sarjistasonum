//
//  startView.swift
//  sarjistasonum
//
//  Created by Yusiff on 4.12.2024.
//

import UIKit
import GoogleMobileAds

class startView: UIViewController,GADBannerViewDelegate {

    @IBOutlet weak var banner: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        getLocation.shared.takeLocation()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Rectangle")!)
        getsAd()
    }
    
    @IBAction func startClicked(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "toMainView") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
     
     func getsAd(){
         banner.delegate = self
         banner.adUnitID = "ca-app-pub-3007934319345015/6841408421"
         banner.rootViewController = self
         banner.load(GADRequest())
     }
    


}
