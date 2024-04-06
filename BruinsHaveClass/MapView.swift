import SwiftUI
import MapKit
import BottomBar_SwiftUI

struct MapView: View {
    let item: BottomBarItem
    @Binding var totalCoins: Int
    @State private var locationName: String = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.0689, longitude: -118.4452), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var locations: [String: LocationCoordinate] = [:]
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: Array(locations.values)) { location in
                MapPin(coordinate: location.coordinate)
            }
            .frame(height: 300)
            .padding()
            
            TextField("Location Name", text: $locationName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Add Pinpoint") {
                    if locationName == "UCLA" {
                        // Add coordinates for UCLA
                        let uclaCoordinate = CLLocationCoordinate2D(latitude: 34.0689, longitude: -118.4452)
                        self.locations[locationName] = LocationCoordinate(coordinate: uclaCoordinate)
                    } else {
                        // Convert location name to coordinates using geocoding
                        let geocoder = CLGeocoder()
                        geocoder.geocodeAddressString(locationName) { placemarks, error in
                            if let placemark = placemarks?.first, let location = placemark.location {
                                let coordinate = location.coordinate
                                let newRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                                self.region = newRegion
                                
                                // Add location to the dictionary
                                self.locations[locationName] = LocationCoordinate(coordinate: coordinate)
                            }
                        }
                    }
                }
                .padding()
                
                Button("Remove All Pinpoints") {
                    self.locations.removeAll()
                }
                .padding()
            }
            
            Spacer()
        }
        .navigationTitle("Map")
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(item: BottomBarItem(icon: "map.fill", title: "Map", color: .purple), totalCoins: .constant(10000))
    }
}

struct LocationCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

