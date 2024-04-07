import SwiftUI
import MapKit
import BottomBar_SwiftUI
import CoreLocation

struct MapView: View {
    let item: BottomBarItem
    @Binding var totalCoins: Int
    @Binding var bearsKilled: Int
    @Binding var health: Double
    @State private var locationName: String = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.0689, longitude: -118.4452), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var locations: [String: LocationCoordinate] = [:]
    
    @State private var classItems: [ClassItem] = []
    @State private var className: String = ""
    @State private var classTime = Date()
    @State private var selectedLocation: String = "..."
    @State private var classNameToRemove: String = ""
    @State private var isCheckIn = false
    @State private var isPopoverPresented = false
    @State private var isCheckInEnabled = false
    let locationsData: [String: CLLocationCoordinate2D] = [
        "...": CLLocationCoordinate2D(latitude: 0, longitude: 0),
        "Math Sciences Building": CLLocationCoordinate2D(latitude: 34.0715, longitude: -118.4419),
        "Bunche Hall": CLLocationCoordinate2D(latitude: 34.0719, longitude: -118.4434),
        "Boelter Hall": CLLocationCoordinate2D(latitude: 34.0684, longitude: -118.4434),
        "Moore Hall": CLLocationCoordinate2D(latitude: 34.0705, longitude: -118.4430),
        "Royce Hall": CLLocationCoordinate2D(latitude: 34.0728, longitude: -118.4406),
        "Physics and Astronomy Building": CLLocationCoordinate2D(latitude: 34.0709, longitude: -118.4413),
        "Dodd Hall": CLLocationCoordinate2D(latitude: 34.0704, longitude: -118.4413),
        "Public Affairs": CLLocationCoordinate2D(latitude: 34.0704, longitude: -118.4399),
        "Broad Art Center": CLLocationCoordinate2D(latitude: 34.0744, longitude: -118.4406),
        "Franz Hall": CLLocationCoordinate2D(latitude: 34.0700, longitude: -118.4454),
        "W. G. Young Hall": CLLocationCoordinate2D(latitude: 34.0728, longitude: -118.4456),
        "Haines Hall": CLLocationCoordinate2D(latitude: 34.0734, longitude: -118.4410),
        "Engineering VI": CLLocationCoordinate2D(latitude: 34.0686, longitude: -118.4447),
        "LaKretz Hall": CLLocationCoordinate2D(latitude: 34.0697, longitude: -118.4457),
        "Rolfe Hall": CLLocationCoordinate2D(latitude: 34.0714, longitude: -118.4423)
    ]
    
    // Add a CLLocationManager instance
    @State private var locationManager = CLLocationManager()
    
    var isLocationSelected: Bool {
        return selectedLocation != "..."
    }
    
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
                    if let coordinate = locationsData[locationName] {
                        self.locations[locationName] = LocationCoordinate(coordinate: coordinate)
                    }
                }
                .padding()
                .disabled(locationsData[locationName] == nil)
                
                Button("Remove All Pinpoints") {
                    self.locations.removeAll()
                }
                .padding()
                
                Button(action: {
                    isPopoverPresented = true
                }) {
                    Text("Add Class")
                }
                .padding()
            }
            
            List {
                ForEach(classItems) { item in
                    HStack {
                        Text("\(item.name) | \(item.formattedTime) | \(item.location)")
                        Spacer()
                        if isCheckInEnabled(for: item) {
                            Button("Check In") {
                                getCurrentLocation()
                            }
                            .foregroundColor(.blue)
                        } else {
                            Button(action: {
                                removeClass(item)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Map")
        .popover(isPresented: $isPopoverPresented, content: {
            VStack {
                TextField("Class Name", text: $className)
                DatePicker("Class Time", selection: $classTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(CompactDatePickerStyle())
                
                Picker("Location", selection: $selectedLocation) {
                    ForEach(locationsData.keys.sorted(), id: \.self) { locationName in
                        Text(locationName)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Button("Add Class") {
                    let newItem = ClassItem(name: className, time: classTime, location: selectedLocation)
                    self.classItems.append(newItem)
                    className = ""
                    isPopoverPresented = false
                    updateCheckInStatus()
                }
                .padding()
                .disabled(!isLocationSelected)
            }
            .padding()
        })
        .onAppear {
            updateCheckInStatus()
        }
    }
    
    func removeClass(_ item: ClassItem) {
        if let index = classItems.firstIndex(where: { $0.id == item.id }) {
            classItems.remove(at: index)
        }
    }
    
    func isCheckInEnabled(for item: ClassItem) -> Bool {
        let currentTime = Date()
        let fiveMinutesBeforeClass = Calendar.current.date(byAdding: .minute, value: -5, to: item.time)!
        let fiveMinutesAfterClass = Calendar.current.date(byAdding: .minute, value: 5, to: item.time)!
        return currentTime >= fiveMinutesBeforeClass && currentTime <= fiveMinutesAfterClass
    }
    
    func updateCheckInStatus() {
        let currentTime = Date()
        let fiveMinutes: TimeInterval = 5 * 60
        
        for item in classItems {
            let fiveMinutesBeforeClass = Calendar.current.date(byAdding: .second, value: Int(-fiveMinutes), to: item.time)!
            let fiveMinutesAfterClass = Calendar.current.date(byAdding: .second, value: Int(fiveMinutes), to: item.time)!
            if currentTime >= fiveMinutesBeforeClass && currentTime <= fiveMinutesAfterClass {
                isCheckInEnabled = true
                return
            }
        }
        isCheckInEnabled = false
    }

//    func getCurrentLocation() {
//        locationManager.requestWhenInUseAuthorization()
//
//        guard let userLocation = locationManager.location else {
//            print("Failed to retrieve user's location")
//            return
//        }
//
//        print("User's current location: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
//
//        if let selectedClass = classItems.first(where: { $0.location == selectedLocation }) {
//            let classCoordinate = locationsData[selectedClass.location] ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
//
//            let userLocationCLLocation = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//            let classLocationCLLocation = CLLocation(latitude: classCoordinate.latitude, longitude: classCoordinate.longitude)
//
//            let distanceInMeters = userLocationCLLocation.distance(from: classLocationCLLocation)
//            let distanceInFeet = distanceInMeters * 3.28084
//
//            if distanceInFeet <= 200 {
//                print("User is within 200 feet of the class's location. Granting 200 coins.")
//                totalCoins += 200
//            } else {
//                print("User is not within 200 feet of the class's location.")
//            }
//        } else {
//            print("Selected class not found.")
//        }
//    }
    
    func getCurrentLocation() {
        let userLatitude: CLLocationDegrees = 34.0716
        let userLongitude: CLLocationDegrees = -118.4432
        
        print("User's current location: \(userLatitude), \(userLongitude)")
        
        if let selectedClass = classItems.first(where: { $0.location == selectedLocation }) {
            let classCoordinate = locationsData[selectedClass.location] ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
            print("Selected class location: \(classCoordinate.latitude), \(classCoordinate.longitude)")
            
            let userLocationCLLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
            let classLocationCLLocation = CLLocation(latitude: classCoordinate.latitude, longitude: classCoordinate.longitude)
            
            let distanceInMeters = userLocationCLLocation.distance(from: classLocationCLLocation)
            let distanceInFeet = distanceInMeters * 3.28084 // Convert meters to feet
            
            if distanceInFeet <= 5280 {
                
                if(!isCheckIn)
                {
                    print("User is within 1 mile of the class's location. Granting 200 coins.")
                    totalCoins += 200
                    isCheckIn = true
                }
                
            } else {
                print("User is not within 200 feet of the class's location.")
            }
        } else {
            print("Selected class not found.")
        }
    }

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(item: BottomBarItem(icon: "map.fill", title: "Map", color: .purple), totalCoins: .constant(10000), bearsKilled: .constant(10), health: .constant(1.0))
    }
}

struct LocationCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct ClassItem: Identifiable {
    let id = UUID()
    let name: String
    let time: Date
    let location: String
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}
