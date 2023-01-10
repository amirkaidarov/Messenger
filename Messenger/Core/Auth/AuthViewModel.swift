//
//  AuthViewModel.swift
//  Messenger
//
//  Created by Амир Кайдаров on 1/9/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class AuthViewModel : ObservableObject {
    
    @Published var userSession : FirebaseAuth.User? {
        didSet {
            isUserLoggedIn = userSession != nil
        }
    }
    @Published var isLoginMode = true
    @Published var currentUser : ChatUser?
    @Published var isUserLoggedIn : Bool = false
    
    @Published var loginStatusMessege = ""
    
    private let service = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    func login(email : String, password : String, completion: @escaping() -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginStatusMessege = error.localizedDescription
                return
            }
            
            self.loginStatusMessege = ""
            
            self.userSession = result?.user
            self.fetchUser()
            completion()
        }
        
    }
    
    func register(email : String, password : String, image : UIImage?, username : String, completion: @escaping() -> Void) {
        guard let image = image else {
            self.loginStatusMessege = "Please provide profile photo"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.loginStatusMessege = error.localizedDescription
                return
            }
            
            guard let user = result?.user else { return }
            
            self.persistImageToStorage(image, uid: user.uid) { url in
                let data = ["email": email,
                            "uid": user.uid,
                            "imageURL": url,
                            "username": username.lowercased()]
                
                Firestore.firestore().collection("users")
                    .document(user.uid)
                    .setData(data) { error in
                        if let error = error {
                            self.loginStatusMessege = error.localizedDescription
                            return
                        }
                        self.loginStatusMessege = ""
                        self.userSession = user
                        self.fetchUser()
                        completion()
                    }
            }
        }
    }
    
    private func persistImageToStorage(_ image : UIImage, uid: String, completion : @escaping(String) -> Void) {
        let ref = Storage.storage().reference(withPath: uid)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData) { metadata, error in
            if let error = error {
                self.loginStatusMessege = error.localizedDescription
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    self.loginStatusMessege = error.localizedDescription
                }
                
                guard let url = url else { return }
                completion(url.absoluteString)
                
                self.loginStatusMessege = ""
                
                return
            }
        }
    }
    
    func signOut() {
        self.userSession = nil
        try? Auth.auth().signOut()
    }
    
    private func fetchUser() {
        if let uid = userSession?.uid {
            service.fetchUser(with: uid) { user in
                self.currentUser = user
            }
        }
    }
}

