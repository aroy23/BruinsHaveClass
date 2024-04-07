import SwiftUI
import BottomBar_SwiftUI

struct ContentView : View {
    @State private var selectedIndex: Int = 0
    @State private var totalCoins: Int = 0
    @State private var bearsKilled: Int = 0
    @State private var health: Double = 1.0
    
    let items: [BottomBarItem] = [
        BottomBarItem(icon: "house.fill", title: "Home", color: .purple),
        BottomBarItem(icon: "chart.bar.xaxis", title: "Map", color: .pink),
        BottomBarItem(icon: "person.fill", title: "Profile", color: .orange),
    ]

    var selectedItem: BottomBarItem {
        items[selectedIndex]
    }

    var body: some View {
        NavigationView {
            VStack {
                if selectedItem.title == "Home" {
                    HomeView(item: selectedItem, totalCoins: $totalCoins, bearsKilled: $bearsKilled, health: $health)
                }
                else if selectedItem.title == "Map" {
                    MapView(item: selectedItem, totalCoins: $totalCoins, bearsKilled: $bearsKilled, health: $health)
                }
                else if selectedItem.title == "Profile" {
                    ProfileView(item: selectedItem, totalCoins: $totalCoins, bearsKilled: $bearsKilled, health: $health)
                }
                BottomBar(selectedIndex: $selectedIndex, items: items)
            }
            .navigationBarItems(trailing:
                HStack {
                    Text("Coins:")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .bold))
                    Text("\(totalCoins)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            )
            .background(Color(UIColor(red: 0.6, green: 0.9, blue: 1.0, alpha: 0.4)))
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
