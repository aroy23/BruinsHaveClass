import SwiftUI
import BottomBar_SwiftUI

struct ProfileView: View {
    let item: BottomBarItem
    @Binding var totalCoins: Int
    @Binding var bearsKilled: Int
    @Binding var health: Double

    // Sample user profile data
    @State private var profileData = ProfileData(name: "John Doe",
                                                 graduationYear: "2024",
                                                 totalCoins: 5000,
                                                 numberOfBearsKilled: 0)
    @State private var selectedImage: UIImage? // Selected profile image

    // State variables to hold the user's input for the new values
    @State private var newName: String = ""
    @State private var newGraduationYear: String = ""

    // State variable to track whether the update mode is active
    @State private var isUpdateMode: Bool = false

    // State variable to track whether the image picker is active
    @State private var isImagePickerActive: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        isUpdateMode.toggle()
                        // Reset new values when entering update mode
                        newName = profileData.name
                        newGraduationYear = profileData.graduationYear
                    }) {
                        Text(isUpdateMode ? "Cancel" : "Update")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .frame(minWidth: 0, maxWidth: 100) // Set max width to limit button size
                            .padding(.trailing, 20) // Add trailing padding to move it to the right
                    }
                }

                if !isUpdateMode {
                    // Display the regular profile data
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
                    }
                } else {
                    // Display text fields to update the profile data
                    VStack {
                        // Display profile image without allowing selection
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

                Spacer() // Add spacer to push the button to the bottom

                if isUpdateMode {
                    Button(action: {
                        // Save changes to the profile
                        profileData.name = newName
                        profileData.graduationYear = newGraduationYear
                        isUpdateMode = false // Exit update mode
                    }) {
                        Text("Save Changes")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                // Add dead bear image with name
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

// Sample user profile data
struct ProfileData {
    var name: String
    var graduationYear: String
    var totalCoins: Int
    var numberOfBearsKilled: Int
}

// DO NOT TOUCH
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(item: BottomBarItem(icon: "map.fill", title: "Map", color: .purple), totalCoins: .constant(10000), bearsKilled: .constant(10), health: .constant(1.0))
    }
}
