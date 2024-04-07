import SwiftUI
import BottomBar_SwiftUI

struct HealthBar: View {
    let health: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("health")
                .font(.headline)
                .fontDesign(.monospaced)
                .foregroundColor(.black)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.gray)
                        .frame(width: geometry.size.width, height: 20)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(health > 0.6 ? .green : health > 0.25 ? .yellow : .red)
                        .frame(width: geometry.size.width * CGFloat(health), height: 20)
                        .animation(.linear)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: geometry.size.width, height: 20)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct HomeView: View {
    let item: BottomBarItem
    @Binding var totalCoins: Int
    @Binding var bearsKilled: Int
    @Binding var health: Double

    
    let captions = [
        "100 Coins",
        "200 Coins",
        "500 Coins",
        "800 Coins",
    ]
    
    @State private var shakingIndex: Int?
    @State private var bearName: String = "Bear"
    @State private var isEditingBearName = false
    @State private var nameChanged = false
    @State private var timer: Timer?
    @State private var showingAlert = false
    
    
    var name: String {
        if health > 0.8 {
            return "happy-bear"
        } else if health > 0.4 {
            return "neutral-bear"
        } else if health > 0.0 {
            return "sad-bear"
        } else {
            return "dead-bear"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 400)
                    .cornerRadius(10)
                Button(action: {
                    if !nameChanged {
                        isEditingBearName = true
                    }
                }) {
                    Text(bearName)
                        .foregroundColor(.indigo)
                        .font(.system(size: 25, weight:.bold, design: .monospaced))
                }
                .sheet(isPresented: $isEditingBearName) {
                    TextField("Enter bear's name", text: $bearName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onDisappear {
                            nameChanged = true
                        }
                }
                
                VStack {
                    HealthBar(health: health)
                    if health <= 0 {
                        Text("Game Over")
                            .foregroundColor(.red)
                            .font(.headline)
                            .padding(.top)
                            .onAppear {
                                showingAlert = true
                            }
                    }
                }
                
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                        ForEach(0..<4) { index in
                            let caption = captions[index]
                            
                            VStack {
                                Image("customimage\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(10)
                                    .rotationEffect(Angle(degrees: self.shakingIndex == index ? 10 : 0))
                                    .onTapGesture {
                                        if(index == 0)
                                        {
                                            if(health <= 0.95 && totalCoins >= 100)
                                            {
                                                health += 0.049999
                                            }
                                            
                                        }
                                        else if(index == 1)
                                        {
                                            if(health <= 0.9 && totalCoins >= 200)
                                            {
                                                health += 0.0999999
                                            }
                                        }
                                        else if(index == 2)
                                        {
                                            if(health <= 0.7 && totalCoins >= 500)
                                            {
                                                health += 0.2999999
                                            }
                                        }
                                        else if(index == 3)
                                        {
                                            if(health <= 0.5 && totalCoins >= 800)
                                            {
                                                health += 0.4999999
                                            }
                                        }
                                        if let coinsString = caption.split(separator: " ").first,
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
                                
                                Text(caption)
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
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Game Over"), message: Text("Your bear's health has reached zero."), dismissButton: .default(Text("OK")) {
                    resetBear()
                    self.bearsKilled += 1
                })
            }
            .onAppear {
                self.timer = Timer.scheduledTimer(withTimeInterval: 43200, repeats: true) { _ in
                    if self.health > 0 {
                        self.health -= 0.1
                        if self.health <= 0 {
                            self.timer?.invalidate()
                        }
                    } else {
                        self.timer?.invalidate()
                    }
                }
            }
        }
    }
    
    func resetBear() {
        health = 1.0
        bearName = "Bear"
        isEditingBearName = false
        nameChanged = false
        shakingIndex = nil
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 43200, repeats: true) { _ in
            if self.health > 0 {
                self.health -= 0.1
                if self.health <= 0 {
                    self.showingAlert = true
                    self.timer?.invalidate()
                }
            } else {
                self.timer?.invalidate()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(item: BottomBarItem(icon: "house.fill", title: "Home", color: .purple), totalCoins: .constant(10000), bearsKilled: .constant(10), health: .constant(1.0))
    }
}

