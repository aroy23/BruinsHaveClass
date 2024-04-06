//
//  MapView.swift
//  BruinsHaveClass
//
//  Created by Arnav Roy on 4/6/24.
//

import SwiftUI
import MapKit
import BottomBar_SwiftUI

struct MapView: View {
    let item: BottomBarItem
    @Binding var totalCoins: Int
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ) // Default region (San Francisco) for initial display
    
    @State private var destination: String = "" // Destination entered by the user
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 300)
                .cornerRadius(10)
                .padding()
            
            TextField("Enter Destination", text: $destination, onCommit: {
                // Geocode the entered location and update region
                geocodeAndSetRegion()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Spacer()
        }
        .navigationBarTitle(Text(item.title).bold())
    }
    
    private func geocodeAndSetRegion() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(destination) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                // Handle error or display alert
                print("Error geocoding location:", error?.localizedDescription ?? "")
                return
            }
            let coordinate = location.coordinate
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(item: BottomBarItem(icon: "map.fill", title: "Map", color: .purple), totalCoins: .constant(10000))
    }
}


