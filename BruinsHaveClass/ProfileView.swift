import SwiftUI
import BottomBar_SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
struct ProfileView: View {
    let item: BottomBarItem
    @Binding var totalCoins: Int
    @Binding var bearsKilled: Int
    @Binding var health: Double

    @State private var profileData = ProfileData(name: "John Doe",
                                                 graduationYear: "2024",
                                                 totalCoins: 5000,
                                                 numberOfBearsKilled: 0)
    @State private var selectedImage: UIImage? 

    @State private var newName: String = ""
    @State private var newGraduationYear: String = ""

    @State private var isUpdateMode: Bool = false

    @State private var isImagePickerActive: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        isUpdateMode.toggle()
                        newName = profileData.name
                        newGraduationYear = profileData.graduationYear
                    }) {
                        Text(isUpdateMode ? "Cancel" : "Update")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .frame(minWidth: 0, maxWidth: 100)
                            .padding(.trailing, 20)
                    }
                }

                if !isUpdateMode {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 180, height: 180)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                    }
                    Text(profileData.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    VStack(spacing: 20) {
                        Text("Class of \(profileData.graduationYear)")
                            .font(.title)
                        Text("Number of Bears Killed: \(bearsKilled)")
                            .font(.title)
                        NavigationLink(destination: WebView(url: URL(string: "https://chdrj.github.io/SignIn-SignUp-Form/")!)) {
                            Text("Sign Up to Save Your Progress!")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    VStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }
                        Button(action: {
                            isImagePickerActive = true
                        }) {
                            Text("Change Picture")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }

                    TextField("Enter new name", text: $newName)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)

                    TextField("Enter new graduation year", text: $newGraduationYear)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }

                Spacer()
                if isUpdateMode {
                    Button(action: {
                        profileData.name = newName
                        profileData.graduationYear = newGraduationYear
                        isUpdateMode = false
                    }) {
                        Text("Save Changes")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                ForEach(0..<profileData.numberOfBearsKilled, id: \.self) { index in
                    HStack {
                        Image("dead-bear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding()
                        Text("Bear \(index + 1)")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("Profile")
        .sheet(isPresented: $isImagePickerActive) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

struct ProfileData {
    var name: String
    var graduationYear: String
    var totalCoins: Int
    var numberOfBearsKilled: Int
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(item: BottomBarItem(icon: "map.fill", title: "Map", color: .purple), totalCoins: .constant(10000), bearsKilled: .constant(10), health: .constant(1.0))
    }
}

