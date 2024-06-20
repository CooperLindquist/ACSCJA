//
//  AdminView.swift
//  ACSCJA
//
//  Created by Cooper Lindquist on 6/20/24.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct AdminView: View {
    @StateObject private var viewModel = AdminViewModel()
    var sport: String

    var body: some View {
        List(viewModel.requests) { request in
            HStack {
                Text(request.userID)
                Spacer()
                Button(action: {
                    viewModel.approveRequest(for: request, in: sport)
                }) {
                    Text("Approve")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .onAppear {
            viewModel.getJoinRequests(for: sport)
        }
    }
}

class AdminViewModel: ObservableObject {
    @Published var requests: [JoinRequest] = []
    private var db = Firestore.firestore()

    func getJoinRequests(for sport: String) {
        db.collection(sport).whereField("Member", isEqualTo: false).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting join requests: \(error)")
            } else {
                self.requests = snapshot?.documents.compactMap { document in
                    return JoinRequest(userID: document.documentID)
                } ?? []
            }
        }
    }

    func approveRequest(for request: JoinRequest, in sport: String) {
        db.collection(sport).document(request.userID).updateData(["Member": true]) { error in
            if let error = error {
                print("Error approving request: \(error)")
            } else {
                self.getJoinRequests(for: sport)
            }
        }
    }
}

struct JoinRequest: Identifiable {
    var id: String { userID }
    var userID: String
}

