//
//  ContentView.swift
//  BruinsHaveClass
//
//  Created by Arnav Roy on 4/6/24.
//

import SwiftUI
import BottomBar_SwiftUI

struct ContentView : View {
    @State private var selectedIndex: Int = 0
    @State private var totalCoins: Int = 10000 // Initial total coins
    
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
                    HomeView(item: selectedItem, totalCoins: $totalCoins)
                }
                else if selectedItem.title == "Map" {
                    MapView(item: selectedItem, totalCoins: $totalCoins)
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

