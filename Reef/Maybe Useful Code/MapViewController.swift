//
//  MapViewController.swift
//  Reef
//
//  Created by Ira Einbinder on 1/19/22.
//

// MARK: Map Information that will be useful

//https://github.com/dr5hn/countries-states-cities-database
//https://countrystatecity.in
//
//https://medium.com/@pravinbendre772/search-for-places-and-display-results-using-mapkit-a987bd6504df

import UIKit

import MapKit

class MapViewController: UIViewController {
    let locationManager = CLLocationManager()
    
    var search : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
//        //locationManager.requestLocation()
//
//        let localSearch = MKLocalSearch()
//
//        let request = MKLocalSearch.Request()
//        request.resultTypes = .address
//        let url = URL(string: "https://api.countrystatecity.in/v1/states")!
//        var request = URLRequest(url: url)
//        request.addValue("X-CSCAPI-KEY", forHTTPHeaderField: "API_KEY")
//        let cat = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            print(data?.description)
//            print(response?.description)
//            let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//
//            print(jsonResult)
//
//        }
//        cat.resume()
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

//extension MapViewController : CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print("here?")
//    }
//}
