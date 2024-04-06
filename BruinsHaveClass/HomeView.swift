//
//  HomeView.swift
//  BruinsHaveClass
//
//  Created by Arnav Roy on 4/6/24.
//

import SwiftUI
import BottomBar_SwiftUI

struct HomeView: View {
    let item: BottomBarItem
    @Binding var totalCoins: Int
    
    let captions = [
        "1000 Coins",
        "500 Coins",
        "600 Coins",
        "200 Coins",
        "600 Coins",
        "5000 Coins",
    ]

    @State private var shakingIndex: Int?

    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                    ForEach(0..<6) { index in
                        VStack {
                            Image("customimage\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .cornerRadius(10)
                                .rotationEffect(Angle(degrees: self.shakingIndex == index ? 10 : 0))
                                .onTapGesture {
                                    if let coinsString = self.captions[index].split(separator: " ").first,
                                       let coins = Int(coinsString) {
                                        if self.totalCoins < coins {
                                            withAnimation(Animation.easeInOut(duration: 0.05).repeatCount(3)) {
                                                self.shakingIndex = index
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                self.shakingIndex = nil
                                            }
                                        }
                                        else {
                                            withAnimation(Animation.easeInOut(duration: 0.3)) {
                                                self.shakingIndex = index
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                self.shakingIndex = nil
                                            }
                                            self.totalCoins -= coins
                                        }
                                    }
                                }

                            
                            Text(captions[index])
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding()
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle(item.title)
    }
}


struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView(item: BottomBarItem(icon: "house.fill", title: "Home", color: .purple), totalCoins: .constant(10000))
    }
}

