import SwiftUI
import Firebase
import FirebaseStorage

class ProfileViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    var userID: String = ""

    func fetchProfileImage() {
        let storageRef = Storage.storage().reference().child("profile_images/\(userID).jpg")
        storageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error fetching profile image: \(error.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.profileImage = image
                }
            }
        }
    }

    func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageConversionError", code: 1, userInfo: nil)))
            return
        }
        let storageRef = Storage.storage().reference().child("profile_images/\(userID).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
}
