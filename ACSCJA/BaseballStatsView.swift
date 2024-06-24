import SwiftUI

struct BaseballStatsView: View {
    @StateObject private var viewModel = BaseballStatsViewModel()
    @State private var selectedPlayer: PlayerStats?
    @State private var showingDetail = false

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        formatter.minimumIntegerDigits = 0
        return formatter
    }()

    var body: some View {
        ZStack {
            // Background Image
            Image("HomePageBackground")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Foreground Content
            VStack {
                Text("Baseball Stats")
                    .font(.largeTitle)
                    .padding()

                if viewModel.playersStats.isEmpty {
                    Text("No data available")
                        .padding()
                } else {
                    VStack(spacing: 0) {
                        // Header Row
                        HeaderRow()
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)

                        // Player Stats Rows
                        List {
                            ForEach(viewModel.playersStats.indices, id: \.self) { index in
                                Button(action: {
                                    selectedPlayer = viewModel.playersStats[index]
                                    showingDetail = true
                                }) {
                                    PlayerStatsRow(player: viewModel.playersStats[index], displayName: viewModel.getDisplayName(for: viewModel.playersStats[index].id) ?? "Unknown", numberFormatter: numberFormatter, index: index)
                                }
                                .padding(.vertical, 4)
                                .background(index % 2 == 0 ? Color.black.opacity(0.1) : Color.black.opacity(0.05))
                                .foregroundColor(.white)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.black.opacity(0.7)) // Added opacity to make the list readable over the image
                    }
                }
            }
            .offset(y: 20)
        }
        .onAppear {
            viewModel.fetchData()
        }
        .sheet(isPresented: $showingDetail) {
            if let player = selectedPlayer {
                PlayerDetailView(player: player, displayName: viewModel.getDisplayName(for: player.id), profileImageURL: viewModel.getProfileImageURL(for: player.id))
            }
        }
    }
}


struct HeaderRow: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("Hitters")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("AB")
                .font(.headline)
                .frame(width: 50, alignment: .center)
            Text("R")
                .font(.headline)
                .frame(width: 50, alignment: .center)
            Text("H")
                .font(.headline)
                .frame(width: 50, alignment: .center)
            Text("RBI")
                .font(.headline)
                .frame(width: 50, alignment: .center)
            Text("BA")
                .font(.headline)
                .frame(width: 50, alignment: .center)
            Text("HR")
                .font(.headline)
                .frame(width: 50, alignment: .center)
        }
    }
}

struct PlayerStatsRow: View {
    let player: PlayerStats
    let displayName: String
    let numberFormatter: NumberFormatter
    let index: Int

    var body: some View {
        HStack(spacing: 0) {
            Text(displayName)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(player.AB)")
                .frame(width: 50, alignment: .center)
            Text("\(player.R)")
                .frame(width: 50, alignment: .center)
            Text("\(player.H)")
                .frame(width: 50, alignment: .center)
            Text("\(player.RBI)")
                .frame(width: 50, alignment: .center)
            Text(numberFormatter.string(from: NSNumber(value: player.BA)) ?? "0.000")
                .frame(width: 50, alignment: .center)
            Text("\(player.HR)")
                .frame(width: 50, alignment: .center)
        }
    }
}







import Foundation
import FirebaseFirestoreSwift

struct PlayerStats: Identifiable, Codable {
    @DocumentID var id: String?
    var AB: Int
    var H: Int
    var R: Int
    var RBI: Int
    var BA: Double
    var HR: Int
}

import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseFirestore
class BaseballStatsViewModel: ObservableObject {
    @Published var playersStats: [PlayerStats] = []
    @Published var displayNames: [String: String] = [:]
    @Published var profileImageURLs: [String: URL] = [:]

    private var db = Firestore.firestore()

    func fetchData() {
        let group = DispatchGroup()

        group.enter()
        db.collection("BaseballStats").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    group.leave()
                    return
                }
                
                self.playersStats = documents.compactMap { document in
                    do {
                        let result = try document.data(as: PlayerStats.self)
                        return result
                    } catch let error {
                        print("Error decoding document: \(error.localizedDescription)")
                        return nil
                    }
                }
                group.leave()
            }
        }

        group.enter()
        db.collection("DisplayName").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    group.leave()
                    return
                }
                
                for document in documents {
                    if let name = document.data()["name"] as? String {
                        self.displayNames[document.documentID] = name
                    }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.objectWillChange.send()
            self.fetchProfileImages()
        }
    }

    func fetchProfileImages() {
        for player in playersStats {
            guard let playerId = player.id else { continue }
            let storageRef = Storage.storage().reference().child("profile_images/\(playerId).jpg")
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching profile image URL: \(error.localizedDescription)")
                } else if let url = url {
                    DispatchQueue.main.async {
                        self.profileImageURLs[playerId] = url
                    }
                }
            }
        }
    }

    func getDisplayName(for userId: String?) -> String? {
        guard let userId = userId else { return nil }
        return displayNames[userId]
    }

    func getProfileImageURL(for userId: String?) -> URL? {
        guard let userId = userId else { return nil }
        return profileImageURLs[userId]
    }
}


import SwiftUI

struct PlayerDetailView: View {
    let player: PlayerStats
    let displayName: String?
    let profileImageURL: URL?

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 3
        formatter.minimumIntegerDigits = 0
        return formatter
    }()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(stops: [
                .init(color: Color.black, location: 0.0),
                .init(color: Color.white, location: 0.7)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Image("EPEagle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300.0)
                
                Text(displayName ?? "Player Name")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 160, height: 160)
                        .padding()
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 150, height: 150)
                        .overlay(
                            Group {
                                if let profileImageURL = profileImageURL {
                                    AsyncImage(url: profileImageURL) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 150, height: 150)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                } else {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                }
                            }
                        )
                        .padding()
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("AB")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        Text("\(player.AB)")
                            .fontWeight(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    
                    .cornerRadius(10)
                    .foregroundColor(.black)

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("H")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        Text("\(player.H)")
                            .fontWeight(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    VStack(alignment: .leading) {
                        Text("BA")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        Text(numberFormatter.string(from: NSNumber(value: player.BA)) ?? "0.000")
                            .fontWeight(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                }
                .padding(.horizontal)

                HStack {
                    VStack(alignment: .leading) {
                        Text("R")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        Text("\(player.R)")
                            .fontWeight(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    
                    .cornerRadius(10)
                    .foregroundColor(.black)

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("RBI")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        Text("\(player.RBI)")
                            .fontWeight(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    
                    VStack(alignment: .leading) {
                        Text("HR")
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        Text("\(player.HR)")
                            .fontWeight(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    
                }
                .padding(.horizontal)
            }
        }
    }
}





